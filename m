Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n74.bullet.mail.sp1.yahoo.com ([98.136.44.186])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KBQ1K-0001BQ-BH
	for linux-dvb@linuxtv.org; Wed, 25 Jun 2008 10:06:27 +0200
Date: Wed, 25 Jun 2008 01:05:44 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Esa Hyytia <esa@ftw.at>
MIME-Version: 1.0
Message-ID: <555109.53449.qm@web46109.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems with Terratec Cinergy Piranha
Reply-To: free_beer_for_all@yahoo.com
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

Sorry for breaking the References: header; I'm pasting between
web browsers here, and this message was posted before I suscirbed

Esa Hyytia wrote:

> I bought today this USB stick (187f:0010) and tried to get it work in 32-bit Ub
> untu 8.04:

>  - Driver snapshot from today (http://linuxtv.org/hg/~mkrufky/siano)
>  - Firmware is extracted from driver-cd (same as from terratec.net)
>  - I also changed 'default_mode' to 0 in smscoreapi.c

That's your mistake -- now for DVB-T the default mode needs to be
left as 4 (that's DVBT-DBA-drivers; how that specifically differs
from mode 0 DVB-T I have no idea, but that's the way it is now)

Only mode 4 will work with yesterday's /siano snapshot, even
though the firmware is the same -- you'll also need to rename the
firmware to what the code expects:
dvbt_bda_stellar_usb.inp

There appears to be another copy of the smsdvb code in a repository
called somehow `hd' which differs slightly; the only difference I
looked at is one which I needed to apply for my 2.6.24-era kernel.
I need to look more closely at what else differs.
Hope that helps...
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
