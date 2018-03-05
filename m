Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:55238 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933502AbeCENvn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 08:51:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/7] cec: add core error injection support
Date: Mon,  5 Mar 2018 14:51:33 +0100
Message-Id: <20180305135139.95652-2-hverkuil@xs4all.nl>
In-Reply-To: <20180305135139.95652-1-hverkuil@xs4all.nl>
References: <20180305135139.95652-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add two new ops (error_inj_show and error_inj_parse_line) to support
error injection functionality for CEC adapters. If both are present,
then the core will add a new error-inj debugfs file that can be used
to see the current error injection commands and to set error injection
commands.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-core.c | 58 ++++++++++++++++++++++++++++++++++++++++++++
 include/media/cec.h          |  5 ++++
 2 files changed, 63 insertions(+)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index e47ea22b3c23..ea3eccfdba15 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -195,6 +195,55 @@ void cec_register_cec_notifier(struct cec_adapter *adap,
 EXPORT_SYMBOL_GPL(cec_register_cec_notifier);
 #endif
 
+#ifdef CONFIG_DEBUG_FS
+static ssize_t cec_error_inj_write(struct file *file,
+	const char __user *ubuf, size_t count, loff_t *ppos)
+{
+	struct seq_file *sf = file->private_data;
+	struct cec_adapter *adap = sf->private;
+	char *buf;
+	char *line;
+	char *p;
+
+	buf = memdup_user_nul(ubuf, min_t(size_t, PAGE_SIZE, count));
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+	p = buf;
+	while (p && *p && count >= 0) {
+		p = skip_spaces(p);
+		line = strsep(&p, "\n");
+		if (!*line || *line == '#')
+			continue;
+		if (!adap->ops->error_inj_parse_line(adap, line)) {
+			count = -EINVAL;
+			break;
+		}
+	}
+	kfree(buf);
+	return count;
+}
+
+static int cec_error_inj_show(struct seq_file *sf, void *unused)
+{
+	struct cec_adapter *adap = sf->private;
+
+	return adap->ops->error_inj_show(adap, sf);
+}
+
+static int cec_error_inj_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cec_error_inj_show, inode->i_private);
+}
+
+static const struct file_operations cec_error_inj_fops = {
+	.open = cec_error_inj_open,
+	.write = cec_error_inj_write,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+#endif
+
 struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 					 void *priv, const char *name, u32 caps,
 					 u8 available_las)
@@ -334,7 +383,16 @@ int cec_register_adapter(struct cec_adapter *adap,
 		pr_warn("cec-%s: Failed to create status file\n", adap->name);
 		debugfs_remove_recursive(adap->cec_dir);
 		adap->cec_dir = NULL;
+		return 0;
 	}
+	if (!adap->ops->error_inj_show || !adap->ops->error_inj_parse_line)
+		return 0;
+	adap->error_inj_file = debugfs_create_file("error-inj", 0644,
+						   adap->cec_dir, adap,
+						   &cec_error_inj_fops);
+	if (IS_ERR_OR_NULL(adap->error_inj_file))
+		pr_warn("cec-%s: Failed to create error-inj file\n",
+			adap->name);
 #endif
 	return 0;
 }
diff --git a/include/media/cec.h b/include/media/cec.h
index 9afba9b558df..41df048efc55 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -117,6 +117,10 @@ struct cec_adap_ops {
 	void (*adap_status)(struct cec_adapter *adap, struct seq_file *file);
 	void (*adap_free)(struct cec_adapter *adap);
 
+	/* Error injection callbacks */
+	int (*error_inj_show)(struct cec_adapter *adap, struct seq_file *sf);
+	bool (*error_inj_parse_line)(struct cec_adapter *adap, char *line);
+
 	/* High-level CEC message callback */
 	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
 };
@@ -189,6 +193,7 @@ struct cec_adapter {
 
 	struct dentry *cec_dir;
 	struct dentry *status_file;
+	struct dentry *error_inj_file;
 
 	u16 phys_addrs[15];
 	u32 sequence;
-- 
2.16.1
