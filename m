Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:56368 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103AbbHFFWg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Aug 2015 01:22:36 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
	by mx08-00178001.pphosted.com (8.14.5/8.14.5) with SMTP id t765MZbV025263
	for <linux-media@vger.kernel.org>; Thu, 6 Aug 2015 07:22:35 +0200
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx08-00178001.pphosted.com with ESMTP id 1w3hh6mn5m-1
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Thu, 06 Aug 2015 07:22:35 +0200
Received: from zeta.dmz-ap.st.com (ns6.st.com [138.198.234.13])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 1E77C23
	for <linux-media@vger.kernel.org>; Thu,  6 Aug 2015 05:22:30 +0000 (GMT)
Received: from Webmail-ap.st.com (eapex1hubcas1.st.com [10.80.176.8])
	by zeta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 6A8F211A
	for <linux-media@vger.kernel.org>; Thu,  6 Aug 2015 05:22:29 +0000 (GMT)
From: Udit KUMAR <udit-dlh.kumar@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Udit KUMAR <udit-dlh.kumar@st.com>,
	Dimple GERA <dimple.gera@st.com>
Date: Thu, 6 Aug 2015 13:22:27 +0800
Subject: VIDIOC_S_EXT_CTRLS 
Message-ID: <ADCA285CF15CD143BF1E6E2BAF6868AA0894EA4CD6@EAPEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello 

When passing strings which has NULL in between, low level driver will not get full strings. 
Our typical use case is kernel level muxer, where "PMT" descriptor  is passed as strings, which will have NULL in between. 

In this case V4L2, copies the whole size and passing only stings to low level driver. 
If V4L2 sends size along with strings to low level driver then it will fix the problem and let low level driver to decide whether they want to use
size of strings or size. 

Below patch is proposed to fix such issues. 

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 7e38d59..bd3dc67 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1166,10 +1166,12 @@ static int user_to_new(struct v4l2_ext_control *c,
 	u32 size;
 
 	ctrl->is_new = 1;
+	ctrl->size = c->size;
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER64:
 		ctrl->val64 = c->value64;
 		break;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 47ada23..75ec59c 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -152,6 +152,7 @@ struct v4l2_ctrl {
 		char *string;
 	};
 	void *priv;
+	u32 size;
 };
 
 /** struct v4l2_ctrl_ref - The control reference.



Regards
Udit
