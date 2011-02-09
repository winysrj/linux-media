Return-path: <mchehab@pedra>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:50488 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab1BIJc7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 04:32:59 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: "device-drivers-devel@blackfin.uclinux.org"
	<device-drivers-devel@blackfin.uclinux.org>,
	linux-media@vger.kernel.org
Subject: ANN: adv7604 (HDMI receiver) and ad9389b (HDMI transmitter) driver development
Date: Wed, 9 Feb 2011 10:32:56 +0100
Cc: Mats Randgaard <mats.randgaard@cisco.com>,
	"Martin Bugge (marbugge)" <marbugge@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102091032.56528.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

Cisco Systems Norway is developing adv7604 and ad9389b drivers with the goal 
to include them into the linux kernel. More information on these devices can 
be found here:

adv7604: http://ez.analog.com/docs/DOC-1545
ad9389b: http://ez.analog.com/docs/DOC-1741

The initial source code is available here:

http://git.linuxtv.org/hverkuil/cisco.git?a=shortlog;h=refs/heads/cobalt

Besides the two Analog Devices drivers is also contains a 'cobalt' driver 
which is a driver for a PCIe HDMI capture card (not for sale, I'm afraid) that 
serves as an example of how to use the adv7604 driver in an actual driver.

Both Analog Devices drivers need more clean up and probably need to made a bit 
more general. More importantly, new video4linux APIs need to be proposed and 
discussed to standardize some of the HDMI specific handling (EDID, hotplug, 
format changes, info frames, CEC, etc.). I hope we can send out RFCs for this 
by the end of this month. Also the analog input support for the adv7604 is 
very limited at the moment. This will improve in the coming months.

Some of this is already implemented in these drivers, but it uses custom 
events and ioctls.

These drivers do not intend to provide a full-featured implementation, 
especially for the adv7604 the featureset is huge. But it works for our 
hardware and it is a good starting point.

Regards,

	Hans Verkuil
