Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:40243 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab3KRKzU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Nov 2013 05:55:20 -0500
Message-ID: <5289F200.8020704@schinagl.nl>
Date: Mon, 18 Nov 2013 11:54:56 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Martin Herrman <martin.herrman@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: ddbridge module fails to load
References: <CADR1r6i7GAHK=4Cb4W3dSxzRtTLJVAmOViPLiS_2O=iN-8Nwgw@mail.gmail.com>
In-Reply-To: <CADR1r6i7GAHK=4Cb4W3dSxzRtTLJVAmOViPLiS_2O=iN-8Nwgw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17-11-13 19:37, Martin Herrman wrote:
> Hi,
>
> Since about a year I'm a happy user of the experimental driver for my
> cine c2 v6.
>
> I have just tried to use the latest code. It compiles without issues
> (kernel 3.11 with gentoo and ck patches), but doesn't load:
>
> ddbridge: Unknown symbol dvb_usercopy (err 0)
>
> I reviewed the updates:
>
> http://linuxtv.org/hg/~endriss/media_build_experimental
>
> and noticed that there have been updates to the drivers I use lately.
> Which is good news!
>
> Unfortunately, the updates cause the above issue. I tried this revision:
>
> http://linuxtv.org/hg/~endriss/media_build_experimental/rev/8c5bb9101f84
You probably best poke Oliver Endriss (ufo) on the VDR portal as that is 
his work and is unrelated or unmaintained here at linux-media.

That said, someone recently stepped up to try to bring in the latest 
driver back into the mailine linux-media repository and should get 
better maintenance.

Oliver (not Endriss)
>
> and now ddbridge loads perfectly and I can watch tv again.
>
> Just wanted to let you know, in case you need any of my help to fix
> this, please feel free to ask.  Note however that I'm certainly not a
> developer, nor a experienced packager.
>
> Regards,
>
> Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

