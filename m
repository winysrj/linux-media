Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:21339 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbHANVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2015 09:21:08 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [RFC PATCH v2] lib: scatterlist: add sg splitting function
Date: Sat,  1 Aug 2015 15:17:13 +0200
Message-Id: <1438435033-7636-1-git-send-email-robert.jarzmik@free.fr>
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
Since v1: Russell's review
 - address both the sg_phys case and sg_dma_address case (aka mapped
   case)
   => this should take care of IOMMU coalescing
 - add a way to return the new mapped lengths of resulting scatterlists
 - add bound checks (EINVAL) for corner cases :
     - skip > sum(sgi->length) or
       skip > sum(sg_dma_len(sgi))
     - sum(sizei) > skip + sum(sgi->length) or
       sum(sizei) > skip + sum(sg_dma_len(sgi))
 - fixed algorithm for single sgi split into multiple sg entries
   (case where very small sizes, ie. size0+size1+size2 < sg0_length)

Russell, this new attempt still aims at having both unmapped and mapped
cases covered. As my understanding of coalescing might still be
partial, please point me out the defects.

And I'm not sure I have properly addressed this comment of yours :
    "I'm not sure that there's any requirement for dma_map_sg() to mark
    the new end of the scatterlist as that'd result in information loss
    when subsequently unmapping.".
I think marking the last sg entry (ie. the one for physical addresses,
not the last of the mapped ones) is correct in the v2 patch, but I might
oversee something, just for confirmation it is addressed.

One last point is that if this attempt is correct enough, I still need
some automation testing passed on it, as there are a lot of
possibilities between input parameters (skip, sizes[], in) which would
need some proper testing.

Memo of people to ask:
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org

squash! lib: scatterlist: add sg splitting function
---
 include/linux/scatterlist.h |   5 ++
 lib/scatterlist.c           | 189 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 194 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 9b1ef0c820a7..5fa4ab1a4605 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -251,6 +251,11 @@ struct scatterlist *sg_next(struct scatterlist *);
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
 void sg_init_table(struct scatterlist *, unsigned int);
 void sg_init_one(struct scatterlist *, const void *, unsigned int);
+int sg_split(struct scatterlist *in, const int in_mapped_nents,
+	     const off_t skip, const int nb_splits,
+	     const size_t *split_sizes,
+	     struct scatterlist **out, int *out_mapped_nents,
+	     gfp_t gfp_mask);
 
 typedef struct scatterlist *(sg_alloc_fn)(unsigned int, gfp_t);
 typedef void (sg_free_fn)(struct scatterlist *, unsigned int);
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index d105a9f56878..325f831bda47 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -759,3 +759,192 @@ size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 	return sg_copy_buffer(sgl, nents, buf, buflen, skip, true);
 }
 EXPORT_SYMBOL(sg_pcopy_to_buffer);
