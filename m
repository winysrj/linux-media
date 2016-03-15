Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:60076 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842AbcCOKOW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 06:14:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.macqel.be (Postfix) with ESMTP id AA2BF158AC3
	for <linux-media@vger.kernel.org>; Tue, 15 Mar 2016 11:14:19 +0100 (CET)
Received: from smtp2.macqel.be ([127.0.0.1])
	by localhost (mail.macqel.be [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x1YNpB29LPAt for <linux-media@vger.kernel.org>;
	Tue, 15 Mar 2016 11:14:18 +0100 (CET)
Received: from frolo.macqel.be (frolo.macqel [10.1.40.73])
	by smtp2.macqel.be (Postfix) with ESMTP id 0E394150A89
	for <linux-media@vger.kernel.org>; Tue, 15 Mar 2016 11:14:18 +0100 (CET)
Date: Tue, 15 Mar 2016 11:14:17 +0100
From: Philippe De Muyter <phdm@macq.eu>
To: linux-media@vger.kernel.org
Subject: subdev sensor driver and
	V4L2_FRMIVAL_TYPE_CONTINUOUS/V4L2_FRMIVAL_TYPE_STEPWISE
Message-ID: <20160315101417.GA31990@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry if you read the following twice, but the subject of my previous post
was not precise enough :(

I am in the process of converting a sensor driver compatible with the imx6
freescale linux kernel, to a subdev driver compatible with a current kernel
and Steve Longerbeam's work.

My sensor can work at any fps (even fractional) up to 60 fps with its default
frame size or even higher when using crop or "binning'.  That fact is reflected
in my previous implemetation of VIDIOC_ENUM_FRAMEINTERVALS, which answered
with a V4L2_FRMIVAL_TYPE_CONTINUOUS-type reply.

This seem not possible anymore because of the lack of the needed fields
in the 'struct v4l2_subdev_frame_interval_enum' used to delegate the question
to the subdev driver.  V4L2_FRMIVAL_TYPE_STEPWISE does not seem possible
anymore either.  Has that been replaced by something else or is that
functionality not considered relevant anymorea ?

Best regards

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
