Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56881 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZISMbv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2009 08:31:51 -0400
Date: Sat, 19 Sep 2009 09:31:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Edward Sheldrake <ejs1920@yahoo.co.uk>, linux-media@vger.kernel.org
Subject: Re: Leadtek/Terratec usb id mixup in hg 12889
Message-ID: <20090919093113.2d0ace66@pedra.chehab.org>
In-Reply-To: <alpine.LRH.1.10.0909191249110.9214@pub5.ifh.de>
References: <195772.10046.qm@web28511.mail.ukl.yahoo.com>
	<alpine.LRH.1.10.0909191249110.9214@pub5.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 19 Sep 2009 12:49:39 +0200 (CEST)
Patrick Boettcher <pboettcher@kernellabs.com> escreveu:

> On Fri, 18 Sep 2009, Edward Sheldrake wrote:
> 
> > With latest hg (12994), my "Leadtek Winfast DTV Dongle (STK7700P based)" (0413:6f01) gets detected as a "Terratec Cinergy T USB XXS (HD)".
> >
> > I think "&dib0700_usb_id_table[34]" (the leadtek) got moved by mistake, but "&dib0700_usb_id_table[33]" (a terratec) should have been moved instead (in changeset 12889).
> >
> > hg 12889: http://linuxtv.org/hg/v4l-dvb/rev/cec94ceb4f54
> 
> Argl!
> 
> Very well spotted.
> 
> Can you please check if this patch fixes it correctly?
> 
> http://www.kernellabs.com/hg/~pboettcher/v4l-dvb/

Having those magic numbers is not nice, since, when conflicts arrive, we may do
bad things. I think we should really consider a better way to associate both tables.

if we use the way several V4L drivers do, a code like this would look like:


#define LEADTEK_WINFAST_STK7700P	34
...
	[LEADTEK_WINFAST_STK7700P] = { USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_STK7700P_2) },
...

	{   "Leadtek Winfast DTV Dongle (STK7700P based)",
		{ &dib0700_usb_id_table[8], &dib0700_usb_id_table[LEADTEK_WINFAST_STK7700P] },
		{ NULL },
	},
...

The above code won't generate any extra code. The only drawback is the need of typing more.

Cheers,
Mauro
