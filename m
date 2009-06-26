Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:52480 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbZFZQdJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 12:33:09 -0400
Date: Fri, 26 Jun 2009 11:33:11 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: jmdk <jmdk@aokks.org>
cc: linux-media@vger.kernel.org
Subject: Re: Cropping with Hauppauge HVR-1900
In-Reply-To: <4A44990F.5050901@aokks.org>
Message-ID: <Pine.LNX.4.64.0906261126350.31925@cnc.isely.net>
References: <4A44990F.5050901@aokks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 26 Jun 2009, jmdk wrote:

> Hello,
> 
> I have a Hauppauge HVR-1900 which works fine with the pvrusb2 driver.
> However because most TV channels now air with 16:9 content inside 4:3
> images, I would like to crop out the top and bottom black bars before
> encoding via the hardware MPEG2 encoder. I tried using the ctl_crop_top
> and ctl_crop_height in  /sysfs as well as the --set-crop option of
> v4l2-ctrl but only received error messages indicating a value out of range.
> 
> The card has a cx25843 which should support cropping. Does anyone know
> how to get this feature to work ?
> 
> Thanks in advance for the help,

Unfortunately the cx25840 driver does not implement any cropping 
capability and the recent change to the v4l-subdevice architecture 
currently lacks the API entrypoints to make such a thing possible :-(

A pvrusb2 user a while back (it's in the pvrusb2 list archives) came up 
with some patches to the cx25840 driver that implement cropping.  He 
also generated corresponding patches for the pvrusb2 driver.  I merged 
his pvrusb2 patches (which is why you see that support in the driver) 
but not the cx25840 patches since I'm not an expert on that chip and I 
don't have the ability to verify that the patches preserve correct 
behavior for all the other devices that use the same chip.  I did pass 
the cx25840 patches to Hans Verkuil and he tried them out at the time 
and basically pronounced them "ok" but I think even he wasn't sure if it 
was doing everything right.

That was a while ago and the cx25840 driver has undergone enough other 
changes to make merging those patches a lot more difficult - plus the 
v4l-subdevice stuff needs additional changes to support the extra 
cropping API.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
