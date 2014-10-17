Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:52262 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaJQOzF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Oct 2014 10:55:05 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NDL004CNG3R9300@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Oct 2014 23:55:03 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, b.zolnierkie@samsung.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC v2 1/4] Add a media device configuration file parser.
Date: Fri, 17 Oct 2014 16:54:39 +0200
Message-id: <1413557682-20535-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1413557682-20535-1-git-send-email-j.anaszewski@samsung.com>
References: <1413557682-20535-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a parser for a media device configuration
file. The parser expects the configuration file containing
links end v4l2-controls definitions as described in the
header file being added. The links describe connections
between media entities and v4l2-controls define the target
sub-devices for particular user controls related ioctl calls.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 lib/include/libv4l2-media-conf-parser.h |  148 +++++++++++
 lib/libv4l2/libv4l2-media-conf-parser.c |  441 +++++++++++++++++++++++++++++++
 2 files changed, 589 insertions(+)
 create mode 100644 lib/include/libv4l2-media-conf-parser.h
 create mode 100644 lib/libv4l2/libv4l2-media-conf-parser.c

diff --git a/lib/include/libv4l2-media-conf-parser.h b/lib/include/libv4l2-media-conf-parser.h
new file mode 100644
index 0000000..b2dba3a
--- /dev/null
+++ b/lib/include/libv4l2-media-conf-parser.h
@@ -0,0 +1,148 @@
+/*
+ * Parser of media device configuration file.
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *              http://www.samsung.com
+ *
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * The configuration file has to comply with following format:
+ *
+ * Link description entry format:
+ *
+ * link {
+ * <TAB>source_entity: <entity_name><LF>
+ * <TAB>source_pad: <pad_id><LF>
+ * <TAB>sink_entity: <entity_name><LF>
+ * <TAB>sink_pad: <pad_id><LF>
+ * }
+ *
+ * The V4L2 control group format:
+ *
+ * v4l2-controls {
+ * <TAB><control1_name>: <entity_name><LF>
+ * <TAB><control2_name>: <entity_name><LF>
+ * ...
+ * <TAB><controlN_name>: <entity_name><LF>
+ * }
+ *
+ * Example:
+ *
+ * link {
+ *         source_entity: s5p-mipi-csis.0
+ *         source_pad: 1
+ *         sink_entity: FIMC.0
+ *         sink_pad: 0
+ * }
+ *
+ * v4l2-controls {
+ *         Color Effects: S5C73M3
+ *         Saturation: S5C73M3
+ * }
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ */
+
+#ifndef __LIBV4L_MEDIA_CONF_PARSER_H
+#define __LIBV4L_MEDIA_CONF_PARSER_H
+
+#include <libv4l2.h>
+
+#ifdef DEBUG
+#define V4L2_MDCFG_PARSER_DBG(format, ARG...)\
+	printf("[%s:%d] [%s] " format " \n", __FILE__, __LINE__, __func__, ##ARG)
+#else
+#define V4L2_MDCFG_PARSER_DBG(format, ARG...)
+#endif
+
+#define V4L2_MDCFG_PARSER_ERR(format, ARG...)\
+	fprintf(stderr, "Libv4l device config parser: "format "\n", ##ARG)
+
+#define V4L2_MDCFG_PARSER_LOG(format, ARG...)\
+	fprintf(stdout, "Libv4l device config parser: "format "\n", ##ARG)
+
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
+/*
+ * struct libv4l2_media_link_conf - media entity link configuration
+ * @source_entity:	source entity of the link
+ * @source_pad:		source pad id
+ * @sink_entity:	sink entity of the link
+ * @sink_pad:		sink pad id
+ * @next:		pointer to the next data structure in the list
+ */
+struct libv4l2_media_link_conf {
+	char *source_entity;
+	int source_pad;
+	char *sink_entity;
+	int sink_pad;
+	struct libv4l2_media_link_conf *next;
+};
+
+/*
+ * struct libv4l2_media_ctrl_conf - user control to media entity configuration
+ * @control_name:	user control name
+ * @entity_name:	media entity name
+ * @entity:		media entity matched by entity_name
+ * @cid:		user control id
+ * @next:		pointer to the next data structure in the list
+ */
+struct libv4l2_media_ctrl_conf {
+	char *control_name;
+	char *entity_name;
+	struct media_entity *entity;
+	int cid;
+	struct libv4l2_media_ctrl_conf *next;
+};
+
+/*
+ * struct libv4l2_media_device_conf - media device config
+ * @links:	media entity link config
+ * @controls:	user control to media entity config
+ */
+struct libv4l2_media_device_conf {
+	struct libv4l2_media_link_conf *links;
+	struct libv4l2_media_ctrl_conf *controls;
+};
+
+/*
+ * struct libv4l2_conf_parser_ctx - parser context
+ * @line_start_pos:	start position of the current line in the file buffer
+ * @line_end:		end position of the current line in the file buffer
+ * @buf_pos:		file buffer position of the currently analyzed character
+ * @buf:		config file buffer
+ * @buf_size:		number of characters in the file buffer
+ */
+struct libv4l2_conf_parser_ctx {
+	int line_start_pos;
+	int line_end_pos;
+	int buf_pos;
+	char *buf;
+	int buf_size;
+};
+
+/*
+ * Read configuration file and initialize config argument with the parsed data.
+ * The config's links and controls fields must be released with use of
+ * libv4l2_media_conf_release_links and libv4l2_media_conf_release_controls
+ * functions respectively.
+ */
+int libv4l2_media_conf_read(char *fname,
+			struct libv4l2_media_device_conf *config);
+
+/* Release links configuration */
+void libv4l2_media_conf_release_links(struct libv4l2_media_link_conf *cfg);
+
+/* Release controls configuration */
+void libv4l2_media_conf_release_controls(struct libv4l2_media_ctrl_conf *cfg);
+
+#endif /* __LIBV4L_MEDIA_CONF_PARSER_H */
diff --git a/lib/libv4l2/libv4l2-media-conf-parser.c b/lib/libv4l2/libv4l2-media-conf-parser.c
new file mode 100644
index 0000000..03a0b43
--- /dev/null
+++ b/lib/libv4l2/libv4l2-media-conf-parser.c
@@ -0,0 +1,441 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *              http://www.samsung.com
+ *
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ */
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <libv4l2-media-conf-parser.h>
+
+static int get_line(struct libv4l2_conf_parser_ctx *ctx)
+{
+	int i;
+
+	if (ctx->buf_pos == ctx->buf_size)
+		return -EINVAL;
+
+	ctx->line_start_pos = ctx->buf_pos;
+
+	for (i = ctx->buf_pos; i < ctx->buf_size; ++i) {
+		if (ctx->buf[i] == '\n') {
+			ctx->buf_pos = i + 1;
+			break;
+		}
+	}
+
+	ctx->line_end_pos = i - 1;
+
+	return 0;
+}
+
+static int parse_field_value(struct libv4l2_conf_parser_ctx *ctx,
+				const char *field_name, char **field_value)
+{
+	char *value;
+	int line_offset = ctx->line_start_pos, i;
+	char *line_buf = ctx->buf + line_offset;
+	int field_name_len = strlen(field_name);
+	int field_value_pos = field_name_len + 3;
+	int field_value_len = ctx->line_end_pos - line_offset
+	    - field_value_pos + 1;
+
+	if (line_buf[0] != '\t') {
+		V4L2_MDCFG_PARSER_ERR("Lack of leading tab.");
+		return -EINVAL;
+	}
+
+	if (strncmp(line_buf + 1, field_name, field_name_len) != 0) {
+		V4L2_MDCFG_PARSER_ERR("Invalid field name.");
+		return -EINVAL;
+	}
+
+	if (line_buf[field_value_pos - 1] != ' ') {
+		V4L2_MDCFG_PARSER_ERR("Lack of space after colon.");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < field_value_len; ++i)
+		if (line_buf[field_value_pos + i] == ' ') {
+			V4L2_MDCFG_PARSER_ERR("Field value must not include spaces.");
+			return -EINVAL;
+		}
+
+	value = malloc(sizeof(char) * (field_value_len + 1));
+	if (value == NULL)
+		return -ENOMEM;
+
+	strncpy(value, line_buf + field_value_pos, field_value_len);
+	value[field_value_len] = '\0';
+
+	*field_value = value;
+
+	return 0;
+}
+
+static int parse_link(struct libv4l2_conf_parser_ctx *ctx,
+			struct libv4l2_media_link_conf **link)
+{
+	int *l_start = &ctx->line_start_pos, i;
+	int *l_end = &ctx->line_end_pos;
+	struct libv4l2_media_link_conf *ret_link = NULL;
+	int ret;
+	static const char *link_fields[] = {
+		"source_entity",
+		"source_pad",
+		"sink_entity",
+		"sink_pad"
+	};
+	char *field_values[4];
+
+	memset(field_values, 0, sizeof(field_values));
+
+	ctx->line_start_pos = 0;
+	ctx->line_end_pos = 0;
+
+	/* look for link beginning signature */
+	for (;;) {
+		ret = get_line(ctx);
+		if (ret < 0)
+			goto err_parser;
+
+		/* handling empty line case */
+		if (*l_end - *l_start <= 1)
+			continue;
+
+		ret = strncmp(ctx->buf + *l_start,
+			      "link {\n", *l_end - *l_start);
+		if (ret == 0)
+			break;
+	}
+
+	/* read link fields */
+	for (i = 0; i < ARRAY_SIZE(link_fields); ++i) {
+		ret = get_line(ctx);
+		if (ret < 0) {
+			V4L2_MDCFG_PARSER_ERR("Link entry incomplete.");
+			goto err_parser;
+		}
+
+		ret = parse_field_value(ctx, link_fields[i], &field_values[i]);
+		if (ret < 0) {
+			V4L2_MDCFG_PARSER_ERR("Link field format error (%s)",
+					 link_fields[i]);
+			goto err_parser;
+		}
+	}
+
+	/* look for link end */
+	ret = get_line(ctx);
+	if (ret < 0) {
+		V4L2_MDCFG_PARSER_ERR("EOF reached, link end not found.");
+		goto err_parser;
+	}
+
+	if (ctx->buf[*l_start] != '}') {
+		V4L2_MDCFG_PARSER_ERR("Link closing marker not found");
+		goto err_parser;
+	}
+
+	ret_link = malloc(sizeof(*ret_link));
+	if (ret_link == NULL) {
+		V4L2_MDCFG_PARSER_ERR("Could not allocate memory for a link.");
+		goto err_parser;
+	}
+
+	ret_link->source_entity = field_values[0];
+	ret_link->source_pad = atoi(field_values[1]);
+	ret_link->sink_entity = field_values[2];
+	ret_link->sink_pad = atoi(field_values[3]);
+
+	free(field_values[1]);
+	free(field_values[3]);
+
+	*link = ret_link;
+
+	return 1;
+
+err_parser:
+	for (i = 0; i < ARRAY_SIZE(field_values); ++i) {
+		if (field_values[i] != NULL)
+			free(field_values[i]);
+	}
+
+	if (ret_link != NULL)
+		free(ret_link);
+
+	return 0;
+}
+
+static int parse_property(struct libv4l2_conf_parser_ctx *ctx,
+				char **key, char **value)
+{
+	int line_offset = ctx->line_start_pos,
+	    line_length = ctx->line_end_pos - ctx->line_start_pos + 1,
+	    val_length, i;
+	char *line_buf = ctx->buf + line_offset, *k, *v;
+
+	if (line_buf[0] != '\t') {
+		V4L2_MDCFG_PARSER_ERR("Lack of leading tab.");
+		return -EINVAL;
+	}
+
+	/* Parse key segment of a property */
+	for (i = 1; i < line_length; ++i)
+		if (line_buf[i] == ':')
+			break;
+
+	if (i == line_length) {
+		V4L2_MDCFG_PARSER_ERR("Property format error - lack of semicolon");
+		return -EINVAL;
+	}
+
+	/* At least one character should be left for value segment */
+	if (i >= line_length - 2) {
+		V4L2_MDCFG_PARSER_ERR("Property format error - no value segment");
+		return -EINVAL;
+	}
+
+	k = malloc(sizeof(char) * i);
+	if (k == NULL)
+		return -ENOMEM;
+
+	strncpy(k, line_buf + 1, i - 1);
+	k[i - 1] = '\0';
+
+	val_length = line_length - i - 2;
+
+	v = malloc(sizeof(char) * (val_length + 1));
+	if (v == NULL)
+		return -ENOMEM;
+
+	strncpy(v, line_buf + i + 2, val_length);
+	v[val_length] = '\0';
+
+	*key = k;
+	*value = v;
+
+	return 0;
+}
+
+static int parse_controls(struct libv4l2_conf_parser_ctx *ctx,
+				struct libv4l2_media_ctrl_conf **controls)
+{
+	int *l_start = &ctx->line_start_pos;
+	int *l_end = &ctx->line_end_pos;
+	struct libv4l2_media_ctrl_conf *head = NULL, *tmp_ctrl, *c = NULL;
+	int ret;
+	char *control_name = NULL, *entity_name = NULL;
+
+	if (controls == NULL)
+		return -EINVAL;
+
+	ctx->buf_pos = 0;
+	ctx->line_start_pos = 0;
+	ctx->line_end_pos = 0;
+
+	/* look for controls beginning signature */
+	for (;;) {
+		ret = get_line(ctx);
+		if (ret < 0) {
+			V4L2_MDCFG_PARSER_LOG("Controls configuration not found");
+			return 0;
+		}
+
+		/* handling empty line case */
+		if (*l_end - *l_start <= 1)
+			continue;
+
+		ret = strncmp(ctx->buf + *l_start,
+			      "v4l2-controls {\n", *l_end - *l_start);
+		if (ret == 0)
+			break;
+	}
+
+	/* read control-entity pairs */
+	for (;;) {
+		ret = get_line(ctx);
+		if (ret < 0) {
+			V4L2_MDCFG_PARSER_ERR("Controls closing marker not found");
+			goto err_parser;
+		}
+
+		if (ctx->buf[*l_start] == '}')
+			break;
+
+		ret = parse_property(ctx, &control_name, &entity_name);
+		if (ret < 0) {
+			V4L2_MDCFG_PARSER_ERR("Control property parsing error");
+			goto err_parser;
+		}
+
+		tmp_ctrl = calloc(1, sizeof(*tmp_ctrl));
+		if (tmp_ctrl == NULL) {
+			ret = -ENOMEM;
+			goto err_parser;
+		}
+
+		tmp_ctrl->entity_name = entity_name;
+		tmp_ctrl->control_name = control_name;
+
+		if (head == NULL) {
+			head = tmp_ctrl;
+			c = head;
+		} else {
+			c->next = tmp_ctrl;
+			c = c->next;
+		}
+	}
+
+	*controls = head;
+
+	return 0;
+
+err_parser:
+	libv4l2_media_conf_release_controls(head);
+	return ret;
+}
+
+static int parse_links(struct libv4l2_conf_parser_ctx *ctx,
+			struct libv4l2_media_link_conf **links)
+{
+	int cnt = 0;
+	struct libv4l2_media_link_conf *l = NULL, *head = NULL, *tmp = NULL;
+
+	ctx->line_start_pos = 0;
+	ctx->buf_pos = 0;
+
+	while (parse_link(ctx, &tmp)) {
+		if (head == NULL) {
+			head = tmp;
+			head->next = NULL;
+			l = head;
+		} else {
+			l->next = tmp;
+			l = l->next;
+			l->next = NULL;
+		}
+		++cnt;
+	}
+
+	if (cnt == 0) {
+		V4L2_MDCFG_PARSER_ERR("No links have been found!");
+		goto err_no_data;
+	}
+
+	*links = head;
+
+	return 0;
+
+err_no_data:
+	libv4l2_media_conf_release_links(head);
+	return -EINVAL;
+
+}
+
+void libv4l2_media_conf_release_links(struct libv4l2_media_link_conf *cfg)
+{
+	struct libv4l2_media_link_conf *tmp;
+
+	while (cfg) {
+		tmp = cfg->next;
+		free(cfg->source_entity);
+		free(cfg->sink_entity);
+		free(cfg);
+		cfg = tmp;
+	}
+}
+
+void libv4l2_media_conf_release_controls(struct libv4l2_media_ctrl_conf *cfg)
+{
+	struct libv4l2_media_ctrl_conf *tmp;
+
+	while (cfg) {
+		tmp = cfg->next;
+		free(cfg->entity_name);
+		free(cfg->control_name);
+		free(cfg);
+		cfg = tmp;
+	}
+}
+
+int libv4l2_media_conf_read(char *fname,
+			    struct libv4l2_media_device_conf *config)
+{
+	struct libv4l2_media_link_conf *links;
+	struct libv4l2_media_ctrl_conf *controls = NULL;
+	struct stat st;
+	struct libv4l2_conf_parser_ctx ctx;
+	int fd, ret;
+
+	memset(&ctx, 0, sizeof(ctx));
+
+	/* read config file to a buffer */
+
+	fd = open(fname, O_RDONLY);
+
+	if (fd < 0) {
+		V4L2_MDCFG_PARSER_ERR("Could not open config file");
+		return -EINVAL;
+	}
+
+	ret = fstat(fd, &st);
+	if (ret < 0) {
+		V4L2_MDCFG_PARSER_ERR("Could not get config file statistics");
+		goto err_fstat;
+	}
+
+	ctx.buf_size = st.st_size;
+	ctx.buf = malloc(ctx.buf_size);
+	if (ctx.buf == NULL) {
+		V4L2_MDCFG_PARSER_ERR("Could not allocate file buffer");
+		ret = -ENOMEM;
+		goto err_fstat;
+	}
+
+	ret = read(fd, ctx.buf, ctx.buf_size);
+	if (ret < 0)
+		goto err_config_read;
+
+	/* parse file buffer */
+
+	ret = parse_links(&ctx, &links);
+	if (ret < 0)
+		goto err_config_read;
+
+	ret = parse_controls(&ctx, &controls);
+	if (ret < 0)
+		goto err_parse_controls;
+
+	config->links = links;
+	config->controls = controls;
+
+	free(ctx.buf);
+
+	return ret;
+
+err_parse_controls:
+	libv4l2_media_conf_release_links(links);
+err_config_read:
+	if (ctx.buf != NULL)
+		free(ctx.buf);
+err_fstat:
+	close(fd);
+
+	return ret;
+}
+
-- 
1.7.9.5

