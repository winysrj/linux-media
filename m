Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:53905 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbbHWRux (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 13:50:53 -0400
Message-ID: <1440352250.13381.3.camel@xs4all.nl>
Subject: Re: DVBSky T980C CI issues (kernel 4.0.x)
From: Jurgen Kramer <gtmkramer@xs4all.nl>
To: linux-media@vger.kernel.org
Date: Sun, 23 Aug 2015 19:50:50 +0200
In-Reply-To: <1436697509.2446.14.camel@xs4all.nl>
References: <1436697509.2446.14.camel@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Sun, 2015-07-12 at 12:38 +0200, Jurgen Kramer wrote:
> I have been running a couple of DVBSky T980C's with CIs with success
> using an older kernel (3.17.8) with media-build and some added patches
> from the mailing list.
> 
> I thought lets try a current 4.0 kernel to see if I no longer need to be
> running a custom kernel. Everything works just fine except the CAM
> module. I am seeing these:
> 
> [  456.574969] dvb_ca adapter 0: Invalid PC card inserted :(
> [  456.626943] dvb_ca adapter 1: Invalid PC card inserted :(
> [  456.666932] dvb_ca adapter 2: Invalid PC card inserted :(
> 
> The normal 'CAM detected and initialised' messages to do show up with
> 4.0.8
> 
> I am not sure what changed in the recent kernels, what is needed to
> debug this?
> 
> Jurgen
Retest. I've isolated one T980C on another PC with kernel 4.1.5, still the same 'Invalid PC card inserted :(' message.
Even after installed today's media_build from git no improvement.

Any hints where to start looking would be appreciated!

cimax2.c|h do not seem to have changed. There are changes to
dvb_ca_en50221.c

Jurgen


> Relevant kernel messages:
> 
> [   14.899827] cx25840 9-0044: loaded v4l-cx23885-avcore-01.fw firmware
> (16382 bytes)
> [   14.915384] cx23885_dvb_register() allocating 1 frontend(s)
> [   14.915386] cx23885[0]: cx23885 based dvb card
> [   15.326745] i2c i2c-8: Added multiplexed i2c bus 10
> [   15.326747] si2168 8-0064: Silicon Labs Si2168 successfully attached
> [   15.390538] si2157 10-0060: Silicon Labs Si2147/2148/2157/2158
> successfully attached
> [   15.390542] DVB: registering new adapter (cx23885[0])
> [   15.390544] cx23885 0000:02:00.0: DVB: registering adapter 0 frontend
> 0 (Silicon Labs Si2168)...
> [   15.758330] sp2 8-0040: CIMaX SP2 successfully attached
> [   15.785785] DVBSky T980C MAC address: 00:17:42:54:09:88
> [   15.785789] cx23885_dev_checkrevision() Hardware revision = 0xa5
> [   15.785792] cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 16,
> latency: 0, mmio: 0xf7c00000
> [   15.785883] CORE cx23885[1]: subsystem: 4254:980c, board: DVBSky
> T980C [card=46,autodetected]
> [   15.996981] EXT4-fs (sda2): mounted filesystem with ordered data
> mode. Opts: (null)
> [   16.015395] cx25840 13-0044: cx23885 A/V decoder found @ 0x88
> (cx23885[1])
> [   16.642705] cx25840 13-0044: loaded v4l-cx23885-avcore-01.fw firmware
> (16382 bytes)
> [   16.658240] cx23885_dvb_register() allocating 1 frontend(s)
> [   16.658242] cx23885[1]: cx23885 based dvb card
> [   16.659004] i2c i2c-12: Added multiplexed i2c bus 14
> [   16.659006] si2168 12-0064: Silicon Labs Si2168 successfully attached
> [   16.660689] si2157 14-0060: Silicon Labs Si2147/2148/2157/2158
> successfully attached
> [   16.660692] DVB: registering new adapter (cx23885[1])
> [   16.660693] cx23885 0000:03:00.0: DVB: registering adapter 1 frontend
> 0 (Silicon Labs Si2168)...
> [   16.667337] sp2 12-0040: CIMaX SP2 successfully attached
> [   16.694845] DVBSky T980C MAC address: 00:17:42:54:09:88
> [   16.694848] cx23885_dev_checkrevision() Hardware revision = 0xa5
> [   16.694852] cx23885[1]/0: found at 0000:03:00.0, rev: 4, irq: 17,
> latency: 0, mmio: 0xf7a00000
> [   16.694986] CORE cx23885[2]: subsystem: 4254:980c, board: DVBSky
> T980C [card=46,autodetected]
> [   16.924320] cx25840 17-0044: cx23885 A/V decoder found @ 0x88
> (cx23885[2])
> [   17.551377] cx25840 17-0044: loaded v4l-cx23885-avcore-01.fw firmware
> (16382 bytes)
> [   17.566994] cx23885_dvb_register() allocating 1 frontend(s)
> [   17.566996] cx23885[2]: cx23885 based dvb card
> [   17.567898] i2c i2c-16: Added multiplexed i2c bus 18
> [   17.567900] si2168 16-0064: Silicon Labs Si2168 successfully attached
> [   17.569710] si2157 18-0060: Silicon Labs Si2147/2148/2157/2158
> successfully attached
> [   17.569714] DVB: registering new adapter (cx23885[2])
> [   17.569715] cx23885 0000:05:00.0: DVB: registering adapter 2 frontend
> 0 (Silicon Labs Si2168)...
> [   17.576684] sp2 16-0040: CIMaX SP2 successfully attached
> [   17.604168] DVBSky T980C MAC address: 00:17:42:54:09:88
> [   17.604171] cx23885_dev_checkrevision() Hardware revision = 0xa5
> [   17.604174] cx23885[2]/0: found at 0000:05:00.0, rev: 4, irq: 19,
> latency: 0, mmio: 0xf7800000
> 
> [  220.616002] si2168 8-0064: found a 'Silicon Labs Si2168-A30'
> [  220.635026] si2168 8-0064: downloading firmware from file
> 'dvb-demod-si2168-a30-01.fw'
> [  223.744845] si2168 8-0064: firmware version: 3.0.16
> [  223.753441] si2157 10-0060: found a 'Silicon Labs Si2158-A20'
> [  223.777443] si2157 10-0060: downloading firmware from file
> 'dvb-tuner-si2158-a20-01.fw'
> [  224.577779] si2157 10-0060: firmware version: 2.1.6
> [  224.683600] si2168 12-0064: found a 'Silicon Labs Si2168-A30'
> [  224.683633] si2168 12-0064: downloading firmware from file
> 'dvb-demod-si2168-a30-01.fw'
> [  227.797635] si2168 12-0064: firmware version: 3.0.16
> [  227.806235] si2157 14-0060: found a 'Silicon Labs Si2158-A20'
> [  227.806249] si2157 14-0060: downloading firmware from file
> 'dvb-tuner-si2158-a20-01.fw'
> [  228.606280] si2157 14-0060: firmware version: 2.1.6
> [  228.644496] si2168 16-0064: found a 'Silicon Labs Si2168-A30'
> [  228.644521] si2168 16-0064: downloading firmware from file
> 'dvb-demod-si2168-a30-01.fw'
> [  231.763081] si2168 16-0064: firmware version: 3.0.16
> [  231.771685] si2157 18-0060: found a 'Silicon Labs Si2158-A20'
> [  231.771711] si2157 18-0060: downloading firmware from file
> 'dvb-tuner-si2158-a20-01.fw'
> [  232.571684] si2157 18-0060: firmware version: 2.1.6
> [  456.574969] dvb_ca adapter 0: Invalid PC card inserted :(
> [  456.626943] dvb_ca adapter 1: Invalid PC card inserted :(
> [  456.666932] dvb_ca adapter 2: Invalid PC card inserted :(
> [  481.638979] dvb_ca adapter 0: Invalid PC card inserted :(
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


