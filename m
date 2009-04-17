Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:35021 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759834AbZDQQ51 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 12:57:27 -0400
Date: Fri, 17 Apr 2009 18:57:18 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Oldrich Jedlicka <oldium.pro@seznam.cz>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 6/6] saa7134: Simplify handling of IR on AVerMedia
 Cardbus
Message-ID: <20090417185718.010524ca@hyperion.delvare>
In-Reply-To: <200904171816.06125.oldium.pro@seznam.cz>
References: <200904092312.51891.oldium.pro@seznam.cz>
	<20090417154520.6a35bb30@hyperion.delvare>
	<200904171816.06125.oldium.pro@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 17 Apr 2009 18:16:06 +0200, Oldrich Jedlicka wrote:
> Hi Jean,
> 
> On Friday 17 of April 2009 at 15:45:20, Jean Delvare wrote:
> > Hi Oldrich,
> >
> > On Thu, 9 Apr 2009 23:12:51 +0200, Oldrich Jedlicka wrote:
> > > On Saturday 04 of April 2009 at 14:31:37, Jean Delvare wrote:
> [sniff]
> > > > @@ -753,6 +737,10 @@ void saa7134_probe_i2c_ir(struct saa7134
> > > >  		init_data.get_key = get_key_beholdm6xx;
> > > >  		init_data.ir_codes = ir_codes_behold;
> > > >  		break;
> > > > +	case SAA7134_BOARD_AVERMEDIA_CARDBUS:
> > > > +	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
> > > > +		info.addr = 0x40;
> > > > +		break;
> > > >  	}
> > >
> > > The Avermedia Cardbus (E500 - SAA7134_BOARD_AVERMEDIA_CARDBUS) doesn't
> > > have remote control as far as I know. The first model was Cardbus Plus
> > > (E501R) which is not supported (yet), but Grigory Milev reported that it
> > > works with small patching. I plan to send patches after some more
> > > testing.
> >
> > OK, I've removed case SAA7134_BOARD_AVERMEDIA_CARDBUS from my patch,
> > thanks for letting me know.
> 
> You can add SAA7134_BOARD_AVERMEDIA_501 there - if my patch for it get 
> accepted :-)

Obviously I can't add it before your own patch is in ;)

-- 
Jean Delvare
