Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8728 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab1HEUSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 16:18:25 -0400
From: Andrew Chew <AChew@nvidia.com>
To: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	'Doug Anderson' <dianders@google.com>
Date: Fri, 5 Aug 2011 13:18:19 -0700
Subject: Guidance regarding deferred I2C transactions
Message-ID: <643E69AA4436674C8F39DCC2C05F76383CF0DD22D0@HQMAIL03.nvidia.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm looking for some guidance regarding a clean way to support a certain camera module. 
We are using the soc_camera framework, and in particular, the ov9740.c image sensor driver. 

This camera module has the camera activity status LED tied to the image sensor's power. This is meant as a security feature, so that there is no way to turn the camera on without the user being informed through the status LED.

The problem with this is that any I2C transaction to the image sensor necessitates turning the image sensor on, which results in the status LED turning on. Various methods in the soc camera sensor drivers typically perform I2C transactions. For example, probe will check the image sensor registers to validate device presence. However, this results in the LED blinking during probe, which can be misconstrued as the camera having taken an actual picture. Opening the /dev/video node will also typically blink the status LED for similar reasons (in this case, calling the s_mbus_fmt video op), so any application probing for camera presence will cause the status LED to blink. 

One way to solve this can be to defer these I2C transactions in the image sensor driver all the way up to the time the image sensor is asked to start streaming frames. However, it seems to me that this breaks the spirit of the probe; applications will successfully probe for camera presence even though the camera isn't actually there. Is this okay?

Is there a better way to do this? Maybe a more general thing we can add to the V4L2 framework?

-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
