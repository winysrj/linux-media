Return-path: <linux-media-owner@vger.kernel.org>
Received: from avocado.salatschuessel.net ([78.111.72.186]:10416 "EHLO
	avocado.salatschuessel.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753365AbbCQVmM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2015 17:42:12 -0400
Date: Tue, 17 Mar 2015 22:35:29 +0100
Message-ID: <20150317223529.Horde.S4cQ0yA7NJaIix7vWKABGA9@avocado.salatschuessel.net>
From: Oliver Lehmann <lehmann@ans-netz.de>
To: linux-media@vger.kernel.org
Subject: capture high resolution images from webcam
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm using v4l2 on FreeBSD but I hope this doesn't matter that much.
I got a new MS LifeCam Studio HD which makes quite good pictures
because of its focus possibilites.

When I use the original software provided by MS the "autofocus"
feature works damn good. With v4l2, autofocus is enabled but it
just does not focus. Disabling autofocus and setting focus manually
does work (and in my case this is sufficient)

Another point is, that this cam can record pictures with 8 megapixel
which results in 3840x2160 image files. This "8MP mode" and the 1080p
mode is only available for snapshot pictures. The highest resolution
supported for videos is 720p.

All I want is recording snapshot images and I do not need the video
capability at all.

I wonder how I can capture those big 8MP images? With mplayer I'm
only able toe capture 720p at max. I guess because mplayer just
accesses the video mode and takes a single frame.

mplayer tv:// -tv driver=v4l2:device=/dev/video0:width=1280:height=720  
-frames 1 -vo jpeg

I wonder if there is a possibility to access the cam in the
I-call-it-snapshot-mode to take single pictures with higher resolutions?

Regards, Oliver
