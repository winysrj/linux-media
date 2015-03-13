Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:43179 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616AbbCMLQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:16:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 31/39] vivid: fix format comments
Date: Fri, 13 Mar 2015 12:16:09 +0100
Message-Id: <1426245377-17704-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
References: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Clarify which formats have an alpha channel and which do not by
using 'x' instead of 'a' if there is no alpha channel.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-vid-common.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index cb73c1b..453a5ad 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -197,7 +197,7 @@ struct vivid_fmt vivid_formats[] = {
 	},
 	{
 		.name     = "RGB555 (LE)",
-		.fourcc   = V4L2_PIX_FMT_RGB555, /* gggbbbbb arrrrrgg */
+		.fourcc   = V4L2_PIX_FMT_RGB555, /* gggbbbbb xrrrrrgg */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
 		.planes   = 1,
@@ -206,7 +206,7 @@ struct vivid_fmt vivid_formats[] = {
 	},
 	{
 		.name     = "XRGB555 (LE)",
-		.fourcc   = V4L2_PIX_FMT_XRGB555, /* gggbbbbb arrrrrgg */
+		.fourcc   = V4L2_PIX_FMT_XRGB555, /* gggbbbbb xrrrrrgg */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
 		.planes   = 1,
@@ -225,7 +225,7 @@ struct vivid_fmt vivid_formats[] = {
 	},
 	{
 		.name     = "RGB555 (BE)",
-		.fourcc   = V4L2_PIX_FMT_RGB555X, /* arrrrrgg gggbbbbb */
+		.fourcc   = V4L2_PIX_FMT_RGB555X, /* xrrrrrgg gggbbbbb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
 		.planes   = 1,
@@ -250,7 +250,7 @@ struct vivid_fmt vivid_formats[] = {
 	},
 	{
 		.name     = "RGB32 (LE)",
-		.fourcc   = V4L2_PIX_FMT_RGB32, /* argb */
+		.fourcc   = V4L2_PIX_FMT_RGB32, /* xrgb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 32 },
 		.planes   = 1,
@@ -258,7 +258,7 @@ struct vivid_fmt vivid_formats[] = {
 	},
 	{
 		.name     = "RGB32 (BE)",
-		.fourcc   = V4L2_PIX_FMT_BGR32, /* bgra */
+		.fourcc   = V4L2_PIX_FMT_BGR32, /* bgrx */
 		.vdownsampling = { 1 },
 		.bit_depth = { 32 },
 		.planes   = 1,
@@ -266,7 +266,7 @@ struct vivid_fmt vivid_formats[] = {
 	},
 	{
 		.name     = "XRGB32 (LE)",
-		.fourcc   = V4L2_PIX_FMT_XRGB32, /* argb */
+		.fourcc   = V4L2_PIX_FMT_XRGB32, /* xrgb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 32 },
 		.planes   = 1,
@@ -274,7 +274,7 @@ struct vivid_fmt vivid_formats[] = {
 	},
 	{
 		.name     = "XRGB32 (BE)",
-		.fourcc   = V4L2_PIX_FMT_XBGR32, /* bgra */
+		.fourcc   = V4L2_PIX_FMT_XBGR32, /* bgrx */
 		.vdownsampling = { 1 },
 		.bit_depth = { 32 },
 		.planes   = 1,
-- 
2.1.4

