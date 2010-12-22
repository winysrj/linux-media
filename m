Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:4670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab0LVLbD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 06:31:03 -0500
Message-ID: <4D11E170.6050500@redhat.com>
Date: Wed, 22 Dec 2010 09:30:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: nasty bug at qv4l2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hans V/Hans G,

There's a nasty bug at qv4l2 or at libv4l: it is not properly updating 
all info, if you change the video device. On my tests with uvcvideo (video0) 
and a gspca camera (pac7302, video1), it was showing the supported formats
for the uvcvideo camera when I changed from video0 to video1.

The net result is that the image were handled with the wrong decoder
(instead of using fourcc V4L2_PIX_FMT_PJPG, it were using BGR3), producing
a wrong decoding.

Could you please take a look on it?

Cheers,
Mauro
