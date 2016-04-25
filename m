Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33112 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbcDYRVJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 13:21:09 -0400
Received: by mail-wm0-f68.google.com with SMTP id r12so23634896wme.0
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 10:21:08 -0700 (PDT)
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
To: Pavel Machek <pavel@ucw.cz>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160424215541.GA6338@amd> <571DBA2E.9020305@gmail.com>
 <20160425170905.GB10443@amd>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <571E5201.4030609@gmail.com>
Date: Mon, 25 Apr 2016 20:21:05 +0300
MIME-Version: 1.0
In-Reply-To: <20160425170905.GB10443@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 25.04.2016 20:09, Pavel Machek wrote:
> Hi!
>
>>>> The needed pipeline could be made with:
>>>
>>> Would you have similar pipeline for the back camera? Autofocus and
>>> 5MPx makes it more interesting. I understand that different dts will
>>> be needed.
>>>
>>
>> Try with:
>>
>> media-ctl -r
>> media-ctl -l '"et8ek8 3-003e":0 -> "video-bus-switch":1 [1]'
>> media-ctl -l '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]'
>> media-ctl -l '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]'
>> media-ctl -l '"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]'
>> media-ctl -l '"OMAP3 ISP preview":1 -> "OMAP3 ISP resizer":0 [1]'
>> media-ctl -l '"OMAP3 ISP resizer":1 -> "OMAP3 ISP resizer output":0 [1]'
>>
>> media-ctl -V '"et8ek8 3-003e":0 [SGRBG10 864x656]'
>> media-ctl -V '"OMAP3 ISP CCP2":0 [SGRBG10 864x656]'
>> media-ctl -V '"OMAP3 ISP CCP2":1 [SGRBG10 864x656]'
>> media-ctl -V '"OMAP3 ISP CCDC":2 [SGRBG10 864x656]'
>> media-ctl -V '"OMAP3 ISP preview":1 [UYVY 864x656]'
>> media-ctl -V '"OMAP3 ISP resizer":1 [UYVY 800x600]'
>>
>>
>> mplayer -tv driver=v4l2:width=800:height=600:outfmt=uyvy:device=/dev/video6
>> -vo xv -vf screenshot tv://
>
> It fails with:
>
> pavel@n900:/my/tui/ofone/camera$ sudo ./back.sh
> Unable to parse link: Device or resource busy (16)

That shouldn't happen, there is something else wrong.

> MPlayer svn r34540 (Debian), built with gcc-4.6 (C) 2000-2012 MPlayer
> Team
>
> ...but as I'm using the original dts, it is expected...?
>
> Would you have dts suitable for the 5MPx camera?
>

Just change from strobe = <0>; to strobe = <1>; in isp node.

Ivo
