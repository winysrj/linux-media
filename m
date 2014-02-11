Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37988 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaBKWBT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 17:01:19 -0500
Received: by mail-wi0-f170.google.com with SMTP id hi5so407206wib.1
        for <linux-media@vger.kernel.org>; Tue, 11 Feb 2014 14:01:18 -0800 (PST)
Message-ID: <1392156065.3512.22.camel@canaries32-MCP7A>
Subject: Re: [PATCH 2/2] af9035: Add remaining it913x dual ids to af9035.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Date: Tue, 11 Feb 2014 22:01:05 +0000
In-Reply-To: <52FA8B10.9060009@iki.fi>
References: <1391951046.13992.15.camel@canaries32-MCP7A>
		 <52FA6113.300@iki.fi> <1392150757.3378.14.camel@canaries32-MCP7A>
	 <52FA8B10.9060009@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2014-02-11 at 22:41 +0200, Antti Palosaari wrote:
> On 11.02.2014 22:32, Malcolm Priestley wrote:
> > On Tue, 2014-02-11 at 19:42 +0200, Antti Palosaari wrote:
> >> Moikka Malcolm!
> >> Thanks for the patch serie.
> >>
> >> You removed all IDs from it913x driver. There is possibility to just
> >> remove / comment out:
> >> 	MODULE_DEVICE_TABLE(usb, it913x_id_table);
> >> which prevents loading that driver automatically, but leaves possibility
> >> to load it manually if user wants to fallback. I am fine either way you
> >> decide to do it, just a propose.
> > Hi Antti
> >
> > I am going post a patches to remove it.
> >
> > The only reason why an user would want to fall back is
> > the use dvb-usb-it9137-01.fw firmware with USB_VID_KWORLD_2.
> >
> > I left the USB_VID_KWORLD_2 ids in the driver.
> >
> > I haven't found any issues with dvb-usb-it9135-01.fw
> >
> > USB_VID_KWORLD_2 users could have trouble updating older kernels via
> > media_build.
> >
> > Perhaps there should be a warning message in af9035 that users need to
> > change firmware.
> 
> Is that KẂorld device dual model (I guess yes, because of it9137)? Is it 
> version 1 (AX) or version 2 (BX) chip?

Both apparently exist, but the firmware is the same.

The main difference registers in the firmwares
dvb-usb-it9137-01.fw -->clk enable 0xd81a --> tuner_it91x_priv.h...set_it9137_template
dvb-usb-it9135-01.fw -->clk enable 0xcfff --> tuner_it91x_priv.h...set_it9135_template
dvb-usb-it9135-02.fw -->clk enable 0xcfff --> tuner_it91x_priv.h...set_it9135_template

As far as It can tell all the latest firmwares are based on
set_it9135_template.

On the KWorld the second device is another it9137 and has an eeprom
24c02 fitted.

So dropping the dvb-usb-it9137-01.fw firmware is fine.

Regards


Malcolm

