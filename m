Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56878 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760555AbZCaTcN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 15:32:13 -0400
Message-ID: <49D26FB2.3030207@iki.fi>
Date: Tue, 31 Mar 2009 22:32:02 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas RENARD <threnard@gmail.com>
CC: Olivier MENUEL <omenuel@laposte.net>, linux-media@vger.kernel.org
Subject: Re: AverMedia Volar Black HD (A850)
References: <200903291334.00879.olivier.menuel@free.fr>	 <49D1287C.5010803@iki.fi> <49D13272.7050906@laposte.net>	 <200903310048.19629.omenuel@laposte.net> <49D150C6.5060207@iki.fi> <7a3c9e3d0903310004y31635654l6ab3884560118efc@mail.gmail.com> <49D1D0C6.9040400@iki.fi> <49D26CC5.10801@laposte.net>
In-Reply-To: <49D26CC5.10801@laposte.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thomas RENARD wrote:
> I have tested http://linuxtv.org/hg/~anttip/af9015_aver_a850_2.
> *It works for me !*
> 
> Here is info for Kernel changelog :
> *Tested-by: Thomas Renard <threnard@gmail.com> *

Thank you and Olivier for testing!

> I just have this error message during scan but I don't know the severity :
> scan -n -o zap -p /usr/share/doc/dvb-utils/examples/scan/dvb-t/fr-Paris 
>  > channels.conf
> scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/fr-Paris
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 474000000 0 2 9 3 1 0 0
> initial transponder 498000000 0 2 9 3 1 0 0
> initial transponder 522000000 0 2 9 3 1 0 0
> initial transponder 562000000 0 2 9 3 1 0 0
> initial transponder 586000000 0 3 9 3 1 2 0
>  >>> tune to: 
> 474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE 
> 
> 0x0000 0x0201: pmt_pid 0x0500 NTN -- Direct 8 (running)
> 0x0000 0x0203: pmt_pid 0x0502 NTN -- BFM TV (running)
> ...
> 0x0000 0x0176: pmt_pid 0x02c6 GR1 -- France � (running)
> WARNING: filter timeout pid 0x0010
>  >>> tune to: 
> -10:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE 
> 
> *__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 
> 22 Invalid argument*
>  >>> tune to: 
> -10:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE 
> 
> *__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 
> 22 Invalid argument*
> dumping lists (36 services)
> Done.

Something strange happens that I don't see clearly. Does this happens 
every time you scan?
Filter timeout typically means that signal is a just little bit weak. 
But in that case it typically does not reproduce exactly similarly (pid 
could be different etc.) when scan is done again.

regards
Antti
-- 
http://palosaari.fi/
