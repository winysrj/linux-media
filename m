Return-path: <linux-media-owner@vger.kernel.org>
Received: from WARSL404PIP2.highway.telekom.at ([195.3.96.113]:2517 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756414AbZCGWTP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2009 17:19:15 -0500
Message-ID: <49B2F2E1.3090206@yahoo.de>
Date: Sat, 07 Mar 2009 23:19:13 +0100
From: Elmar Stellnberger <estellnb@yahoo.de>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Technisat Skystar 2 on Suse Linux 11.1, kernel 2.6.27.19-3.2-default
References: <49B2BAAE.8040808@yahoo.de> <alpine.LRH.1.10.0903071945470.27410@pub5.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0903071945470.27410@pub5.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> dvbscan -adapter 0 -frontend 0 -demux 0 /usr/share/dvb/dvb-s/Astra-19.2E
Failed to set frontend


downloading channel.conf from Astra1
has not brought me force.

> szap 3sat
reading channels from file '/home/elm/.szap/channels.conf'
zapping to 20 '3sat':
sat 0, frequency = 11954 MHz V, symbolrate 27500000, vpid = 0x00d2, apid
= 0x00dc sid = 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 6b2b | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 7f02 | ber 00007e00 | unc fffffffe |
status 01 | signal aa7e | snr 3d47 | ber 0000ffe8 | unc fffffffe |
status 00 | signal 0000 | snr 7fc5 | ber 0000fff0 | unc fffffffe |
status 00 | signal 0000 | snr 2232 | ber 00006ef0 | unc fffffffe |
status 00 | signal 0000 | snr 1fdd | ber 00000058 | unc fffffffe |
status 00 | signal 0000 | snr 19b3 | ber 00000000 | unc fffffffe |
status 02 | signal 0000 | snr 192f | ber 00000000 | unc fffffffe |
status 00 | signal 0035 | snr 8469 | ber 00000000 | unc fffffffe |
... etc.

what should that output mean?
why does szap not terminate?


Patrick Boettcher schrieb:
> Hi Elmar,
> 
> On Sat, 7 Mar 2009, Elmar Stellnberger wrote:
> 
>> Following the instructions at
>> http://www.linuxtv.org/wiki/index.php/TechniSat_SkyStar_2_TV_PCI_/_Sky2PC_PCI
>>
>> I have tried to make my Technisat Skystar 2 work.
> 
> This howto seems to be out of date. The skystar2.ko was removed like 4
> years ago. It was replaced by the b2c2-flexcop-drivers.
> 
> 
>> The thing is that suse ships most of the required kernel modules out of
>> the box; iter sunt
>> stv0299
>> mt312
>> budget
>> Only skystar2 is missing, so that I have no /dev/video0 and no
>> /dev/dvb/adapter0/video0 as required by all these dvb players.
>>>> ls /dev/dvb/adapter0/
>> demux0  dvr0  frontend0  net0
> 
> Furthermore this is totally correct. /dev/video0 is provided by
> analog-video-cards or by full-featured (with a overlay-chip on board)
> devices.
> 
> The SkyStar2 is neither of it.
> 
> Did you try to use Kaffeine or mplayer or (dvb)scan?
> 
> regards,
> Patrick.
> 
> -- 
>   Mail: patrick.boettcher@desy.de
>   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
> 

