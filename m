Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34357 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbcD0FFw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 01:05:52 -0400
Received: by mail-wm0-f67.google.com with SMTP id n129so50687wmn.1
        for <linux-media@vger.kernel.org>; Tue, 26 Apr 2016 22:05:51 -0700 (PDT)
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
To: Sebastian Reichel <sre@kernel.org>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
Cc: sakari.ailus@iki.fi, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <572048AC.7050700@gmail.com>
Date: Wed, 27 Apr 2016 08:05:48 +0300
MIME-Version: 1.0
In-Reply-To: <20160427030850.GA17034@earth>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 27.04.2016 06:08, Sebastian Reichel wrote:
> Hi,
>
> On Mon, Apr 25, 2016 at 12:08:00AM +0300, Ivaylo Dimitrov wrote:
>> Those patch series make cameras on Nokia N900 partially working.
>> Some more patches are needed, but I've already sent them for
>> upstreaming so they are not part of the series:
>>
>> https://lkml.org/lkml/2016/4/16/14
>> https://lkml.org/lkml/2016/4/16/33
>>
>> As omap3isp driver supports only one endpoint on ccp2 interface,
>> but cameras on N900 require different strobe settings, so far
>> it is not possible to have both cameras correctly working with
>> the same board DTS. DTS patch in the series has the correct
>> settings for the front camera. This is a problem still to be
>> solved.
>>
>> The needed pipeline could be made with:
>>
>> media-ctl -r
>> media-ctl -l '"vs6555 binner 2-0010":1 -> "video-bus-switch":2 [1]'
>> media-ctl -l '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]'
>> media-ctl -l '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]'
>> media-ctl -l '"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]'
>> media-ctl -l '"OMAP3 ISP preview":1 -> "OMAP3 ISP resizer":0 [1]'
>> media-ctl -l '"OMAP3 ISP resizer":1 -> "OMAP3 ISP resizer output":0 [1]'
>> media-ctl -V '"vs6555 pixel array 2-0010":0 [SGRBG10/648x488 (0,0)/648x488 (0,0)/648x488]'
>> media-ctl -V '"vs6555 binner 2-0010":1 [SGRBG10/648x488 (0,0)/648x488 (0,0)/648x488]'
>> media-ctl -V '"OMAP3 ISP CCP2":0 [SGRBG10 648x488]'
>> media-ctl -V '"OMAP3 ISP CCP2":1 [SGRBG10 648x488]'
>> media-ctl -V '"OMAP3 ISP CCDC":2 [SGRBG10 648x488]'
>> media-ctl -V '"OMAP3 ISP preview":1 [UYVY 648x488]'
>> media-ctl -V '"OMAP3 ISP resizer":1 [UYVY 656x488]'
>>
>> and tested with:
>>
>> mplayer -tv driver=v4l2:width=656:height=488:outfmt=uyvy:device=/dev/video6 -vo xv -vf screenshot tv://
>
> 4.6-rc4 + twl regulator patch + the patches mentioned above + this
> patchset (I put everything together here [0]) do _not_ work for me.
> The error matches what I have seen when I was working on it: No
> image data seems to be received by the ISP. For example there are
> no related IRQs:
>
> root@n900:~# cat /proc/interrupts  | grep ISP
>   40:          0      INTC  24 Edge      480bd400.mmu, OMAP3 ISP
>
> I tested with mpv and yavta (yavta --capture=8 --pause --skip 0
> --format UYVY --size 656x488 /dev/video6)
>
> [0] https://git.kernel.org/cgit/linux/kernel/git/sre/linux-n900.git/log/?h=n900-camera-ivo
>

Ok, going to diff with my tree to see what I have missed to send in the 
patchset

Thanks
