Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:55251 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZGaIJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 04:09:19 -0400
Received: by gxk9 with SMTP id 9so3499970gxk.13
        for <linux-media@vger.kernel.org>; Fri, 31 Jul 2009 01:09:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A729117.6010001@iol.it>
References: <4A6F8AA5.3040900@iol.it>
	 <829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>
	 <4A7140DD.7040405@iol.it>
	 <829197380907300533l488acd0bt2188c4c599417966@mail.gmail.com>
	 <4A729117.6010001@iol.it>
Date: Fri, 31 Jul 2009 04:09:19 -0400
Message-ID: <829197380907310109r1ca7231cqd86803f0fe640904@mail.gmail.com>
Subject: Re: Terratec Cinergy HibridT XS
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: efa@iol.it
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 31, 2009 at 2:37 AM, Valerio Messina<efa@iol.it> wrote:
> Devin Heitmueller ha scritto:
>>
>> How are you testing the IR support?
>
> starting Kaffeine with a Digital TV channel, pressing numeric key of the
> remote in front of IR receiver connected to Terratec Cinergy Hybrid T XS.
>
>> And are you using the Terratec
>> remote control that came with the product?
>
> yes, the one showed in this picture:
> http://www.terratec.it/prodotti/schede_tv/TerraTec%20Cinergy%20Hybrid%20T%20USB%20XS/CinergyHybridTUSBXSscope.jpg
>
>> Have you tried opening a
>> text editor, hitting the "1" key, and seeing if the character appears?
>
> I tried last evening, and no, does not appear any digit.
>
> My lsusb ID is:
> Bus 001 Device 007:
> ID 0ccd:0042 TerraTec Electronic GmbH Cinergy Hybrid T XS
>
> Note: with Ubuntu 8.04 K2.6.24-21-generic the TV and IR always worked.
> With Ubuntu 8.10 and kernel
> 2.6.27.7-generic, 2.6.27.9-generic, 2.6.27.11-generic, 2.6.27-14-generic
> I needed to add some media Kheaders, but then TV and IR always worked.
> The problem appear just after upgrade to Ubuntu 9.04 kernel
> 2.6.28-13-generic and happen the same for 2.6.28-14-generic
>
> Valerio
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Ah, good news:  the patch I wrote that adds support for the remote
control is still around:

http://linuxtv.org/hg/~dheitmueller/v4l-dvb-terratec-xs/rev/92885f66ac68

I will prep this into a new tree and issue a pull request when I get
back in town on Sunday.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
