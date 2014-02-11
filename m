Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3894 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaBKH4Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 02:56:24 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id s1B7uLxr078958
	for <linux-media@vger.kernel.org>; Tue, 11 Feb 2014 08:56:23 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 5745B2A00A8
	for <linux-media@vger.kernel.org>; Tue, 11 Feb 2014 08:55:55 +0100 (CET)
Message-ID: <52F9D78B.4010201@xs4all.nl>
Date: Tue, 11 Feb 2014 08:55:55 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [ANN] Added streaming tests for v4l2-compliance
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've just committed and pushed my latest changes to v4l2-compliance. It adds
initial support for testing the I/O streaming ioctls. It's currently limited
to standard VIDEO_CAPTURE, so no output, m2m or multiplanar support.

You need to add the -s flag in order to test this, and you may have to set the
correct input and frequency as well since the streaming tests assume you have
a proper video signal on the input.

It already found this regression:

http://www.spinics.net/lists/linux-media/msg72824.html

So any driver that supports VIDIOC_PREPARE_BUF will have to apply that patch
first, otherwise it will definitely fail to work.

By no means am I doing full coverage testing, but at least the main things
are now covered.

Particularly tests for nasty things (wrong pointers, buffers too small, closing
filehandles mid-streaming, stuff like that) need to be added. That's never tested
normally so stress tests like that will be very useful.

Feedback and ideas are welcome!

Regards,

	Hans
