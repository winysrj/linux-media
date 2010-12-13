Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:50635 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab0LMTNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 14:13:06 -0500
Date: Mon, 13 Dec 2010 20:15:05 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 6/6] gspca - sonixj: Better handling of the bridge
 registers 0x01 and 0x17
Message-ID: <20101213201505.756f930d@tele>
In-Reply-To: <4D061F3C.8060101@redhat.com>
References: <20101213140430.576c0fc1@tele>
	<4D061F3C.8060101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Mon, 13 Dec 2010 11:27:24 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> >  	case SENSOR_OV7660:
> >  		init = ov7660_sensor_param1;
> > -		if (sd->bridge == BRIDGE_SN9C120) {
> > -			if (mode) {		/* 320x240 - 160x120 */
> > -				reg17 = 0xa2;
> > -				reg1 = 0x44;	/* 48 Mhz, video trf eneble */
> > -			}
> > -		} else {
> > -			reg17 = 0x22;
> > -			reg1 = 0x06;	/* 24 Mhz, video trf eneble
> > -					 * inverse power down */
> > -		}  
> 
> I'm not sure about this... On my tests with the two devices I have
> with ov7660 (sn9c105 and sn9c120), the original driver uses 48 MHz
> for all resolutions.

Hi Mauro,

You are right, I will fix that in the next version.

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
