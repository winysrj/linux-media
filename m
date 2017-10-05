Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48362 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751557AbdJEMDF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 08:03:05 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v15.1 22/32] v4l: fwnode: Move KernelDoc documentation to the header
Date: Thu,  5 Oct 2017 15:03:02 +0300
Message-Id: <20171005120302.7316-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20171004215051.13385-23-sakari.ailus@linux.intel.com>
References: <20171004215051.13385-23-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In V4L2 the practice is to have the KernelDoc documentation in the header
and not in .c source code files. This consequently makes the V4L2 fwnode
function documentation part of the Media documentation build.

Also correct the link related function and argument naming in
documentation and add an asterisk to v4l2_fwnode_endpoint_free()
documentation to make it proper KernelDoc documentation.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
since v15:

- Fix vep parameter documentation for v4l2_fwnode_endpoint_free

 drivers/media/v4l2-core/v4l2-fwnode.c | 75 --------------------------------
 include/media/v4l2-fwnode.h           | 81 ++++++++++++++++++++++++++++++++++-
 2 files changed, 80 insertions(+), 76 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index df0695b7bbcc..65bdcd59744a 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -183,25 +183,6 @@ v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_handle *fwnode,
 		vep->bus_type = V4L2_MBUS_CSI1;
 }
 
-/**
- * v4l2_fwnode_endpoint_parse() - parse all fwnode node properties
- * @fwnode: pointer to the endpoint's fwnode handle
- * @vep: pointer to the V4L2 fwnode data structure
- *
- * All properties are optional. If none are found, we don't set any flags. This
- * means the port has a static configuration and no properties have to be
- * specified explicitly. If any properties that identify the bus as parallel
- * are found and slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarly, if
- * we recognise the bus as serial CSI-2 and clock-noncontinuous isn't set, we
- * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
- * reference to @fwnode.
- *
- * NOTE: This function does not parse properties the size of which is variable
- * without a low fixed limit. Please use v4l2_fwnode_endpoint_alloc_parse() in
- * new drivers instead.
- *
- * Return: 0 on success or a negative error code on failure.
- */
 int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 			       struct v4l2_fwnode_endpoint *vep)
 {
@@ -241,14 +222,6 @@ int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_parse);
 
-/*
- * v4l2_fwnode_endpoint_free() - free the V4L2 fwnode acquired by
- * v4l2_fwnode_endpoint_alloc_parse()
- * @vep - the V4L2 fwnode the resources of which are to be released
- *
- * It is safe to call this function with NULL argument or on a V4L2 fwnode the
- * parsing of which failed.
- */
 void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep)
 {
 	if (IS_ERR_OR_NULL(vep))
@@ -259,29 +232,6 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep)
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_free);
 
-/**
- * v4l2_fwnode_endpoint_alloc_parse() - parse all fwnode node properties
- * @fwnode: pointer to the endpoint's fwnode handle
- *
- * All properties are optional. If none are found, we don't set any flags. This
- * means the port has a static configuration and no properties have to be
- * specified explicitly. If any properties that identify the bus as parallel
- * are found and slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarly, if
- * we recognise the bus as serial CSI-2 and clock-noncontinuous isn't set, we
- * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
- * reference to @fwnode.
- *
- * v4l2_fwnode_endpoint_alloc_parse() has two important differences to
- * v4l2_fwnode_endpoint_parse():
- *
- * 1. It also parses variable size data.
- *
- * 2. The memory it has allocated to store the variable size data must be freed
- *    using v4l2_fwnode_endpoint_free() when no longer needed.
- *
- * Return: Pointer to v4l2_fwnode_endpoint if successful, on an error pointer
- * on error.
- */
 struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
 	struct fwnode_handle *fwnode)
 {
@@ -324,24 +274,6 @@ struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_alloc_parse);
 
