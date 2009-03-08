Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:41903 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbZCHHlm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2009 03:41:42 -0400
Date: Sun, 8 Mar 2009 08:41:30 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Elmar Stellnberger <estellnb@yahoo.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Technisat Skystar 2 on Suse Linux 11.1, kernel
 2.6.27.19-3.2-default
In-Reply-To: <49B2F2E1.3090206@yahoo.de>
Message-ID: <alpine.LRH.1.10.0903080837330.27410@pub5.ifh.de>
References: <49B2BAAE.8040808@yahoo.de> <alpine.LRH.1.10.0903071945470.27410@pub5.ifh.de> <49B2F2E1.3090206@yahoo.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Elmar,

On Sat, 7 Mar 2009, Elmar Stellnberger wrote:

>> dvbscan -adapter 0 -frontend 0 -demux 0 /usr/share/dvb/dvb-s/Astra-19.2E
> Failed to set frontend

I have the same problem with that scan, please use the older one called 
scan.

Are you running the szap below as root, but kaffeine as a normal user ?

If so, make sure that you are in the group video.

> downloading channel.conf from Astra1
> has not brought me force.
>
>> szap 3sat
> reading channels from file '/home/elm/.szap/channels.conf'
> zapping to 20 '3sat':
> sat 0, frequency = 11954 MHz V, symbolrate 27500000, vpid = 0x00d2, apid
> = 0x00dc sid = 0x0000
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 00 | signal 0000 | snr 6b2b | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 7f02 | ber 00007e00 | unc fffffffe |
> status 01 | signal aa7e | snr 3d47 | ber 0000ffe8 | unc fffffffe |
> status 00 | signal 0000 | snr 7fc5 | ber 0000fff0 | unc fffffffe |
> status 00 | signal 0000 | snr 2232 | ber 00006ef0 | unc fffffffe |
> status 00 | signal 0000 | snr 1fdd | ber 00000058 | unc fffffffe |
> status 00 | signal 0000 | snr 19b3 | ber 00000000 | unc fffffffe |
> status 02 | signal 0000 | snr 192f | ber 00000000 | unc fffffffe |
> status 00 | signal 0035 | snr 8469 | ber 00000000 | unc fffffffe |

This is the first proof that your device is present and the driver is 
correctly loaded. Please check the output of the dmesg-program to check 
for lines starting with b2c2-flexcop.

> what should that output mean?

it means, it can't synchronize the channel on that frequency. This can 
have a whole bunch of explaination - not necessarily only the driver.

> why does szap not terminate?

It stays in the monitoring loop. Normal.

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
