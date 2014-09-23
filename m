Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37194 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbaIWNLI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 09:11:08 -0400
Date: Tue, 23 Sep 2014 10:11:03 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Bimow Chen <Bimow.Chen@ite.com.tw>
Subject: Re: [PATCH 4/4] V4L/DVB: Add sleep for firmware ready
Message-ID: <20140923101103.224370bb@recife.lan>
In-Reply-To: <542160F0.1000407@iki.fi>
References: <20140923085039.51765665@recife.lan>
	<542160F0.1000407@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 23 Sep 2014 15:00:48 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> I am not sure as I cannot reproduce it. Also 30ms wait here is long as 
> hell, whilst it is not critical.
> 
> When I look that firmware downloading from the 1-2 month old Hauppauge 
> driver sniffs, it is not there:
> 
> That line is CMD_FW_BOOT, command 0x23 it is 3rd number:
> #define CMD_FW_BOOT                 0x23
> 000313:  OUT: 000000 ms 001490 ms BULK[00002] >>> 05 00 23 9a 65 dc
> 
> Here is whole sequence:
> 000311:  OUT: 000000 ms 001489 ms BULK[00002] >>> 15 00 29 99 03 01 00 
> 01 57 f7 09 02 6d 6c 02 4f 9f 02 4f a2 0b 16
> 000312:  OUT: 000001 ms 001489 ms BULK[00081] <<< 04 99 00 66 ff
> 000313:  OUT: 000000 ms 001490 ms BULK[00002] >>> 05 00 23 9a 65 dc
> 000314:  OUT: 000011 ms 001490 ms BULK[00081] <<< 04 9a 00 65 ff
> 000315:  OUT: 000000 ms 001501 ms BULK[00002] >>> 0b 00 00 9b 01 02 00 
> 00 12 22 40 ec
> 000316:  OUT: 000000 ms 001501 ms BULK[00081] <<< 05 9b 00 02 62 ff
> 
> 
> So windows driver waits 10ms after boot, not before.
> 
> Due to these reasons, I would like to skip that patch until I see error 
> or get good explanation why it is needed and so.

Ok. I'll tag it as RFC then.

> 
> 
> regards
> Antti
> 
> 
> On 09/23/2014 02:50 PM, Mauro Carvalho Chehab wrote:
> > Antti,
> >
> > After the firmware load changes, is this patch still applicable?
> >
> > Regards,
> > Mauro
> >
> > Forwarded message:
> >
> > Date: Tue, 05 Aug 2014 13:48:03 +0800
> > From: Bimow Chen <Bimow.Chen@ite.com.tw>
> > To: linux-media@vger.kernel.org
> > Subject: [PATCH 4/4] V4L/DVB: Add sleep for firmware ready
> >
> >
> >  From b19fa868ce937a6ef10f1591a49b2a7ad14964a9 Mon Sep 17 00:00:00 2001
> > From: Bimow Chen <Bimow.Chen@ite.com.tw>
> > Date: Tue, 5 Aug 2014 11:20:53 +0800
> > Subject: [PATCH 4/4] Add sleep for firmware ready.
> >
> >
> > Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
> > ---
> >   drivers/media/usb/dvb-usb-v2/af9035.c |    2 ++
> >   1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> > index 7b9b75f..a450cdb 100644
> > --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> > +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> > @@ -602,6 +602,8 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
> >   	if (ret < 0)
> >   		goto err;
> >
> > +	msleep(30);
> > +
> >   	/* firmware loaded, request boot */
> >   	req.cmd = CMD_FW_BOOT;
> >   	ret = af9035_ctrl_msg(d, &req);
> >
> 
