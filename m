Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfilter42.ihug.co.nz ([203.109.136.42]:55124 "EHLO
	mailfilter42.ihug.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005AbZJDVCz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2009 17:02:55 -0400
Message-ID: <4AC90B3C.7060407@yahoo.co.nz>
Date: Mon, 05 Oct 2009 09:53:16 +1300
From: Kevin Wells <wells_kevin@yahoo.co.nz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: tm6010 status
References: <4AC8C44E.4050103@free.fr>
In-Reply-To: <4AC8C44E.4050103@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

matthieu castet wrote:
> Hi,
> 
> what's the status of tm6010 support ?
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg04048.html 
> announced some patches,
> but nothing seems to have happened ?
> 
> 
> Matthieu
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Mauro has it on his TODO list:

   http://www.mail-archive.com/linux-media@vger.kernel.org/msg08770.html

I'm not spending any time on this at the moment, and probably won't in 
the future. I spent some time reading the code for the existing driver 
and submitted a few trivial patches, and quite a bit of time with a USB 
sniffer to try and determine where the Linux and Windows XP driver 
behaved differently. But I have subsequently purchased an Asus My-Cinema 
U3100 Mini (DVB-T only) that is cheap and worked out of the box on 
Ubuntu. So I no longer have much motivation to work on this.

I was surprised to find that data sheets are difficult to obtain for the 
tm6010, and for a lot of other chips used in TV devices as well. Why? I 
thought these companies made money by selling chips in significant 
volume rather than by selling development kits. So surely they would 
sell more chips by making documentation available to anyone who wants to 
support their products. If there are trade secrets they are trying to 
protect surely these are in the hardware and firmware rather than the 
driver and the protocols used to communicate with the hardware. Perhaps 
someone on this list can explain how this makes business sense.

So it seems it is common practice to use reverse engineering to get 
drivers working. This is a lot of work and makes me really appreciate 
the work that has been put in by v4l developers.

Kevin Wells
