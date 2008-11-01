Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <handygewinnspiel@gmx.de>) id 1KwDdR-00030y-7r
	for linux-dvb@linuxtv.org; Sat, 01 Nov 2008 11:23:14 +0100
Message-ID: <490C2DE9.9090809@gmx.de>
Date: Sat, 01 Nov 2008 11:22:33 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Jelle de Jong <jelledejong@powercraft.nl>
References: <490B6241.7020102@powercraft.nl>
In-Reply-To: <490B6241.7020102@powercraft.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] automated w_scan,
 duplicated channels and signal strength filtering
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

Hello Jelle,
> When a scan is completed it list all found channels, in the file, (see
> attachment) however this also include duplicated channels with other
> frequencies and strange channels that are from local unusable broadcast.
>   
That's most probably what your provider sends inside NIT (network 
information table).
w_scan reads it's informations from there. Sometimes these informations 
are wrong.
> The issue here is that signal strength is not used to filter out
> duplicated channels, only the best strongest signal should come in the
> channel list, and channels without identifiers should be removed.
>
> How can we do this? Is somebody able to fix these issues?
>
>   
It's not possible to use signal information since nearly every dvb cards 
sends other information for signal strength,
please read the discussion regarding SNR/strength some days ago here on 
the list. From application point of view
the signal strength information doesnt contain any useful data as long 
it's not standardized and reliable across all frontends.
Therefore i decided not to use signal strength. Otherwise some frontends 
would not work.

Signals without identifiers will not be removed, since some of them have 
their channel names inside EIT information or
inside private data (i.e. Prmiere) and deleting these channels would 
make other users really unhappy. ;)
Most of these channels are encrypted, so try to avoid them with -E 0 .
But channels without video *and* audio will be removed instead.

> [1] http://wirbel.htpc-forum.de/w_scan/index2.html
>
> ps. I can't find any contact info for the developer of w_scan.
>   
email contact is included in the header of each source file. 
Nevertheless, should be inside README too, you're right.

Regards,
Winfried



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
