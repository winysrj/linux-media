Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51776 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab1JXMSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 08:18:31 -0400
Received: from mfilter5-d.gandi.net (mfilter5-d.gandi.net [217.70.178.132])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id 2313A1720A2
	for <linux-media@vger.kernel.org>; Mon, 24 Oct 2011 14:18:30 +0200 (CEST)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter5-d.gandi.net (mfilter5-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id JgDRCreE3cKb for <linux-media@vger.kernel.org>;
	Mon, 24 Oct 2011 14:18:28 +0200 (CEST)
Received: from WIN7PC (ALyon-157-1-242-76.w109-212.abo.wanadoo.fr [109.212.93.76])
	(Authenticated sender: sr@coexsi.fr)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 7EE801720A3
	for <linux-media@vger.kernel.org>; Mon, 24 Oct 2011 14:18:28 +0200 (CEST)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>
References: <004c01cc7a03$064111c0$12c33540$@coexsi.fr> <201110240906.24543@orion.escape-edv.de>
In-Reply-To: <201110240906.24543@orion.escape-edv.de>
Subject: RE: [DVB] Digital Devices Cine CT V6 support
Date: Mon, 24 Oct 2011 14:18:29 +0200
Message-ID: <004e01cc9247$0a8da4d0$1fa8ee70$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Oliver Endriss
> Sent: lundi 24 octobre 2011 09:06
> To: Sébastien RAILLARD (COEXSI)
> Cc: Linux Media Mailing List
> Subject: Re: [DVB] Digital Devices Cine CT V6 support
> 
> Hi,
> 
> > Using your latest development tree (hg clone
> > http://linuxtv.org/hg/~endriss/media_build_experimental), I have made
> > a small modification in ddbridge-core.c (see below) to make the new
> > "Cine CT V6" card detected by the ddbridge module.
> >
> > With this small patch, the card is now detected, but not the double
> > C/T tuner onboard.
> 
> This cannot work, as the cards requires different frontend drivers.
> 
> Please try a fresh check-out from
>   http://linuxtv.org/hg/~endriss/media_build_experimental
> 
> The Cine CT v6 is supported now.
> 

Thank you for the update, we'll test it soon, we're waiting for the new
double-CI reader support.

I've seen a new parameter "ts_loop", can you explain how it's working?
Is-it for sending the stream from the demodulator directly to the CAM
reader?


> > Also, I was wondering why they put a male and a female RF connectors
> > on the "Cine CT V6" (maybe a loop-through?) where there are two female
> > RF connectors on the "DuoFlex CT" card.
> 
> The second connector of the Cine CT is the loop-through output.
> 

Ok

> CU
> Oliver
> 
> --
> ----------------------------------------------------------------
> VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
> 4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
> Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
> ----------------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

