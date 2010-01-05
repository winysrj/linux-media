Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:52897 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab0AEMlQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2010 07:41:16 -0500
Received: by fxm25 with SMTP id 25so9687775fxm.21
        for <linux-media@vger.kernel.org>; Tue, 05 Jan 2010 04:41:14 -0800 (PST)
Date: Tue, 5 Jan 2010 14:41:15 +0200
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Sergey Bolshakov <sbolshakov@altlinux.ru>
Cc: linux-media@vger.kernel.org
Subject: Re: cx18: Need information on SECAM-D/K problem with PVR-2100
Message-ID: <20100105124115.GA30674@moon>
References: <1262574635.5963.40.camel@localhost> <m34on2ayio.fsf@hammer.lioka.obninsk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m34on2ayio.fsf@hammer.lioka.obninsk.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 04, 2010 at 02:40:47PM +0300, Sergey Bolshakov wrote:
> >>>>> "Andy" == Andy Walls <awalls@radix.net> writes:
> 
>  > Sergey,
>  > On IRC you mentioned a problem of improper detection of SECAM-D/K with
>  > the Leadtek PVR2100 (XC2028 and CX23418) from an RF source.
> 
> It was some misunderstanding, i suppose, i do not have problems with
> secam, i had improper detection of sound standard (and silence as
> result) on pal channels. Later i've found, that fully-specified std
> (pal-d instead of just pal) helps, so i can live with that.
> 

Thats a general problem of any card with XC2028 silicon tuner, user
(tv app) has to specify a precise substandard (audio carrier frequency)
for sound to work.

PAL-BG users (western europe, etc) won't notice it, since in case of 
generic PAL standard set, xceive tuner defaults to BG substandard firmware.

In other cases, you either have to specify correct standard (DK, etc) or
try to specify PAL-I, which seems to work for BG, DK and I carriers.
At least it works for me :)

See http://osdir.com/ml/linux-media/2009-09/msg00997.html for more details.
