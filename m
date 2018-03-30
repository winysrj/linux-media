Return-path: <linux-media-owner@vger.kernel.org>
Received: from mklab.ph.rhbnc.ac.uk ([134.219.128.55]:33026 "EHLO
        mklab.ph.rhul.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752735AbeC3DqR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 23:46:17 -0400
Date: Fri, 30 Mar 2018 04:31:29 +0100 (BST)
From: TPClmml@mklab.ph.rhul.ac.uk
To: linux-media@vger.kernel.org
cc: TPClmml@mklab.ph.rhul.ac.uk
Subject: DVB-T2 support for TVR801 USB stick (Astrometa DVB-T2)
Message-ID: <alpine.LNX.2.21.1803300427130.3376@mklab.ph.rhul.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Could anyone clarify what is supported on this stick for me?  According to 
https://www.linuxtv.org/wiki/index.php/Astrometa_DVB-T2 DVB-T2 has been 
supported since kernel 4.6.  I tried using a 4.9.9 kernel about a year ago 
and again today using 4.14.30, in both cases with the development tree 
code from git://linuxtv.org/media_build.git.

In both cases I don't get a second adapter exposed for the MN88473 demuxer 
just the /dev/dvb/adapter0 tree for the RTL2832 which only supports DVB-T. 
Here http://www.mklab.rhul.ac.uk/~tom/TVR801-dmesg.txt is the full dmesg 
O/P it got using kernel 4.14.30.


A year ago, for fun, I tried hacking the code a little, without really 
knowing what I was doing but managed to get the following from dmesg,

> dvbdev: DVB: registering new adapter (Astrometa DVB-T2)
> usb 1-8: media controller created
> dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
> i2c i2c-13: Added multiplexed i2c bus 14
> rtl2832 13-0010: Realtek RTL2832 successfully attached
> mn88473 13-0018: Panasonic MN88473 successfully identified
> usb 1-8: DVB: registering adapter 0 frontend 0 (Realtek RTL2832 (DVB-T))...
> dvbdev: dvb_create_media_entity: media entity 'Realtek RTL2832 (DVB-T)' registered.
> usb 1-8: DVB: registering adapter 0 frontend 1 (Panasonic MN88473)...
> dvbdev: dvb_create_media_entity: media entity 'Panasonic MN88473' registered.

The MN88473 interface I got was recognised by w_scan but was not usable. 
It complained the frequency limits were missing.  Here is an example,

> w_scan -X -a /dev/dvb/adapter0/frontend1
> w_scan version 20161022 (compiled for DVB API 5.10)
> WARNING: could not guess your country. Falling back to 'DE'
> guessing country 'DE', use -c <country> to override
> using settings for GERMANY
> DVB aerial
> DVB-T Europe
> scan type TERRESTRIAL, channellist 4
> output format czap/tzap/szap/xine
> WARNING: could not guess your codepage. Falling back to 'UTF-8'
> output charset 'UTF-8', use -C <charset> to override
> -_-_-_-_ Getting frontend capabilities-_-_-_-_
> Using DVB API 5.10
> frontend 'Panasonic MN88473' supports
> DVB-T2
> INVERSION_AUTO
> QAM_AUTO
> TRANSMISSION_MODE_AUTO
> GUARD_INTERVAL_AUTO
> HIERARCHY_AUTO
> FEC_AUTO
> BANDWIDTH_AUTO not supported, trying 6/7/8 MHz.
> This dvb driver is *buggy*: the frequency limits are undefined - please 
> report to linuxtv.org
> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
> Scanning DVB-T...
> Scanning 8MHz frequencies...
> 474000: (time: 00:00.633)
> 482000: (time: 00:02.641)
> 490000: (time: 00:04.650)
> 498000: (time: 00:06.661)
> [cut]
> 842000: (time: 01:32.955)
> 850000: (time: 01:34.960)
> 858000: (time: 01:36.969)
> Scanning DVB-T2...
> 474000: (time: 01:38.978)
> 482000: (time: 01:40.989)
> 490000: (time: 01:43.000)
> 498000: (time: 01:45.010)
> [cut]
> 850000: (time: 03:13.285)
> 858000: (time: 03:15.291)
>
> ERROR: Sorry - i couldn't get any working frequency/transponder
>  Nothing to scan!!


After that I gave up.  Any thoughts?

Many thanks
Tom Crane

-- 
Tom Crane, Dept. Physics, Royal Holloway, University of London, Egham Hill,
Egham, Surrey, TW20 0EX, England.
Email:  T.Crane@rhul.ac.uk
