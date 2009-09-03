Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp03.uk.clara.net ([195.8.89.36]:44578 "EHLO
	claranet-outbound-smtp03.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbZICLOt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 07:14:49 -0400
Received: from host217-35-101-6.in-addr.btopenworld.com ([217.35.101.6]:36332 helo=f8simon.office.onelan.co.uk)
	by relay03.mail.eu.clara.net (relay.clara.net [213.253.3.43]:1025)
	with esmtpa (authdaemon_plain:simon.farnsworth@onelan.co.uk) id 1MjAHC-0003YF-BC (Exim 4.69) for linux-media@vger.kernel.org
	(return-path <simon.farnsworth@onelan.com>); Thu, 03 Sep 2009 11:14:50 +0000
Message-ID: <4A9FA529.9030707@onelan.com>
Date: Thu, 03 Sep 2009 12:14:49 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Audio on cx18 based cards (Hauppauge HVR1600)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm trying to make a Hauppauge HVR1600 (using the cx18 driver) work well
with Xine; Hans de Goede has sorted out the video side of the card for
me, and I now need to get the audio side cleared up.

I'm used to cards like the Hauppauge HVR1110, which exports an ALSA
interface for audio capture; the HVR1600 doesn't do this. Instead, it
exports a "video" device, /dev/video24 that appears to have some
variation on PCM audio on it instead of video.

How should I handle this in Xine's input_v4l.c? Should the driver be
changed to use ALSA? If not, how do I detect this case, and how should I
configure the PCM audio device?

If the driver needs modifying, I can do this, but I'll need an
explanation of how to do so without breaking things for other people -
I've not done much with ALSA drivers or with V4L2 drivers.
-- 
Simon Farnsworth

