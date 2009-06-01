Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39799 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757298AbZFAMCM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2009 08:02:12 -0400
Message-ID: <4A23C321.6010608@gmx.de>
Date: Mon, 01 Jun 2009 14:01:37 +0200
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	"jelledejong@powercraft.nl" <jelledejong@powercraft.nl>
Subject: Re: w_scan 20090502, why is the new country code necessary, its breaking
 my systems
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jelle,

 > My w_scan version 20081106 stopped working on my Debian system. I had
 > the following errors:
 > ERROR: Sorry - i couldn't get any working frequency/transponder
 >
 > So I first checked if there was a wscan update.

No reception for some reason - probably the new version will show the 
same result.

 > I had to make a new argument line:
 > ~/.wscan/wscan -t 3 -A 1 -E 0 -O 0 -c NL -X tzap > 
~/.wscan/channels.conf

"-A 1" is wrong for you, please omitt this one, it's used outside Europe 
only.
"-O 0" is default anyway, not needed

 > This is very troubling for me because I must have a scan command that
 > works in complete Europa and not in one country. This is because I have
 > traveling systems that need to scan for channels on every stop.
 >
 > Why :-( please explain and try to fix this regression that a country
 > code is needed?

w_scan tends to be used now to be used also in other countries - with 
different settings
- frequency lists
- frequency offsets from center frequency
- Symbolrates
- channel bandwidths
- Modulations ( QAM_128 for example in FI, QAM_64 and QAM_256 otherwise )
At the beginning w_scan was made to work in Germany only. But with the 
time more and more additions were made
and at some point one has to find a compromise. Either prolong scanning 
time to be endless, omitt new features or change command line options.

If you need the some behaviour working in many european countries, you 
may simply use "-c DE". It will give nearly the same result as the old 
versions.

 > I was hoping for auto signal strength detection and automatic filtering
 > depending on the signal strength to remove duplicated channels from
 > different broadcast towers.. what work is being done to realize this,
 > and can I help by donating resources?

As soon we have dvb drivers which give some reliable and *comparable* 
signal strength information
signal information *across all frontends* this would be possible, not 
earlier. But i guess it will never happen.

Best Regards,
Winfried