+
+struct sg_splitter {
+	struct scatterlist *in_sg0;
+	int nents;
+	off_t skip_sg0;
+	unsigned int length_last_sg;
+
+	struct scatterlist *out_sg;
+};
+
+static int sg_calculate_split(struct scatterlist *in, int nents, int nb_splits,
+			      off_t skip, const size_t *sizes,
+			      struct sg_splitter *splitters, bool mapped)
+{
+	int i, rjk = nb_splits;
+	unsigned int sglen;
+	size_t size = sizes[0], len;
+	struct sg_splitter *curr = splitters;
+	struct scatterlist *sg;
+
+	for (i = 0; i < nb_splits; i++) {
+		splitters[i].in_sg0 = NULL;
+		splitters[i].nents = 0;
+	}
+
+	for_each_sg(in, sg, nents, i) {
+		sglen = mapped ? sg_dma_len(sg) : sg->length;
+		if (skip > sglen) {
+			skip -= sglen;
+			continue;
+		}
+
+		len = min_t(size_t, size, sglen - skip);
+		if (!curr->in_sg0) {
+			curr->in_sg0 = sg;
+			curr->skip_sg0 = skip;
+		}
+		size -= len;
+		curr->nents++;
+		curr->length_last_sg = len;
+
+		while (!size && (skip + len < sglen) && (--nb_splits > 0)) {
+			curr++;
+			size = *(++sizes);
+			skip += len;
+			len = min_t(size_t, size, sglen - skip);
+
+			curr->in_sg0 = sg;
+			curr->skip_sg0 = skip;
+			curr->nents = 1;
+			curr->length_last_sg = len;
+			size -= len;
+		}
+		skip = 0;
+
+		if (!size && --nb_splits) {
+			curr++;
+			size = *(++sizes);
+		}
+
+		if (!nb_splits)
+			break;
+	}
+
+	return (size || !splitters[0].in_sg0) ? -EINVAL : 0;
+}
+
+static void sg_split_phys(struct sg_splitter *splitters, const int nb_splits)
+{
+	int i, j;
+	struct scatterlist *in_sg, *out_sg;
+	struct sg_splitter *split;
+
+	for (i = 0, split = splitters; i < nb_splits; i++, split++) {
+		in_sg = split->in_sg0;
+		out_sg = split->out_sg;
+		for (j = 0; j < split->nents; j++, out_sg++) {
+			*out_sg = *in_sg;
+			if (!j) {
+				out_sg->offset += split->skip_sg0;
+				out_sg->length -= split->skip_sg0;
+			} else {
+				out_sg->offset = 0;
+			}
+			in_sg = sg_next(in_sg);
+		}
+		out_sg[-1].length = split->length_last_sg;
+		sg_mark_end(out_sg);
+	}
+}
+
+static void sg_split_mapped(struct sg_splitter *splitters, const int nb_splits)
+{
+	int i, j;
+	struct scatterlist *in_sg, *out_sg;
+	struct sg_splitter *split;
+
+	for (i = 0, split = splitters; i < nb_splits; i++, split++) {
+		in_sg = split->in_sg0;
+		out_sg = split->out_sg;
+		for (j = 0; j < split->nents; j++, out_sg++) {
+			sg_dma_address(out_sg) = sg_dma_address(in_sg);
+			sg_dma_len(out_sg) = sg_dma_len(in_sg);
+			if (!j) {
+				sg_dma_address(out_sg) += split->skip_sg0;
+				sg_dma_len(out_sg) -= split->skip_sg0;
+			}
+			in_sg = sg_next(in_sg);
+		}
+		sg_dma_len(--out_sg) = split->length_last_sg;
+	}
+}
+
+/**
+ * sg_split - split a scatterlist into several scatterlists
+ * @in: the input sg list
+ * @in_mapped_nents: the result of a dma_map_sg(in, ...), or 0 if not mapped.
+ * @skip: the number of bytes to skip in the input sg list
+ * @nb_splits: the number of desired sg outputs
+ * @split_sizes: the respective size of each output sg list in bytes
+ * @out: an array where to store the allocated output sg lists
+ * @out_mapped_nents: the resulting sg lists mapped number of sg entries. Might
+ *                    be NULL if sglist not already mapped (in_mapped_nents = 0)
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
+int sg_split(struct scatterlist *in, const int in_mapped_nents,
+	     const off_t skip, const int nb_splits,
+	     const size_t *split_sizes,
+	     struct scatterlist **out, int *out_mapped_nents,
+	     gfp_t gfp_mask)
+{
+	int i, ret;
+	struct sg_splitter *splitters;
+
+	splitters = kcalloc(nb_splits, sizeof(*splitters), gfp_mask);
+	if (!splitters)
+		return -ENOMEM;
+
+	ret = sg_calculate_split(in, sg_nents(in), nb_splits, skip, split_sizes,
+			   splitters, false);
+	if (ret < 0)
+		goto err;
+
+	ret = -ENOMEM;
+	for (i = 0; i < nb_splits; i++) {
+		splitters[i].out_sg = kmalloc_array(splitters[i].nents,
+						    sizeof(struct scatterlist),
+						    gfp_mask);
+		if (!splitters[i].out_sg)
+			goto err;
+	}
+
+	/*
+	 * The order of these 3 calls is important and should be kept.
+	 */
+	sg_split_phys(splitters, nb_splits);
+	ret = sg_calculate_split(in, in_mapped_nents, nb_splits, skip,
+				 split_sizes, splitters, true);
+	if (ret < 0)
+		goto err;
+	sg_split_mapped(splitters, nb_splits);
+
+	for (i = 0; i < nb_splits; i++) {
+		out[i] = splitters[i].out_sg;
+		if (out_mapped_nents)
+			out_mapped_nents[i] = splitters[i].nents;
+	}
+
+	kfree(splitters);
+	return 0;
+
+err:
+	for (i = 0; i < nb_splits; i++)
+		kfree(splitters[i].out_sg);
+	kfree(splitters);
+	return ret;
+}
+EXPORT_SYMBOL(sg_split);
-- 
2.1.4

