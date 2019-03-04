Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57107C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 12:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26E7720830
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 12:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfCDMf4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 07:35:56 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:21090 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726041AbfCDMf4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Mar 2019 07:35:56 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x24CVhYw002801;
        Mon, 4 Mar 2019 13:35:50 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2qyhgakd3m-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 04 Mar 2019 13:35:50 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 78EC538;
        Mon,  4 Mar 2019 12:35:49 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas21.st.com [10.75.90.44])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 528682A3C;
        Mon,  4 Mar 2019 12:35:49 +0000 (GMT)
Received: from SAFEX1HUBCAS22.st.com (10.75.90.93) by SAFEX1HUBCAS21.st.com
 (10.75.90.44) with Microsoft SMTP Server (TLS) id 14.3.361.1; Mon, 4 Mar 2019
 13:35:49 +0100
Received: from localhost (10.201.23.19) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.361.1; Mon, 4 Mar 2019 13:35:48
 +0100
From:   Hugues Fruchet <hugues.fruchet@st.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC:     <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Hugues Fruchet" <hugues.fruchet@st.com>
Subject: [PATCH] Support of /dev/video read with USB camera devices
Date:   Mon, 4 Mar 2019 13:35:24 +0100
Message-ID: <1551702925-7739-1-git-send-email-hugues.fruchet@st.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.23.19]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-04_04:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Currently, read() call from /dev/video entry of an USB camera is
returning invalid argument error.
This is quite common for userspace application to read compressed data such as
JPEG from /dev/video then redirect those data to a multimedia player or any
other compressed format consumer, see [1].

There was a tentative of implementation in the past [2] but it was prior to
switch on vb2 helpers usage inside uvc.
Now that vb2 is in place, we can implement read support using vb2_read()
helper.

Tested with Logitech HD Webcam C525 using v4l2-ctl to configure camera
then GStreamer player to play stream:
$> v4l2-ctl -d /dev/video0 --set-fmt-video=width=640,height=480,pixelformat=MJPG
$> gst-play-1.0 /dev/video0

[1]
  http://credentiality2.blogspot.com/2010/04/v4l2-example.html?_sm_au_=ikcQHNZZFn2Rqft5
  https://stackoverrun.com/fr/q/4215615
  https://stackoverflow.com/questions/36297390/read-function-for-webcam-device-in-v4l2-fails-with-invalid-argument
  https://stackoverflow.com/questions/31058571/reading-camera-input-from-dev-video0-in-python-or-c

[2] https://www.mail-archive.com/linux-uvc-devel@lists.berlios.de/msg01258.html

Hugues Fruchet (1):
  media: uvcvideo: Read support

 drivers/media/usb/uvc/uvc_queue.c | 15 ++++++++++++++-
 drivers/media/usb/uvc/uvc_v4l2.c  | 11 ++++++++---
 drivers/media/usb/uvc/uvcvideo.h  |  2 ++
 3 files changed, 24 insertions(+), 4 deletions(-)

-- 
2.7.4

