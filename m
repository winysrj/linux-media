Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:39408 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbbCNQ2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 12:28:38 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 14E5D2A0081
	for <linux-media@vger.kernel.org>; Sat, 14 Mar 2015 17:28:26 +0100 (CET)
Message-ID: <550461A9.7040105@xs4all.nl>
Date: Sat, 14 Mar 2015 17:28:25 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2-ioctl: allow all controls if ctrl_class == 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The check_ext_ctrls() function in v4l2-ioctl.c checks if all controls in the
control array are from the same control class as c->ctrl_class. However,
that check should only be done if c->ctrl_class != 0. A 0 value means
that this restriction does not apply.

So return 1 (OK) if c->ctrl_class == 0.

Found by running v4l2-compliance on the uvc driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 09ad8dd..7731499 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -901,6 +901,8 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 	 */
 	if (!allow_priv && c->ctrl_class == V4L2_CID_PRIVATE_BASE)
 		return 0;
+	if (c->ctrl_class == 0)
+		return 1;
 	/* Check that all controls are from the same control class. */
 	for (i = 0; i < c->count; i++) {
 		if (V4L2_CTRL_ID2CLASS(c->controls[i].id) != c->ctrl_class) {

