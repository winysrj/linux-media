Return-path: <mchehab@pedra>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:56579 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab1FDPqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jun 2011 11:46:43 -0400
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 86DFF2D9A6
	for <linux-media@vger.kernel.org>; Sat,  4 Jun 2011 17:38:21 +0200 (CEST)
Message-ID: <1307201853.4dea513d52e5d@imp.free.fr>
Date: Sat, 04 Jun 2011 17:37:33 +0200
From: wallak@free.fr
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Cc: linux-media@vger.kernel.org
Subject: Re: AverMedia A306 (cx23385, xc3028, af9013) (A577 too ?)
References: <S932606Ab1ESVJJ/20110519210909Z+86@vger.kernel.org>  <1305839612.4dd587fc20a03@imp.free.fr> <1307119353.15402.5.camel@chimera>
In-Reply-To: <1307119353.15402.5.camel@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

A307 may be close to the A306 board. I've found the following chips: cx23385,
xc[34]?, lg3303). The demodulator is not the same, and follows the ATSC standard
(The A306 is DVB-T compatible).
Coordinating our works may be helpful, for example for the initialization and
the proper reset of the I2C chips. By email that will be OK.

Wallak.



Quoting Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>:

> On Thu, 2011-05-19 at 23:13 +0200, wallak@free.fr wrote:
> > I've tried to use my A306 board on my system. All the main chips are
> > fully
> > supported by linux.
>
> I have the A307 (product ID 0xc939) and I'd like to coordinate with you
> regarding adapting your A306 support for it. If you use IRC at all, just
> tell me when to be in #linuxtv, and if not, we'll keep this on-list.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


