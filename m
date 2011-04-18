Return-path: <mchehab@pedra>
Received: from ns2011.yellis.net ([79.170.233.11]:37598 "EHLO
	vds2011.yellis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab1DRNbH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 09:31:07 -0400
Message-ID: <4DAC3D16.1060900@anevia.com>
Date: Mon, 18 Apr 2011 15:31:02 +0200
From: Florent Audebert <florent.audebert@anevia.com>
MIME-Version: 1.0
To: Lutz Sammer <johns98@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: stb0899 signal strength value in dvb-s2l
References: <4DA9E8DC.5040107@gmx.net>
In-Reply-To: <4DA9E8DC.5040107@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 04/16/2011 09:07 PM, Lutz Sammer wrote:
>> Using a KNC-1 DVB-S2 board I noticed stb0899_read_signal_strength() 
>> in stb0899_drv.c always return the same value (1450) in dvb-s2 whatever
>> the signal power is.
>>
>> It seems STB0899_READ_S2REG(STB0899_DEMOD, IF_AGC_GAIN) macro always
>> returns zero.
>>
>> Any idea of what is causing this ?
> 
> Try
> 
> -                       reg = STB0899_READ_S2REG(STB0899_DEMOD,
> IF_AGC_GAIN);
> +                       reg = STB0899_READ_S2REG(STB0899_S2DEMOD,
> IF_AGC_GAIN);
> 
> Than it is working,

Indeed it works. We should commit that.

Thanks for helping !

-- 
Florent AUDEBERT
