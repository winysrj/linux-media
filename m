Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5.freeserve.com ([193.252.22.152]:42012 "EHLO
	smtp5.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbZHOTyc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Aug 2009 15:54:32 -0400
From: "Chris Thornley" <C.J.Thornley@coolrose.fsnet.co.uk>
To: "'Bert Haverkamp'" <bert@bertenselena.net>,
	<linux-media@vger.kernel.org>
References: <1e68a10b0908150515l217126f7j41e15ece329176e1@mail.gmail.com>
In-Reply-To: <1e68a10b0908150515l217126f7j41e15ece329176e1@mail.gmail.com>
Subject: RE: usb dvb-c tuner status
Date: Sat, 15 Aug 2009 20:54:09 +0100
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAMs7WpTkg9MRuRcAACHFyB/CgAAAEAAAANXp0ecuh21Mk1Tbx4snkHQBAAAAAA==@coolrose.fsnet.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I am also very interested in any development with the TT-connectR CT-3650 CI
DVB-C and DVB-T tuners as well.

I have not had a chance to test the DVB-C side of things but DVB-T tuning
currently does not work.

It was mentioned somewhere you might have to load a firmware file. Not sure
how you do this.

There appears to be new firmware available for the tda10048 within the new
technotrend BDA Driver.

Go to the only working technotrend driver page
http://www.tt-pc.de/2899/PC-Produkte.html (Only available in German)

Find and download "TT-BDA-Data Version 1.4.4.2 (16.01.09)"
http://www.tt-download.com/download/updates/bda/TT-BDA-Data%20-%201.4.4.2_WE
B_2009-01-16.zip

Extract the archive and find the ttusb2bda.sys file

Run this : dd if=ttusb2bda.sys of=dvb-fe-tda10048-5.0.1.7fw bs=1 skip=522376
count=25042

This should extract the current firmware from the file.

The previously mentioned ttusb2bda_1.0.2.20 file is not available any more.

After that I am not sure what you have to do with this file to get DVB-T
tuning to work.

Also might be of interest for "TT-connectR S2-3650" and "TT-connectR
S2-3600" is a firmware update for the card that "Improving the quality of
reception at high data rates on DVB-S2 transponders"

Chris


               />      Christopher J. Thornley is cjt@coolrose.fsnet.co.uk
  (           //------------------------------------------------------,
 (*)OXOXOXOXO(*>=*=O=S=U=0=3=6=*=---------                             >
  (           \\------------------------------------------------------'
               \>       Home Page :-http://www.coolrose.fsnet.co.uk
 
-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Bert Haverkamp
Sent: 15 August 2009 13:16
To: linux-media@vger.kernel.org
Subject: usb dvb-c tuner status


Dear all,

I've been looking through this mailinglist searching for a supported dvb-c
usb tuner.
But all I can find is partial/almost/retracted support for some devices.
Nothing seems to be without it's problem I would like to have your feedback
on the status of usb dvb-c tuners.

Sofar I found:
- Technotrend CT-3650 for which there is one report that dvb-c works with a
patch,(is this already in-tree?), but dvb-t and CI not
- Sundtek MediaTV Pro for which a closed source driver exists. I don't want
to go that way.
- Terratec Cinergy Hybrid H5  which seems to be troubled with a driver for a
chip that isn't "blessed" by the manufacturer.

Am I missing something? Is there a trouble-free solution for me?

Regards and thanks for all the development on linux-media support

Bert Haverkamp

--
-----------------------------------------------------
38 is NOT a random number!!!!
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html



