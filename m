Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54994 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088Ab0J1Os7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 10:48:59 -0400
Received: by pwj3 with SMTP id 3so145857pwj.19
        for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 07:48:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=gjq91QVA+Q2Y2zsffPfiQ2MmLgHNZcGpoe8cC@mail.gmail.com>
References: <AANLkTinHT_XPZJU9Xq2cScJoUUCfTps4PXFU9S2_fX=Q@mail.gmail.com>
	<AANLkTim+JUKSJyb_YE3de-F16kjsnhja8wR8b9H1mHPm@mail.gmail.com>
	<AANLkTinpHPe0jUVcDcNPwZkTReRsAcAq68F3CpEKx8Rb@mail.gmail.com>
	<AANLkTi=gjq91QVA+Q2Y2zsffPfiQ2MmLgHNZcGpoe8cC@mail.gmail.com>
Date: Thu, 28 Oct 2010 08:48:56 -0600
Message-ID: <AANLkTi=SmHD=PraYiiy0D5fa21XLxzFqDWZz5W5BaSLr@mail.gmail.com>
Subject: Re: Kworld usb 2800D audio
From: Tim Stowell <stowellt@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Ah my bad, I need to read a little deeper it seems :) Thanks for the
info, now I'll stop pulling my hair out trying to get non-existent
audio.

-Tim

On Thu, Oct 28, 2010 at 8:45 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Thu, Oct 28, 2010 at 10:36 AM, Tim Stowell <stowellt@gmail.com> wrote:
>> Thanks for the response! That makes sense about the 2.5 mm cable. Not
>> to be obstinate or anything but I found this link
>> http://video4linux-list.1448896.n2.nabble.com/SUCCESS-KWorld-VS-USB2800D-recognized-as-PointNix-Intra-Oral-Camera-No-Composite-Input-td3069455.html
>> where the users claims they were able to get a new capture device that
>> didn't require using the 2.5mm cable, although I'm not sure how they
>> did it. I guess I'm hoping to not have to buy a sound card for capture
>> if at all possible as I'm using an embedded pc that doesn't have any
>> sound cards, thanks
>
> Read my response in the second message in that thread you provided a
> link for.  :-)
>
> The fact that the ALSA device was being created was actually a bug in
> the em28xx driver.  The hardware does not support capture over the
> USB.
>
> There are other devices which do support audio over the USB - the
> limitation is specific to this particular product.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
