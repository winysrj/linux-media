Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:53356 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab0GENPI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 09:15:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OVlVo-0004uO-93
	for linux-media@vger.kernel.org; Mon, 05 Jul 2010 15:15:04 +0200
Received: from 5e07cbfa.bb.sky.com ([94.7.203.250])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 05 Jul 2010 15:15:04 +0200
Received: from jdg8tb by 5e07cbfa.bb.sky.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 05 Jul 2010 15:15:04 +0200
To: linux-media@vger.kernel.org
From: JD <jdg8tb@gmail.com>
Subject: Re: Fwd: Firmware for HVR-1110
Date: Mon, 5 Jul 2010 13:10:13 +0000 (UTC)
Message-ID: <loom.20100705T145800-336@post.gmane.org>
References: <AANLkTimQqT99icH6wGhyizm-Zymg_wNrLhxS4yqGo1Wu@mail.gmail.com>  <AANLkTilBXOV-7d4mOtbwfZdiAy9qiWZiVB-aHR7x0OPm@mail.gmail.com> <1278213195.3229.11.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hermann pitton <hermann-pitton <at> arcor.de> writes:

> 
> Hi JD,http://pastebin.ca/1894929
> 
> Am Samstag, den 03.07.2010, 03:32 +0100 schrieb JD:
> > I'm confused as to what firmware in needed for the HVR-1110.
> > 
> > Scouring the web, everywhere claims that the dvb-fe-tda10046 is
> > required; however, dmesg logs show that this fails to be uploaded, and
> > instead it is looking for dvb-fe-tda-10048:
> > 
> > If I use tda-10048 then this seems to successfully loaded, but I am
> > unable to find any channels with a scan;  the dvb nodes within /dev/
> > are created and modules loaded, but dvbscan fails to tune.
> > 
> > ------
> > dmesg
> > --------
> > $ dmesg |grep firmware
> > tda10048_firmware_upload: waiting for firmware upload
> > (dvb-fe-tda10048-1.0.fw)...
> > saa7134 0000:03:04.0: firmware: requesting dvb-fe-tda10048-1.0.fw
> > tda10048_firmware_upload: firmware read 24878 bytes.
> > tda10048_firmware_upload: firmware uploading
> > tda10048_firmware_upload: firmware uploaded
> > 
> > Any tips?
> > Thanks.
> > --
> 
> all variants of the HVR-1110 have a tda 10046.
> 
> I can't see, how firmware loading can fail on auto detection of those
> and even switch over to tda10048 as an alternative.
> 
> Do you force some card = number and are maybe on a not yet detected
> HVR-1120?
> 
> Please provide the full dmesg log related to your card and make sure you
> are on Michael Krufky's latest patches.
> 
> Cheers,
> Hermann
> 
> 


Hi, thanks for the reply.

To be sure that I hadn't set a certain card type somewhere, I used a
clean install of a different OS (Linux Mint on a live USB); however,
dmesg still shows that for some reason it is looking for the tda-10048
firmware.

Here's the dmesg output: http://pastebin.ca/1894693

Here's the dmesg out after installing the tda10048 firmware if it is any help:
http://pastebin.ca/1894929

I am able to find two or three analogue channels with tvtime, but no digital
channels at all:
dvbscan always says "tuning failed", and using vlc to search for dvb-t channels
results in none.

I do not have the patches you mention, as I am quite new to tv for
linux, but I'll take a look shortly.

My card is definitely the WinTV-HVR1110 as it states it on the card
itself, but the packaging states HVR-1110.



