Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.61]:55619 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3IPU1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Sep 2013 16:27:37 -0400
Received: from [177.102.42.224] (helo=[192.168.1.143])
	by mail4.atlas.pipex.net with esmtpa (Exim 4.71)
	(envelope-from <it@sca-uk.com>)
	id 1VLfOP-0007F9-89
	for linux-media@vger.kernel.org; Mon, 16 Sep 2013 21:27:33 +0100
Message-ID: <523769B0.6070908@sca-uk.com>
Date: Mon, 16 Sep 2013 17:27:28 -0300
From: Steve Cookson <it@sca-uk.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Canvassing for Linux support for Startech PEXHDCAP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi People,

I just wrote an email to this group about the Hauppauge 01381. Really it 
was a fall-back choice.  If I can't get anything else then that might be 
my only option left.

But here is my preferred choice.  The Startech PEXHDCAP.

It costs about $100 here:

http://www.amazon.com/StarTech-com-Express-Video-Capture-1080p/dp/B007U5MGBE/ref=cm_cr_pr_product_top

Here is a review of it:

http://www.videogameperfection.com/av-gear/startech-pexhdcap-hdmirgbvgacomponent-capture-card-review/

Here is the spec:

http://www.startech.com/AV/Converters/Video/PCI-Express-HD-Video-Capture-Card-1080p-HDMI-DVI-VGA-Component~PEXHDCAP#tchspcs

But the main spec points (for me at least) are

- It's based on the Mstar MST3367CMK chip as are many similar cards,
- It's PCIe connection
- It has inputs of:
--- Component Video (YPbPr)
--- DVI-I   (plus a vga adaptor)
--- HDMI
--- Stereo Audio
- Maximum Digital Resolution: 1080p30
- TV input resolution: 1080i/p, 720p, 576i/p, 480i/p
- PC input resolution: 1920x1080, 1440x900, 1280x1024, 1280x960, 
1280x720, 1024x768, 800x600
- MPEG4/H.264 hardware compression.

But:

- OS Compatibility Windows®

There are already a number of positive reviews for this card around the 
place together with it's twin the Micomsoft SC-500N1.

I would like to ask for expressions of interest for putting together a 
group of like-minded interested people to build an open source v4l2 
driver and associated gstreamer bits and pieces, together with 
specifying any hardware that might be required.  I'd like to identify or 
specify any (cheap) converters, sync splitters and the like which would 
make it work for the full range of signals (eg Composite and S-video - 
that s-video-like mini-port in the picture is actually a YPbPr Component 
input).

I would be great for gaming, medical image capture, university and 
research purposes.

Please let me know what you think.

Regards

Steve.
