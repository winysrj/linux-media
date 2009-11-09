Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f204.google.com ([209.85.216.204]:34226 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZKIEEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 23:04:05 -0500
Received: by pxi42 with SMTP id 42so1852128pxi.5
        for <linux-media@vger.kernel.org>; Sun, 08 Nov 2009 20:04:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380911081834v445d36c1yd931c5af69a21505@mail.gmail.com>
References: <cd9524450911081743y92a616amfcb8c6c069112240@mail.gmail.com>
	<829197380911081752x707d9e2bs99f4dc044544d66f@mail.gmail.com>
	<cd9524450911081801i5e8d97f4nd5864d46a66c676e@mail.gmail.com>
	<829197380911081834v445d36c1yd931c5af69a21505@mail.gmail.com>
From: Barry Williams <bazzawill@gmail.com>
Date: Mon, 9 Nov 2009 14:28:30 +1030
Message-ID: <cd9524450911081958v57b77d27iae3ab37ffef1ee8d@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 9, 2009 at 1:04 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Sun, Nov 8, 2009 at 9:01 PM, Barry Williams <bazzawill@gmail.com> wrote:
>> On the first box I have
>> Bus 003 Device 003: ID 0fe9:db98 DVICO
>> Bus 003 Device 002: ID 0fe9:db98 DVICO
>>
>> on the second
>> Bus 001 Device 003: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
>> (ZL10353+xc2028/xc3028) (initialized)
>> Bus 001 Device 002: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
>> (ZL10353+xc2028/xc3028) (initialized)
>
> And on which of the two systems are you still having the tuning
> problem with?  Also, did you reboot after you installed the patch?
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

Hi Devin
I did not reboot after installing the patch somehow I thought simply
removing the module (as I had done to restore some stability to my
system) and reloading the module after the patch would be all I need.
Well I learned that is not the case my apologies for not trying that
first. So your tree fixed my second system with the rev 1 tuner.
However my first system with the rev 2 card while now stable with your
tree will not tune.
Barry
