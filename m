Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:64774 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159AbaGWNSJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 09:18:09 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9600G0R2A7WE60@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Jul 2014 09:18:07 -0400 (EDT)
Date: Wed, 23 Jul 2014 10:18:02 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] si2168: Fix unknown chip version message
Message-id: <20140723101802.6bdaa410.m.chehab@samsung.com>
In-reply-to: <53CF70D0.1060907@iki.fi>
References: <1406056450-16031-1-git-send-email-m.chehab@samsung.com>
 <53CF70D0.1060907@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 23 Jul 2014 11:22:40 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Moikka!
> It is single character formatter, not string, => no need to terminate, 
> so that patch is not valid.

Well, what happened with an invalid firmware is that the first %c was
a 0x00 character, causing that the \n at the end and the others %c
to be discarded.

In other words, if you want to print the data with %c, you should be 
validating that it is a printable character before using %c.

On a separate issue, it is not "unkown" but "unknown".

Regards,
Mauro

> 
> regards
> Antti
> 
> 
> On 07/22/2014 10:14 PM, Mauro Carvalho Chehab wrote:
> > At least here with my PCTV 292e, it is printing this error:
> >
> > 	si2168 10-0064: si2168: unkown chip version Si21170-
> >
> > without a \n at the end. Probably because it is doing something
> > weird or firmware didn't load well. Anyway, better to print it
> > in hex, instead of using %c.
> >
> > While here, fix the typo.
> >
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >   drivers/media/dvb-frontends/si2168.c | 5 ++---
> >   1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> > index 41bdbc4d9f6c..842c4a555d01 100644
> > --- a/drivers/media/dvb-frontends/si2168.c
> > +++ b/drivers/media/dvb-frontends/si2168.c
> > @@ -414,9 +414,8 @@ static int si2168_init(struct dvb_frontend *fe)
> >   		break;
> >   	default:
> >   		dev_err(&s->client->dev,
> > -				"%s: unkown chip version Si21%d-%c%c%c\n",
> > -				KBUILD_MODNAME, cmd.args[2], cmd.args[1],
> > -				cmd.args[3], cmd.args[4]);
> > +				"%s: unknown chip version: 0x%04x\n",
> > +				KBUILD_MODNAME, chip_id);
> >   		ret = -EINVAL;
> >   		goto err;
> >   	}
> >
> 
