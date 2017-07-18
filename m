Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59938 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751510AbdGRTED (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:04:03 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hverkuil@xs4all.nl
Subject: [RFC 01/19] device property: Introduce fwnode_property_get_reference_args
Date: Tue, 18 Jul 2017 22:03:43 +0300
Message-Id: <20170718190401.14797-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new fwnode_property_get_reference_args() interface amends the fwnode
property API with the functionality of both of_parse_phandle_with_args()
and __acpi_node_get_property_reference().

The semantics is slightly different: the cells property is ignored on ACPI
as the number of arguments can be explicitly obtained from the firmware
interface.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/acpi/property.c  | 27 +++++++++++++++++++++++++++
 drivers/base/property.c  | 12 ++++++++++++
 drivers/of/property.c    | 31 +++++++++++++++++++++++++++++++
 include/linux/fwnode.h   | 19 +++++++++++++++++++
 include/linux/property.h |  4 ++++
 5 files changed, 93 insertions(+)

diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index f8d60051efb8..b39497cd3f7f 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1195,6 +1195,32 @@ acpi_fwnode_get_named_child_node(const struct fwnode_handle *fwnode,
 	return NULL;
 }
 
+static int
+acpi_fwnode_get_reference_args(const struct fwnode_handle *fwnode,
+			       const char *prop, const char *nargs_prop,
+			       unsigned int args_count, unsigned int index,
+			       struct fwnode_reference_args *args)
+{
+	struct acpi_reference_args acpi_args;
+	unsigned int i;
+	int ret;
+
+	ret = __acpi_node_get_property_reference(fwnode, prop, index,
+						 args_count, &acpi_args);
+	if (ret < 0)
+		return ret;
+	if (!args)
+		return 0;
+
+	args->nargs = acpi_args.nargs;
+	args->fwnode = acpi_fwnode_handle(acpi_args.adev);
+
+	for (i = 0; i < NR_OF_FWNODE_REFERENCE_ARGS; i++)
+		args->args[i] = i < acpi_args.nargs ? acpi_args.args[i] : 0;
+
+	return 0;
+}
+
 static struct fwnode_handle *
 acpi_fwnode_graph_get_next_endpoint(const struct fwnode_handle *fwnode,
 				    struct fwnode_handle *prev)
@@ -1248,6 +1274,7 @@ static int acpi_fwnode_graph_parse_endpoint(const struct fwnode_handle *fwnode,
 		.get_parent = acpi_node_get_parent,			\
 		.get_next_child_node = acpi_get_next_subnode,		\
 		.get_named_child_node = acpi_fwnode_get_named_child_node, \
+		.get_reference_args = acpi_fwnode_get_reference_args,	\
 		.graph_get_next_endpoint =				\
 			acpi_fwnode_graph_get_next_endpoint,		\
 		.graph_get_remote_endpoint =				\
diff --git a/drivers/base/property.c b/drivers/base/property.c
index 673e2353a2fb..369b5471198f 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -665,6 +665,18 @@ int fwnode_property_match_string(const struct fwnode_handle *fwnode,
 }
 EXPORT_SYMBOL_GPL(fwnode_property_match_string);
 
+/**
+ */
+int fwnode_property_get_reference_args(const struct fwnode_handle *fwnode,
+				       const char *prop, const char *nargs_prop,
+				       unsigned int nargs, unsigned int index,
+				       struct fwnode_reference_args *args)
+{
+	return fwnode_call_int_op(fwnode, get_reference_args, prop, nargs_prop,
+				  nargs, index, args);
+}
+EXPORT_SYMBOL_GPL(fwnode_property_get_reference_args);
+
 static int property_copy_string_array(struct property_entry *dst,
 				      const struct property_entry *src)
 {
diff --git a/drivers/of/property.c b/drivers/of/property.c
index ae46a6f0ea36..2350103f8be6 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -891,6 +891,36 @@ of_fwnode_get_named_child_node(const struct fwnode_handle *fwnode,
 	return NULL;
 }
 
+static int
+of_fwnode_get_reference_args(const struct fwnode_handle *fwnode,
+			     const char *prop, const char *nargs_prop,
+			     unsigned int nargs, unsigned int index,
+			     struct fwnode_reference_args *args)
+{
+	struct of_phandle_args of_args;
+	unsigned int i;
+	int ret;
+
+	if (nargs_prop)
+		ret = of_parse_phandle_with_args(to_of_node(fwnode), prop,
+						 nargs_prop, index, &of_args);
+	else
+		ret = of_parse_phandle_with_fixed_args(to_of_node(fwnode), prop,
+						       nargs, index, &of_args);
+	if (ret < 0)
+		return ret;
+	if (!args)
+		return 0;
+
+	args->nargs = of_args.args_count;
+	args->fwnode = of_fwnode_handle(of_args.np);
+
+	for (i = 0; i < NR_OF_FWNODE_REFERENCE_ARGS; i++)
+		args->args[i] = i < of_args.args_count ? of_args.args[i] : 0;
+
+	return 0;
+}
+
 static struct fwnode_handle *
 of_fwnode_graph_get_next_endpoint(const struct fwnode_handle *fwnode,
 				  struct fwnode_handle *prev)
@@ -949,6 +979,7 @@ const struct fwnode_operations of_fwnode_ops = {
 	.get_parent = of_fwnode_get_parent,
 	.get_next_child_node = of_fwnode_get_next_child_node,
 	.get_named_child_node = of_fwnode_get_named_child_node,
+	.get_reference_args = of_fwnode_get_reference_args,
 	.graph_get_next_endpoint = of_fwnode_graph_get_next_endpoint,
 	.graph_get_remote_endpoint = of_fwnode_graph_get_remote_endpoint,
 	.graph_get_port_parent = of_fwnode_graph_get_port_parent,
diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
index 7b50ee4edcfc..218fe03544c9 100644
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -33,6 +33,20 @@ struct fwnode_endpoint {
 	const struct fwnode_handle *local_fwnode;
 };
 
+#define NR_OF_FWNODE_REFERENCE_ARGS	8
+
+/**
+ * struct fwnode_reference_args - Fwnode reference with additional arguments
+ * @fwnode:- A reference to the base fwnode
+ * @nargs: Number of elements in @args array
+ * @args: Integer arguments on the fwnode
+ */
+struct fwnode_reference_args {
+	struct fwnode_handle *fwnode;
+	unsigned int nargs;
+	unsigned int args[NR_OF_FWNODE_REFERENCE_ARGS];
+};
+
 /**
  * struct fwnode_operations - Operations for fwnode interface
  * @get: Get a reference to an fwnode.
@@ -46,6 +60,7 @@ struct fwnode_endpoint {
  * @get_parent: Return the parent of an fwnode.
  * @get_next_child_node: Return the next child node in an iteration.
  * @get_named_child_node: Return a child node with a given name.
+ * @get_reference_args: Return a reference pointed to by a property, with args
  * @graph_get_next_endpoint: Return an endpoint node in an iteration.
  * @graph_get_remote_endpoint: Return the remote endpoint node of a local
  *			       endpoint node.
@@ -73,6 +88,10 @@ struct fwnode_operations {
 	struct fwnode_handle *
 	(*get_named_child_node)(const struct fwnode_handle *fwnode,
 				const char *name);
+	int (*get_reference_args)(const struct fwnode_handle *fwnode,
+				  const char *prop, const char *nargs_prop,
+				  unsigned int nargs, unsigned int index,
+				  struct fwnode_reference_args *args);
 	struct fwnode_handle *
 	(*graph_get_next_endpoint)(const struct fwnode_handle *fwnode,
 				   struct fwnode_handle *prev);
diff --git a/include/linux/property.h b/include/linux/property.h
index edff3f89e755..6bebee13c5e0 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -73,6 +73,10 @@ int fwnode_property_read_string(const struct fwnode_handle *fwnode,
 				const char *propname, const char **val);
 int fwnode_property_match_string(const struct fwnode_handle *fwnode,
 				 const char *propname, const char *string);
+int fwnode_property_get_reference_args(const struct fwnode_handle *fwnode,
+				       const char *prop, const char *nargs_prop,
+				       unsigned int nargs, unsigned int index,
+				       struct fwnode_reference_args *args);
 
 struct fwnode_handle *fwnode_get_parent(const struct fwnode_handle *fwnode);
 struct fwnode_handle *fwnode_get_next_parent(
-- 
2.11.0
