Return-path: <linux-media-owner@vger.kernel.org>
Received: from node02.cambriumhosting.nl ([217.19.16.163]:56380 "EHLO
	node02.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbZFBIHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2009 04:07:46 -0400
Message-ID: <4A24DDCC.3090700@powercraft.nl>
Date: Tue, 02 Jun 2009 10:07:40 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: wk <handygewinnspiel@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: w_scan 20090502, why is the new country code necessary, its breaking
 my systems
References: <4A23C321.6010608@gmx.de>
In-Reply-To: <4A23C321.6010608@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

wk wrote:
> Hello Jelle,
> 
>  > My w_scan version 20081106 stopped working on my Debian system. I had
>  > the following errors:
>  > ERROR: Sorry - i couldn't get any working frequency/transponder
>  >
>  > So I first checked if there was a wscan update.
> 
> No reception for some reason - probably the new version will show the 
> same result.

I am know using w_scan version 20090528 and this version works partly
and does also not loop. The error still sometimes happens, something
changed in the device modules... The device is not always stable, i have
to repluging the device and then the scanning works again. Sorry for the
lack of further info, no messages in dmesg...

> 
>  > I had to make a new argument line:
>  > ~/.wscan/wscan -t 3 -A 1 -E 0 -O 0 -c NL -X tzap > 
> ~/.wscan/channels.conf
> 
> "-A 1" is wrong for you, please omitt this one, it's used outside Europe 
> only.
> "-O 0" is default anyway, not needed
> 

I am know using the bellow command, i use some default values, since I
am afraid these option can change in the future and break my system.
~/.wscan/wscan -f 1 -c NL -X tzap -R 1 -T 1 -E 0 -O 0 -t 3 >
~/.wscan/channels.conf

>  > This is very troubling for me because I must have a scan command that
>  > works in complete Europa and not in one country. This is because I have
>  > traveling systems that need to scan for channels on every stop.
>  >
>  > Why :-( please explain and try to fix this regression that a country
>  > code is needed?
> 
> w_scan tends to be used now to be used also in other countries - with 
> different settings
> - frequency lists
> - frequency offsets from center frequency
> - Symbolrates
> - channel bandwidths
> - Modulations ( QAM_128 for example in FI, QAM_64 and QAM_256 otherwise )
> At the beginning w_scan was made to work in Germany only. But with the 
> time more and more additions were made
> and at some point one has to find a compromise. Either prolong scanning 
> time to be endless, omitt new features or change command line options.
> 
> If you need the some behaviour working in many european countries, you 
> may simply use "-c DE". It will give nearly the same result as the old 
> versions.
> 

Is there a way you can do a scanning without selecting a country, a scan
time of 25min is acceptable, as long as the result works? If not how can
i made an automated scanning that works in The Netherlands, Norway,
Germany and Belgum and France (one command) that works in all countries?

>  > I was hoping for auto signal strength detection and automatic filtering
>  > depending on the signal strength to remove duplicated channels from
>  > different broadcast towers.. what work is being done to realize this,
>  > and can I help by donating resources?
> 
> As soon we have dvb drivers which give some reliable and *comparable* 
> signal strength information
> signal information *across all frontends* this would be possible, not 
> earlier. But i guess it will never happen.

Me-TV and kaffeine show the signal strength I don't know if wscan can do
the same. The smart signal strength stuff is really mandatory I have
seen people go from Linux to mac only to get proper dvb-t scanning and
signal detection support. Any ideas?

> 
> Best Regards,
> Winfried

Best regards,

Jelle de Jong

