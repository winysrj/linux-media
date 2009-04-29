Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:54271 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760413AbZD2S6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2009 14:58:33 -0400
Message-ID: <49F8A325.7060303@freemail.hu>
Date: Wed, 29 Apr 2009 20:57:41 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] v4l2: fill the reserved fields of VIDIOC_REQBUFS ioctl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The parameter of VIDIOC_REQBUFS is a pointer to struct v4l2_requestbuffers.
This structure has reserved fields which has to be filled with zeros
according to the V4L2 API specification, revision 0.24 [1].

The patch was tested with v4l-test 0.13 [2] with vivi driver.

References:
[1] V4L2 API specification, revision 0.24
    http://v4l2spec.bytesex.org/spec/r13696.htm

[2] v4l-test: Test environment for Video For Linux Two API
    http://v4l-test.sourceforge.net/

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.30-rc3/drivers/media/video/v4l2-ioctl.c.orig	2009-04-22 05:07:00.000000000 +0200
+++ linux-2.6.30-rc3/drivers/media/video/v4l2-ioctl.c	2009-04-29 19:07:46.000000000 +0200
@@ -1818,6 +1818,7 @@ static unsigned long cmd_input_size(unsi
 		CMDINSIZE(G_SLICED_VBI_CAP,	sliced_vbi_cap,	type);
 		CMDINSIZE(ENUM_FRAMESIZES,	frmsizeenum,	pixel_format);
 		CMDINSIZE(ENUM_FRAMEINTERVALS,	frmivalenum,	height);
+		CMDINSIZE(REQBUFS,		requestbuffers, memory);
 	default:
 		return _IOC_SIZE(cmd);
 	}
