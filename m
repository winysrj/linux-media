Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:44400 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbZDQNp1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 09:45:27 -0400
Date: Fri, 17 Apr 2009 15:45:20 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Oldrich Jedlicka <oldium.pro@seznam.cz>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 6/6] saa7134: Simplify handling of IR on AVerMedia
 Cardbus
Message-ID: <20090417154520.6a35bb30@hyperion.delvare>
In-Reply-To: <200904092312.51891.oldium.pro@seznam.cz>
References: <200904092312.51891.oldium.pro@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oldrich,

On Thu, 9 Apr 2009 23:12:51 +0200, Oldrich Jedlicka wrote:
> On Saturday 04 of April 2009 at 14:31:37, Jean Delvare wrote:
> > Now that we instantiate I2C IR devices explicitly, we can skip probing
> > altogether on boards where the I2C IR device address is known. The
> > AVerMedia Cardbus are two of these boards.
> >
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > ---
> >  linux/drivers/media/video/saa7134/saa7134-input.c |   35
> > +++------------------ 1 file changed, 5 insertions(+), 30 deletions(-)
> >
> > ---
> > v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-input.c	2009-04-04
> > 10:41:44.000000000 +0200 +++
> > v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c	2009-04-04
> > 10:47:10.000000000 +0200 @@ -691,22 +691,6 @@ void
> > saa7134_probe_i2c_ir(struct saa7134
> >  		I2C_CLIENT_END
> >  	};
> >
> > -	unsigned char subaddr, data;
> > -	struct i2c_msg msg_avermedia[] = { {
> > -		.addr = 0x40,
> > -		.flags = 0,
> > -		.len = 1,
> > -		.buf = &subaddr,
> > -	}, {
> > -		.addr = 0x40,
> > -		.flags = I2C_M_RD,
> > -		.len = 1,
> > -		.buf = &data,
> > -	} };
> > -
> > -	struct i2c_client *client;
> > -	int rc;
> > -
> >  	if (disable_ir) {
> >  		dprintk("IR has been disabled, not probing for i2c remote\n");
> >  		return;
> > @@ -753,6 +737,10 @@ void saa7134_probe_i2c_ir(struct saa7134
> >  		init_data.get_key = get_key_beholdm6xx;
> >  		init_data.ir_codes = ir_codes_behold;
> >  		break;
> > +	case SAA7134_BOARD_AVERMEDIA_CARDBUS:
> > +	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
> > +		info.addr = 0x40;
> > +		break;
> >  	}
> 
> The Avermedia Cardbus (E500 - SAA7134_BOARD_AVERMEDIA_CARDBUS) doesn't have 
> remote control as far as I know. The first model was Cardbus Plus (E501R) 
> which is not supported (yet), but Grigory Milev reported that it works with 
> small patching. I plan to send patches after some more testing.

OK, I've removed case SAA7134_BOARD_AVERMEDIA_CARDBUS from my patch,
thanks for letting me know.

-- 
Jean Delvare
