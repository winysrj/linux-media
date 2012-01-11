Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ces.ch ([212.147.83.3]:3456 "EHLO smtp-1.ces.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751983Ab2AKKUs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 05:20:48 -0500
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Subject: V4L spec possibly broken
Message-ID: <OFC0C35484.6D81A1B1-ONC1257982.003765AA-C1257982.003771F1@ces.ch>
From: Rupert Eibauer <Rupert.Eibauer@ces.ch>
Date: Wed, 11 Jan 2012 11:05:36 +0100
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am working on the linux driver for our new video capture board and 
facing some compatibility problem which seems to be related to unclear 
language in the V4L specification.

The device supports a larger number of inputs, but with a different set of 
standards on each of them.

Now, the problem is that ffmpeg is using VIDIOC_ENUMSTD/VIDIOC_S_STD 
before VIDIOC_S_INPUT.
So the driver has to give a list of supported standards before knowing 
which input the device will be taking.

Currently I am experimenting with a workaround to remember the set 
standard and then failing 
on VIDIOC_S_INPUT when not compatible, but this seems to create more 
problems than it solves. I have
the feeling that this behaviour is not covered by the specification, and 
it makes the driver unnecesarily complex.

In my opinion, the standard is broken: on page 
http://v4l2spec.bytesex.org/spec/r11217.htm, it says:
"It is good practice to select an input before querying or negotiating any 
other parameters."
It should be changed to "Aplications must...", and ffmpeg needs fixing to 
call VIDIOC_S_INPUT before VIDIOC_ENUMSTD.

I hope to get some opinion from you, if this is the right approach or not.

Best regards,
Rupert Eibauer
