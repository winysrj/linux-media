Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.irisys.co.uk ([195.12.16.217]:57445 "EHLO
	mail.irisys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3GEIgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jul 2013 04:36:16 -0400
Received: from mail.irisys.co.uk (localhost.localdomain [127.0.0.1])
	by localhost (Email Security Appliance) with SMTP id 3749B11DB71_1D6824DB
	for <linux-media@vger.kernel.org>; Fri,  5 Jul 2013 08:22:37 +0000 (GMT)
Received: from server10.irisys.local (unknown [192.168.100.72])
	by mail.irisys.co.uk (Sophos Email Appliance) with ESMTP id 0E34211DACC_1D6824DF
	for <linux-media@vger.kernel.org>; Fri,  5 Jul 2013 08:22:37 +0000 (GMT)
From: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: width and height of JPEG compressed images
Date: Fri, 5 Jul 2013 08:22:35 +0000
Message-ID: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am writing a driver for the sensor MT9D131.  This device supports digital zoom and JPEG compression.

Although I am writing it for my company's internal purposes, it will be made open-source, so I would like to keep the API as portable as possible.

The hardware reads AxB sensor pixels from its array, resamples them to CxD image pixels, and then compresses them to ExF bytes.

The subdevice driver sets size AxB to the value it receives from v4l2_subdev_video_ops.s_crop().

To enable compression then v4l2_subdev_video_ops.s_mbus_fmt() is called with fmt->code=V4L2_MBUS_FMT_JPEG_1X8.

fmt->width and fmt->height then ought to specify the size of the compressed image ExF, that is, the size specified is the size in the format specified (the number of JPEG_1X8), not the size it would be in a raw format.

This allows the bridge driver to be compression agnostic.  It gets told how many bytes to allocate per buffer and it reads that many bytes.  It doesn't have to understand that the number of bytes isn't directly related to the number of pixels.

So how does the user tell the driver what size image to capture before compression, CxD?

(or alternatively, if you disagree and think CxD should be specified by s_fmt(), then how does the user specify ExF?)

Regards,
Tom

--
Mr T. Vajzovic
Software Engineer
Infrared Integrated Systems Ltd
Visit us at www.irisys.co.uk
Disclaimer: This e-mail message is confidential and for use by the addressee only. If the message is received by anyone other than the addressee, please return the message to the sender by replying to it and then delete the original message and the sent message from your computer. Infrared Integrated Systems Limited Park Circle Tithe Barn Way Swan Valley Northampton NN4 9BG Registration Number: 3186364.
