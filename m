Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:51536 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932082Ab2EATJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 1 May 2012 15:09:13 -0400
Received: by qcsp15 with SMTP id p15so2632827qcs.30
        for <linux-media@vger.kernel.org>; Tue, 01 May 2012 12:09:12 -0700 (PDT)
MIME-Version: 1.0
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Tue, 1 May 2012 14:08:49 -0500
Message-ID: <CAKnK67T3q7Qpv0YUFQT4cvGGtdRtZr=8oiVk57m0McJmJXaFrw@mail.gmail.com>
Subject: [Query] About V4L2_CAP_VIDEO_CAPTURE_MPLANE device types
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I wonder if there's an example app for v4l2 devices with
V4L2_CAP_VIDEO_CAPTURE_MPLANE capability?
(like capture.c in V4L2 API docs)

Also, does it have to be mutually exclusive with a
V4L2_CAP_VIDEO_CAPTURE device?

Regards,
Sergio
