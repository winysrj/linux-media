Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:45829 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbbG3TG6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 15:06:58 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [RFC PATCH] lib: scatterlist: add sg splitting function
Date: Thu, 30 Jul 2015 21:02:15 +0200
Message-Id: <1438282935-3448-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes a scatter-gather has to be split into several chunks, or sub scatter
lists. This happens for example if a scatter list will be handled by multiple
DMA channels, each one filling a part of it.

A concrete example comes with the media V4L2 API, where the scatter list is
allocated from userspace to hold an image, regardless of the knowledge of how
many DMAs will fill it :
 - in a simple RGB565 case, one DMA will pump data from the camera ISP to memory
 - in the trickier YUV422 case, 3 DMAs will pump data from the camera ISP pipes,
   one for pipe Y, one for pipe U and one for pipe V

For these cases, it is necessary to split the original scatter list into
multiple scatter lists, which is the purpose of this patch.

The guarantees that are required for this patch are :
 - the intersection of spans of any couple of resulting scatter lists is empty
 - the union of spans of all resulting scatter lists is a subrange of the span
   of the original scatter list
 - if streaming DMA API operations (mapping, unmapping) should not happen both
   on both the resulting and the original scatter list. It's either the first or
   the later ones.
 - the caller is reponsible to call kfree() on the resulting scatterlists

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

---
The sg_split() function is an attempt to address the splitting in a generic
way. If it is judged unsuitable, it will remain as a specialized function in the
depths of a media driver.

Memo of people to ask:
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
---
 include/linux/scatterlist.h |   3 ++
 lib/scatterlist.c           | 122 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 9b1ef0c820a7..cee8648a6918 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -251,6 +251,9 @@ struct scatterlist *sg_next(struct scatterlist *);
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
 void sg_init_table(struct scatterlist *, unsigned int);
 void sg_init_one(struct scatterlist *, const void *, unsigned int);
+int sg_split(struct scatterlist *in, const off_t skip, const int nb_splits,
+	     const size_t *split_sizes, struct scatterlist **out,
+	     gfp_t gfp_mask);
 
 typedef struct scatterlist *(sg_alloc_fn)(unsigned int, gfp_t);
 typedef void (sg_free_fn)(struct scatterlist *, unsigned int);
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index d105a9f56878..c4415a2af0ec 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -759,3 +759,125 @@ size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 	return sg_copy_buffer(sgl, nents, buf, buflen, skip, true);
 }
 EXPORT_SYMBOL(sg_pcopy_to_buffer);
+
+struct sg_splitter {
+	struct scatterlist *in_sg0;
+	int nents;
+	off_t skip_sg0;
+	size_t len_last_sg;
+	struct scatterlist *out_sg;
+};
+
+static struct sg_splitter *sg_calculate_split(struct scatterlist *in,
+					      off_t skip, const size_t *sizes,
+					      int nb_splits, gfp_t gfp_mask)
+{
+	int i;
+	size_t size = sizes[0], len;
+	struct sg_splitter *splitters, *curr;
+	struct scatterlist *sg;
+
+	splitters = kcalloc(nb_splits, sizeof(*splitters), gfp_mask);
+	if (!splitters)
+		return NULL;
+
+	curr = splitters;
+	for_each_sg(in, sg, sg_nents(in), i) {
+		if (skip > sg_dma_len(sg)) {
+			skip -= sg_dma_len(sg);
+			continue;
+		}
+		len = min_t(size_t, size, sg_dma_len(sg) - skip);
+		if (!curr->in_sg0) {
+			curr->in_sg0 = sg;
+			curr->skip_sg0 = sg_dma_len(sg) - len;
+		}
+		size -= len;
+		curr->nents++;
+		if (!size) {
+			curr->len_last_sg = len;
+			size = *(++sizes);
+
+			if (!--nb_splits)
+				break;
+
+			curr++;
+			if (len < sg_dma_len(sg) - skip) {
+				curr->in_sg0 = sg;
+				curr->skip_sg0 = sg_dma_len(sg) - skip - len;
+				curr->nents++;
+			}
+		}
+	}
+
+	return splitters;
+}
+
+/**
+ * sg_split - split a scatterlist into several scatterlists
+ * @in: the input sg list
+ * @skip: the number of bytes to skip in the input sg list
+ * @nb_splits: the number of desired sg outputs
+ * @split_sizes: the respective size of each output sg list in bytes
+ * @out: an array where to store the allocated output sg lists
+ * @gfp_mask: the allocation flag
+ *
+ * This function splits the input sg list into nb_splits sg lists, which are
+ * allocated and stored into out.
+ * The @in is split into :
+ *  - @out[0], which covers bytes [@skip .. @skip + @split_sizes[0] - 1] of @in
+ *  - @out[1], which covers bytes [@skip + split_sizes[0] ..
+ *                                 @skip + @split_sizes[0] + @split_sizes[1] -1]
+ * etc ...
+ * It will be the caller's duty to kfree() out array members.
+ *
+ * Returns 0 upon success, or error code
+ */
+int sg_split(struct scatterlist *in, const off_t skip, const int nb_splits,
+		    const size_t *split_sizes, struct scatterlist **out,
+		    gfp_t gfp_mask)
+{
+	int i, j;
+	struct scatterlist *in_sg, *out_sg;
+	struct sg_splitter *splitters, *split;
+
+	splitters = sg_calculate_split(in, 0, split_sizes, nb_splits, gfp_mask);
+	if (!splitters)
+		return -ENOMEM;
+
+	for (i = 0; i < nb_splits; i++) {
+		splitters[i].out_sg = kmalloc_array(splitters[i].nents,
+						    sizeof(struct scatterlist),
+						    gfp_mask);
+		if (!splitters[i].out_sg)
+			goto err;
+	}
+
+	for (i = 0, split = splitters; i < nb_splits; i++, split++) {
+		in_sg = split->in_sg0;
+		out_sg = split->out_sg;
+		out[i] = out_sg;
+		for (j = 0; j < split->nents; j++, out_sg++) {
+			*out_sg = *in_sg;
+			if (!j) {
+				out_sg->offset = split->skip_sg0;
+				sg_dma_len(out_sg) -= split->skip_sg0;
+			} else {
+				out_sg->offset = 0;
+			}
+			in_sg = sg_next(in_sg);
+		}
+		sg_dma_len(--out_sg) = split->len_last_sg;
+		sg_mark_end(out_sg);
+	}
+
+	kfree(splitters);
+	return 0;
+
+err:
+	for (i = 0; i < nb_splits; i++)
+		kfree(splitters[i].out_sg);
+	kfree(splitters);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(sg_split);
-- 
2.1.4

