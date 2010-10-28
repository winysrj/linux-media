Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48861 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758835Ab0J1OgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 10:36:24 -0400
Received: by pwj3 with SMTP id 3so133286pwj.19
        for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 07:36:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim+JUKSJyb_YE3de-F16kjsnhja8wR8b9H1mHPm@mail.gmail.com>
References: <AANLkTinHT_XPZJU9Xq2cScJoUUCfTps4PXFU9S2_fX=Q@mail.gmail.com>
	<AANLkTim+JUKSJyb_YE3de-F16kjsnhja8wR8b9H1mHPm@mail.gmail.com>
Date: Thu, 28 Oct 2010 08:36:22 -0600
Message-ID: <AANLkTinpHPe0jUVcDcNPwZkTReRsAcAq68F3CpEKx8Rb@mail.gmail.com>
Subject: Re: Kworld usb 2800D audio
From: Tim Stowell <stowellt@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks for the response! That makes sense about the 2.5 mm cable. Not
to be obstinate or anything but I found this link
http://video4linux-list.1448896.n2.nabble.com/SUCCESS-KWorld-VS-USB2800D-recognized-as-PointNix-Intra-Oral-Camera-No-Composite-Input-td3069455.html
where the users claims they were able to get a new capture device that
didn't require using the 2.5mm cable, although I'm not sure how they
did it. I guess I'm hoping to not have to buy a sound card for capture
if at all possible as I'm using an embedded pc that doesn't have any
sound cards, thanks

-Tim

On Thu, Oct 28, 2010 at 8:27 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Thu, Oct 28, 2010 at 10:18 AM, Tim Stowell <stowellt@gmail.com> wrote:
>> Hi,
>>
>> I'm able to capture video just fine with my  Kworld usb 2800D usb
>> device and the recent (I've installed the April v4l-dvb em28xx
>> driver), but I can't get any audio. I tried modprobe em28xx-alsa, and
>> the module loads, but alsa can't find any sound cards. Do I need the
>> snd-usb-audio driver? the usb device is based on the em2860 chip. Any
>> help would be greatly appreciated, thanks.
>
> Hello Tim,
>
> If I recall, the KWorld 2800D doesn't actually capture audio directly
> via the USB.  The device has a 2.5mm cable that you are required to
> connect to our sound card's line-in.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
