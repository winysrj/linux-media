Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out.neti.ee ([194.126.126.34]:32803 "EHLO smtp-out.neti.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626AbZJLUn4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 16:43:56 -0400
Message-ID: <4AD3946D.8040407@proekspert.ee>
Date: Mon, 12 Oct 2009 23:41:17 +0300
From: Lauri Laanmets <lauri.laanmets@proekspert.ee>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: DVB support for MSI DigiVox A/D II and KWorld 320U
References: <4AD3821C.5050306@proekspert.ee> <829197380910121313s50fe7d34oe3fedbf7a5182a48@mail.gmail.com>
In-Reply-To: <829197380910121313s50fe7d34oe3fedbf7a5182a48@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

Tried that but the result is basically the same: "zl10353_attach" gives

[  491.490259] zl10353_read_register: readreg error (reg=127, ret==-19)

And it is funny that if I compile the mcentral latest code in the same 
kernel, it works, but I cannot find the difference in the code :)

Lauri


Devin Heitmueller wrote:
>
>
> In em28xx-dvb.c, try using "em28xx_zl10353_with_xc3028_no_i2c_gate" in
> the dvb_attach() instead of "em28xx_zl10353_with_xc3028".
> Alternatively, move the case line for your board further down so it's
> the same as "EM2882_BOARD_TERRATEC_HYBRID_XS" instead of being the
> same as "EM2880_BOARD_KWORLD_DVB_310U"
>
> Devin
>
>   

