Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:43507 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932252AbeENNNw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 09:13:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/7] go7007: fix two sparse warnings
Date: Mon, 14 May 2018 15:13:40 +0200
Message-Id: <20180514131346.15795-2-hverkuil@xs4all.nl>
In-Reply-To: <20180514131346.15795-1-hverkuil@xs4all.nl>
References: <20180514131346.15795-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/go7007/go7007-v4l2.c:637:2: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
drivers/media/usb/go7007/go7007-fw.c:1507:3: warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/go7007/go7007-fw.c   | 3 +++
 drivers/media/usb/go7007/go7007-v4l2.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/go7007/go7007-fw.c b/drivers/media/usb/go7007/go7007-fw.c
index 60bf5f0644d1..87b4fc48ef09 100644
--- a/drivers/media/usb/go7007/go7007-fw.c
+++ b/drivers/media/usb/go7007/go7007-fw.c
@@ -1514,7 +1514,10 @@ static int do_special(struct go7007 *go, u16 type, __le16 *code, int space,
 		case V4L2_PIX_FMT_MPEG4:
 			return gen_mpeg4hdr_to_package(go, code, space,
 								framelen);
+		default:
+			break;
 		}
+		break;
 	case SPECIAL_BRC_CTRL:
 		return brctrl_to_package(go, code, space, framelen);
 	case SPECIAL_CONFIG:
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index 98cd57eaf36a..c55c82f70e54 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -634,7 +634,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	if (inp->index >= go->board_info->num_inputs)
 		return -EINVAL;
 
-	strncpy(inp->name, go->board_info->inputs[inp->index].name,
+	strlcpy(inp->name, go->board_info->inputs[inp->index].name,
 			sizeof(inp->name));
 
 	/* If this board has a tuner, it will be the first input */
-- 
2.17.0
