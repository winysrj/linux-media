Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JT4sd-0007EU-5k
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 01:38:11 +0100
Message-ID: <47C0BC6D.2060606@gmail.com>
Date: Sun, 24 Feb 2008 04:38:05 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Tim Hewett <tghewett1@onetel.com>
References: <65A7136B-8AAD-44EE-921E-5376D7BAC14E@onetel.com>
	<47C09CB5.8060804@gmail.com>
	<FE251317-5C82-44A7-B2F3-7F0254A787E6@onetel.com>
	<47C0AF98.5000703@gmail.com>
	<342209CC-E522-49BC-A3D6-7A9A7CE23740@onetel.com>
In-Reply-To: <342209CC-E522-49BC-A3D6-7A9A7CE23740@onetel.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help with Skystar HD2 (Twinhan VP-1041/Azurewave
 AD	SP400 rebadge)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Tim Hewett wrote:
> Manu,
> 
> Thanks, it now tunes to horizontal transponders though not vertical 
> ones. I think others have been having similar symptoms with the 
> mantis/multiproto trees.

Can someone replicate this behaviour: not tuning to vertical transponders ?
Do you have any switches or a rotor in the SEC chain ?

> It won't tune to any DVB-S2 transponder, but that has not changed since 
> previously.


Hmm .. Are you really sure ?


> Messages in dmesg for successful tuning:
> 
> [  402.455361] dvb_frontend_ioctl: DVBFE_GET_INFO
> [  402.455366] stb0899_get_info: Querying DVB-S info
> [  402.556373] newfec_to_oldfec: Unsupported FEC 9
> [  402.556377] dvb_frontend_ioctl: FESTATE_RETUNE: fepriv->state=2
> [  402.556998] mantis start feed & dma
> [  402.557255] stb0899_search: set DVB-S params
> [  402.567810] stb6100_set_bandwidth: Bandwidth=51610000
> [  402.569927] stb6100_get_bandwidth: Bandwidth=52000000
> [  402.581331] stb6100_get_bandwidth: Bandwidth=52000000
> [  402.613394] stb6100_set_frequency: Frequency=1023000
> [  402.615510] stb6100_get_frequency: Frequency=1022994
> [  402.621496] stb6100_get_bandwidth: Bandwidth=52000000
> [  404.541047] _stb0899_read_reg: Read error, Reg=[0xf525], Status=-121
> [  404.541749] mantis stop feed and dma

I will need the stb0899 and stb6100 modules to be loaded with verbose=5
parameter, for understanding what's happening.


Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
