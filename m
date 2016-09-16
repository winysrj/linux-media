Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:48966 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753945AbcIPIbv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 04:31:51 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] hva: fix sparse warnings
Message-ID: <ec9c9c05-ac4b-29f3-8c14-c8dde291ff39@xs4all.nl>
Date: Fri, 16 Sep 2016 10:31:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/sti/hva/hva-v4l2.c:43:22: warning: symbol 'hva_encoders' was not declared. Should it be static?
drivers/media/platform/sti/hva/hva-v4l2.c:1401:24: warning: symbol 'hva_driver' was not declared. Should it be static?

Make these static.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sti/hva/hva-v4l2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
index 1696e02..6bf3c858 100644
--- a/drivers/media/platform/sti/hva/hva-v4l2.c
+++ b/drivers/media/platform/sti/hva/hva-v4l2.c
@@ -40,7 +40,7 @@
 #define fh_to_ctx(f)    (container_of(f, struct hva_ctx, fh))

 /* registry of available encoders */
-const struct hva_enc *hva_encoders[] = {
+static const struct hva_enc *hva_encoders[] = {
 	&nv12h264enc,
 	&nv21h264enc,
 };
@@ -1398,7 +1398,7 @@ static const struct of_device_id hva_match_types[] = {

 MODULE_DEVICE_TABLE(of, hva_match_types);

-struct platform_driver hva_driver = {
+static struct platform_driver hva_driver = {
 	.probe  = hva_probe,
 	.remove = hva_remove,
 	.driver = {
-- 
2.8.1


