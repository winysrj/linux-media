Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39536 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaKYIQL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 03:16:11 -0500
Message-ID: <1416903368.3166.3.camel@pengutronix.de>
Subject: Re: Connecting ADV76xx to CSI via SFMC
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Tue, 25 Nov 2014 09:16:08 +0100
In-Reply-To: <CAL8zT=hXkTFhQ-Nq_43HWeC2qDHd2DC-r0O3uZwDokBgv3QhEA@mail.gmail.com>
References: <CAL8zT=hXkTFhQ-Nq_43HWeC2qDHd2DC-r0O3uZwDokBgv3QhEA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Michel,

Am Montag, den 24.11.2014, 16:19 +0100 schrieb Jean-Michel Hautbois:
> Hi,
> 
> I am working on using the CSI bus of i.MX6 with a adv7611 chip.
> I started to work with Steve Longerbeam's tree, and here is the
> current tree I am using :
> https://github.com/Vodalys/linux-2.6-imx/tree/mx6-camera-staging-v2-vbx
> 
> This is a WiP tree, and not intended to be complete right now.
> But at least, it should be possible to get a picture.
> I will try to be as complete and synthetic as possible...
> 
> Right now, I am configuring the ADV7611 in "16-Bit SDR ITU-R BT.656
> 4:2:2 Mode 0" (Table 73 in Appendix C of the Reference Manual).

ITU-R BT.656 only specifies 8-bit (or 10-bit) streams, the 16-bit BT.656
SDR/DDR modes with two values on the bus at the same time are somewhat
nonstandard. As far as I can tell, this mode should correspond to the
CSI's BT.1120 SDR mode (Figure 37-20 in MX6DQ Reference Manual v1), so
I'd expect CSI_SENS_CONF to be configured as DATA_WIDTH=1 (8-bit
components), SENS_DATA_FORMAT=1 (YUV422), SENS_PRCTL=5 (progressive
BT.1120 SDR).

regards
Philipp