-/**
- * v4l2_fwnode_endpoint_parse_link() - parse a link between two endpoints
- * @__fwnode: pointer to the endpoint's fwnode at the local end of the link
- * @link: pointer to the V4L2 fwnode link data structure
- *
- * Fill the link structure with the local and remote nodes and port numbers.
- * The local_node and remote_node fields are set to point to the local and
- * remote port's parent nodes respectively (the port parent node being the
- * parent node of the port node if that node isn't a 'ports' node, or the
- * grand-parent node of the port node otherwise).
- *
- * A reference is taken to both the local and remote nodes, the caller must use
- * v4l2_fwnode_endpoint_put_link() to drop the references when done with the
- * link.
- *
- * Return: 0 on success, or -ENOLINK if the remote endpoint fwnode can't be
- * found.
- */
 int v4l2_fwnode_parse_link(struct fwnode_handle *__fwnode,
 			   struct v4l2_fwnode_link *link)
 {
@@ -376,13 +308,6 @@ int v4l2_fwnode_parse_link(struct fwnode_handle *__fwnode,
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_parse_link);
 
-/**
- * v4l2_fwnode_put_link() - drop references to nodes in a link
- * @link: pointer to the V4L2 fwnode link data structure
- *
- * Drop references to the local and remote nodes in the link. This function
- * must be called on every link parsed with v4l2_fwnode_parse_link().
- */
 void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link)
 {
 	fwnode_handle_put(link->local_node);
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index ac605af9b877..105cfeee44ef 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -115,13 +115,92 @@ struct v4l2_fwnode_link {
 	unsigned int remote_port;
 };
 
+/**
+ * v4l2_fwnode_endpoint_parse() - parse all fwnode node properties
+ * @fwnode: pointer to the endpoint's fwnode handle
+ * @vep: pointer to the V4L2 fwnode data structure
+ *
+ * All properties are optional. If none are found, we don't set any flags. This
+ * means the port has a static configuration and no properties have to be
+ * specified explicitly. If any properties that identify the bus as parallel
+ * are found and slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarly, if
+ * we recognise the bus as serial CSI-2 and clock-noncontinuous isn't set, we
+ * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
+ * reference to @fwnode.
+ *
+ * NOTE: This function does not parse properties the size of which is variable
+ * without a low fixed limit. Please use v4l2_fwnode_endpoint_alloc_parse() in
+ * new drivers instead.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
 int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 			       struct v4l2_fwnode_endpoint *vep);
+
+/**
+ * v4l2_fwnode_endpoint_free() - free the V4L2 fwnode acquired by
+ * v4l2_fwnode_endpoint_alloc_parse()
+ * @vep: the V4L2 fwnode the resources of which are to be released
+ *
+ * It is safe to call this function with NULL argument or on a V4L2 fwnode the
+ * parsing of which failed.
+ */
+void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
+
+/**
+ * v4l2_fwnode_endpoint_alloc_parse() - parse all fwnode node properties
+ * @fwnode: pointer to the endpoint's fwnode handle
+ *
+ * All properties are optional. If none are found, we don't set any flags. This
+ * means the port has a static configuration and no properties have to be
+ * specified explicitly. If any properties that identify the bus as parallel
+ * are found and slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarly, if
+ * we recognise the bus as serial CSI-2 and clock-noncontinuous isn't set, we
+ * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
+ * reference to @fwnode.
+ *
+ * v4l2_fwnode_endpoint_alloc_parse() has two important differences to
+ * v4l2_fwnode_endpoint_parse():
+ *
+ * 1. It also parses variable size data.
+ *
+ * 2. The memory it has allocated to store the variable size data must be freed
+ *    using v4l2_fwnode_endpoint_free() when no longer needed.
+ *
+ * Return: Pointer to v4l2_fwnode_endpoint if successful, on an error pointer
+ * on error.
+ */
 struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
 	struct fwnode_handle *fwnode);
-void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
+
+/**
+ * v4l2_fwnode_parse_link() - parse a link between two endpoints
+ * @fwnode: pointer to the endpoint's fwnode at the local end of the link
+ * @link: pointer to the V4L2 fwnode link data structure
+ *
+ * Fill the link structure with the local and remote nodes and port numbers.
+ * The local_node and remote_node fields are set to point to the local and
+ * remote port's parent nodes respectively (the port parent node being the
+ * parent node of the port node if that node isn't a 'ports' node, or the
+ * grand-parent node of the port node otherwise).
+ *
+ * A reference is taken to both the local and remote nodes, the caller must use
+ * v4l2_fwnode_put_link() to drop the references when done with the
+ * link.
+ *
+ * Return: 0 on success, or -ENOLINK if the remote endpoint fwnode can't be
+ * found.
+ */
 int v4l2_fwnode_parse_link(struct fwnode_handle *fwnode,
 			   struct v4l2_fwnode_link *link);
+
+/**
+ * v4l2_fwnode_put_link() - drop references to nodes in a link
+ * @link: pointer to the V4L2 fwnode link data structure
+ *
+ * Drop references to the local and remote nodes in the link. This function
+ * must be called on every link parsed with v4l2_fwnode_parse_link().
+ */
 void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
 
 /**
-- 
2.11.0
