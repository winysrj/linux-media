Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1149 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbaDORNs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 13:13:48 -0400
Message-ID: <534D68C2.6050902@xs4all.nl>
Date: Tue, 15 Apr 2014 19:13:38 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steve Cookson - IT <it@sca-uk.com>,
	Steven Toth <stoth@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge ImpactVCB-e 01385
References: <534675E1.6050408@sca-uk.com> <5347B132.6040206@sca-uk.com> <5347B9A3.2050301@xs4all.nl> <5347BDDE.6080208@sca-uk.com> <5347C57B.7000207@xs4all.nl> <5347DD94.1070000@sca-uk.com> <5347E2AF.6030205@xs4all.nl> <5347EB5D.2020408@sca-uk.com> <5347EC3D.7040107@xs4all.nl> <5348392E.40808@sca-uk.com> <534BEA8A.2040604@xs4all.nl> <534D6241.5060903@sca-uk.com>
In-Reply-To: <534D6241.5060903@sca-uk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/15/2014 06:45 PM, Steve Cookson - IT wrote:
>   Hi Hans,
> On 14/04/14 15:02, Hans Verkuil wrote:
> 
>  > I'd appreciate it if you can test this with a proper video feed.
> 
> Well, I've been installing the patch today.  I finished the compilation 
> script and the card is not detected.  Here's what I did:
> 
> It's been a bit hard-going because my ISP has been on a go-slow and 
> everything has taken much longer than it should.
> 
> 1    I did a fresh build of linux tv.  Deleted ~/linuxtv/media_build and 
> then typed:
> 2    user$ git clone git://linuxtv.org/media_build.git
> 3    user$ cd media_build
> 4    user$./build --main-git
> 
>      This seemed to be fine.
> 
> 5    tried to apply the patch (patch -p1 cx23885) but had issues (only 
> the main ...card.c was updated and ....h and ...video.c were not 
> updated).  As it was only one line each, I applied the updates manually.
> 6    user$ cd media
> 7    user$ sudo -s
> 8    root$ make -C ../v4l  (it scrolled up quickly, but completed with 
> no apparent errors
> 9    root$ make -C ../ install
> 10    root$ make -C .. rmmod (had a number of errors because of stk1160 
> so unplugged EasyCap and re-ran, lots of errors - see below)

You may have to do a 'depmod -a' here. Try that first.

> 11    tried to modprobe cx23885, but got "invalid agrgument"

Somewhat strange error message. Does 'dmesg' give you any useful info?

Regards,

	Hans

> 12    tried to reboot, but ls /dev/video* showed nothing.
> 
> Following are the errors from make -C .. rmmo.
> 
> The ImpactVCB-e card is installed.  Should I unplug it before doing 
> point 11?
> 
