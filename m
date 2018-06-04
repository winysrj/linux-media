Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35797 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbeFDI1e (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 04:27:34 -0400
Message-ID: <1528100849.5808.2.camel@pengutronix.de>
Subject: Re: [PATCH v2 04/10] media: imx: interweave only for sequential
 input/interlaced output fields
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Mon, 04 Jun 2018 10:27:29 +0200
In-Reply-To: <m3k1rfnmfr.fsf@t19.piap.pl>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
         <1527813049-3231-5-git-send-email-steve_longerbeam@mentor.com>
         <1527860010.5913.8.camel@pengutronix.de> <m3k1rfnmfr.fsf@t19.piap.pl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-06-04 at 07:35 +0200, Krzysztof Hałasa wrote:
> Philipp Zabel <p.zabel@pengutronix.de> writes:
> 
> > This is ok in this patch, but we can't use this check in the following
> > TRY_FMT patch as there is no way to interweave
> > SEQ_TB -> INTERLACED_BT (because in SEQ_TB the B field is newer than T,
> > but in INTERLACED_BT it has to be older) or SEQ_BT -> INTERLACED_TB (the
> > other way around).
> 
> Actually we can do SEQ_TB -> INTERLACED_BT and SEQ_BT -> INTERLACED_TB
> rather easily. We only need to skip a single field at start :-)
> That's what CCIR_CODE_* registers do.
> 
> To be honest, SEQ_TB and SEQ_BT are precisely the same thing
> (i.e., SEQUENTIAL). It's up to the user to say which field is the first.
> There is the progressive sensor exception, though, and the TB/BT could
> be a hint for downstream elements (i.e., setting the default field
> order).
> 
> But I think we should be able to request INTERLACED_TB or INTERLACED_BT
> (with any analog signal on input) and the CCIR_CODE registers should be
> set accordingly. This should all magically work fine.

The CSI subdevice itself can't interweave at all, this is done in the
IDMAC.
In my opinion the CSI subdev should allow the following src -> sink
field transformations for BT.656:

none -> none
seq-tb -> seq-tb
seq-tb -> seq-bt
seq-bt -> seq-bt
seq-bt -> seq-tb
alternate -> seq-tb
alternate -> seq-bt
interlaced -> interlaced
interlaced-tb -> interlaced-tb
interlaced-bt -> interlaced-bt

The capture video device should then additionally allow selecting
the field order that can be produced by IDMAC interweaving:
INTERLACED_TB if the pad is seq-tb and INTERLACED_BT if the pad is seq-
bt, as that is what the IDMAC can convert.

seq-tb -> seq-tb and seq-bt -> seq-bt should always capture field 0
first, as we currently do for PAL.
seq->tb -> seq-bt and seq-bt -> seq-tb should always capture field 1
first, as we currently do for NTSC.
alternate -> seq-tb and alternate -> seq-bt should match seq-tb -> * for
PAL and seq-bt -> * for NTSC.
The interlaced* -> interlaced* would be handled as progressive.

regards
Philipp
