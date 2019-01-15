Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FABCC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 19:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F64E20675
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 19:16:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TQv3HtzT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389285AbfAOTQQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 14:16:16 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36777 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389161AbfAOTQQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 14:16:16 -0500
Received: by mail-pf1-f194.google.com with SMTP id b85so1767163pfc.3;
        Tue, 15 Jan 2019 11:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1KXh25PbVVHlosPzaxZn1WKzoKW7HIsYY+dIZZ+V+9U=;
        b=TQv3HtzTrpRD1Z1VANRQYy7AfcvwcPfLLUEgenP4u71a66DQlWRACZNuBHDDh9tTXb
         bjsRhDtuc4kU56KfRouW73RsIsIpbjlcO8i4EIh+3ZevBfNSRwpY+TglpH6YsVrwzdNW
         BbP7w7pplO8TWchkMseqUM/QwTvcIGC1YwiknlUlk7PPWmWbRi0YlCAJiSl+TyA7K3Ao
         neMNxCpfgPqcxg/OolUSbdvuBX+QP+6mPUwVQQYzpPJHe2LkJa4DBD1rFxEYphtOVIxX
         CLSjhwiMLuShcxrF/6TIiRamG64PQy7I8wM6Sbrsklijthjk3ubVyCC2oTJ8OWQLLpJn
         kjjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1KXh25PbVVHlosPzaxZn1WKzoKW7HIsYY+dIZZ+V+9U=;
        b=AU4U79kYGrGo1kaMRK858KJ4cDh82GmWxchxUf8CUYQY0YJtsZDrA7NPP4tNwe89Fh
         jRHZxsyfSsTQ0rlSkkAzY24iOPVyHQ03ipsP5F3RujId1NdGHgoksQNso2BEDNItNSfq
         h3wjSUtMEKpC3vUxjawaQDRQGoR4IG2GWQo4ULegnxBtR0FKbxYttxwV+sD1uJviTdmD
         IBCtQulWreQoVUB6xBn7s3zRQQoN6oLLgoWFrs8Le3uIifLRsJPfkj3moj0u2NAElWV/
         lqaQ7ooMJV+fj9M8elIKLsLreHrT8jmv3Evl4W1+e3Mvw9la1B2e4phLNp2tKS9Z0q8P
         wH+g==
X-Gm-Message-State: AJcUukf8s/LYx8Uiobd5xOdJqFAnrJg27BdgRquy+ZaatFqVxsV8fFZU
        NWnUHC+UVVmw7lySLnwyZigEjiEPtgc=
X-Google-Smtp-Source: ALg8bN4i+IwVSDLt7rLGx2HaIHrRky4Qmp3KkAdjtc1wjHeLzZZYlQ2sGS8w7rCPRbs9G8YVOAr8KA==
X-Received: by 2002:a63:6704:: with SMTP id b4mr5194963pgc.100.1547579774953;
        Tue, 15 Jan 2019 11:16:14 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id v89sm8023131pfj.164.2019.01.15.11.16.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 11:16:14 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: imx: capture: Allow event subscribe/unsubscribe
Date:   Tue, 15 Jan 2019 11:16:08 -0800
Message-Id: <20190115191608.13029-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Implement the vidioc_(un)subscribe_event operations. Imx will allow
subscribing to the imx-specific frame interval error events, events
from subdevices (V4L2_EVENT_SOURCE_CHANGE), and control events.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-media-capture.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index b37e1186eb2f..4dfbe05d203e 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -335,6 +335,21 @@ static int capture_s_parm(struct file *file, void *fh,
 	return 0;
 }
 
+static int capture_subscribe_event(struct v4l2_fh *fh,
+				   const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_IMX_FRAME_INTERVAL_ERROR:
+		return v4l2_event_subscribe(fh, sub, 0, NULL);
+	case V4L2_EVENT_SOURCE_CHANGE:
+		return v4l2_src_change_event_subscribe(fh, sub);
+	case V4L2_EVENT_CTRL:
+		return v4l2_ctrl_subscribe_event(fh, sub);
+	default:
+		return -EINVAL;
+	}
+}
+
 static const struct v4l2_ioctl_ops capture_ioctl_ops = {
 	.vidioc_querycap	= vidioc_querycap,
 
@@ -362,6 +377,9 @@ static const struct v4l2_ioctl_ops capture_ioctl_ops = {
 	.vidioc_expbuf		= vb2_ioctl_expbuf,
 	.vidioc_streamon	= vb2_ioctl_streamon,
 	.vidioc_streamoff	= vb2_ioctl_streamoff,
+
+	.vidioc_subscribe_event = capture_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 /*
-- 
2.17.1

