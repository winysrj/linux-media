Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36397 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbcDYGdW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 02:33:22 -0400
Received: by mail-wm0-f65.google.com with SMTP id w143so18377300wmw.3
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 23:33:21 -0700 (PDT)
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
To: Pavel Machek <pavel@ucw.cz>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160424215541.GA6338@amd>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <571DBA2E.9020305@gmail.com>
Date: Mon, 25 Apr 2016 09:33:18 +0300
MIME-Version: 1.0
In-Reply-To: <20160424215541.GA6338@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 25.04.2016 00:55, Pavel Machek wrote:
> Hi!
>
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
>
> Would you have similar pipeline for the back camera? Autofocus and
> 5MPx makes it more interesting. I understand that different dts will
> be needed.
>

Try with:

media-ctl -r
media-ctl -l '"et8ek8 3-003e":0 -> "video-bus-switch":1 [1]'
media-ctl -l '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]'
media-ctl -l '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]'
media-ctl -l '"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]'
media-ctl -l '"OMAP3 ISP preview":1 -> "OMAP3 ISP resizer":0 [1]'
media-ctl -l '"OMAP3 ISP resizer":1 -> "OMAP3 ISP resizer output":0 [1]'

media-ctl -V '"et8ek8 3-003e":0 [SGRBG10 864x656]'
media-ctl -V '"OMAP3 ISP CCP2":0 [SGRBG10 864x656]'
media-ctl -V '"OMAP3 ISP CCP2":1 [SGRBG10 864x656]'
media-ctl -V '"OMAP3 ISP CCDC":2 [SGRBG10 864x656]'
media-ctl -V '"OMAP3 ISP preview":1 [UYVY 864x656]'
media-ctl -V '"OMAP3 ISP resizer":1 [UYVY 800x600]'


mplayer -tv 
driver=v4l2:width=800:height=600:outfmt=uyvy:device=/dev/video6 -vo xv 
-vf screenshot tv://


Regards,
Ivo
