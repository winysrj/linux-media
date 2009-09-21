Return-path: <linux-media-owner@vger.kernel.org>
Received: from m2.goneo.de ([82.100.220.83]:58327 "EHLO m2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834AbZIUNzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 09:55:08 -0400
From: Roman <lists@hasnoname.de>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: MSI Digivox mini III Remote Control
Date: Mon, 21 Sep 2009 15:55:11 +0200
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <200909202026.27086.lists@hasnoname.de> <20090921115122.GA2269@moon> <4AB77329.5000405@iki.fi>
In-Reply-To: <4AB77329.5000405@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909211555.11747.lists@hasnoname.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Monday 21 September 2009 14:35:53 schrieb Antti Palosaari:
> On 09/21/2009 02:51 PM, Aleksandr V. Piskunov wrote:
> > Just grab that patch and apply it to the current vl4-dvb, no need to mess
> > with old repository.
> > http://linuxtv.org/hg/~anttip/af9015-digivox3_remote/raw-rev/914ded6d921d
>
> With this patch remote will not work most likely. But after adding that
> patch you should see remote events dumped to the /var/log/messages when
> key is pressed. I need to know which key gives which code. After that I
> can add correct key mappings to the driver.
>
> Antti

I don't get anything else in the logs than this, even with the patch applied:
#---
Sep 21 15:43:04 Seth usbcore: registered new interface driver dvb_usb_af9015
Sep 21 15:43:07 Seth usb 1-5: new high speed USB device using ehci_hcd and 
address 4
Sep 21 15:43:08 Seth usb 1-5: configuration #1 chosen from 1 choice
Sep 21 15:43:08 Seth dvb-usb: found a 'MSI Digi VOX mini III' in cold state, 
will try to load a firmware
Sep 21 15:43:08 Seth usb 1-5: firmware: requesting dvb-usb-af9015.fw
Sep 21 15:43:08 Seth dvb-usb: downloading firmware from 
file 'dvb-usb-af9015.fw'
Sep 21 15:43:08 Seth dvb-usb: found a 'MSI Digi VOX mini III' in warm state.
Sep 21 15:43:08 Seth dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
Sep 21 15:43:08 Seth DVB: registering new adapter (MSI Digi VOX mini III)
Sep 21 15:43:08 Seth af9013: firmware version:4.95.0
Sep 21 15:43:08 Seth DVB: registering adapter 0 frontend 0 (Afatech AF9013 
DVB-T)...
Sep 21 15:43:08 Seth tda18271 3-00c0: creating new instance
Sep 21 15:43:08 Seth TDA18271HD/C1 detected @ 3-00c0
Sep 21 15:43:08 Seth dvb-usb: MSI Digi VOX mini III successfully initialized 
and connected.
Sep 21 15:43:51 Seth [drm] LVDS-8: set mode 1024x768 10
#---



Gruﬂ,
Roman

-- 
When I was in school, I cheated on my metaphysics exam: I looked into
the soul of the boy sitting next to me.
		-- Woody Allen
