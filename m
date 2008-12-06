Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1L8rpv-0003zQ-Fj
	for linux-dvb@linuxtv.org; Sat, 06 Dec 2008 08:44:25 +0100
Received: by ug-out-1314.google.com with SMTP id x30so202684ugc.16
	for <linux-dvb@linuxtv.org>; Fri, 05 Dec 2008 23:44:20 -0800 (PST)
Date: Sat, 6 Dec 2008 08:44:17 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: litlle girl <little.linux.girl@gmail.com>
In-Reply-To: <9e27f5bf0812051407g687a280ao7d9599a4bebcab8@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0812060829280.11349@ybpnyubfg.ybpnyqbznva>
References: <9e27f5bf0812051407g687a280ao7d9599a4bebcab8@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] EMTEC S826 (ID 1164:1f08 YUAN STK7700D)
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

On Fri, 5 Dec 2008, litlle girl wrote:

> im trying my friends usb tv card EMTEC S826 to run on my linux,
> so far without succes :(

Where are you?  I did not see any useful info when looking
at your mail headers...  But then, webmail isn't the most
revealing, and text/html, urgh...


> dvbscan /usr/share/dvb/dvb-t/* -vv:

> 530000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:T
> RANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE

This can only be expected to work somewhere where you can
receive an 8MHz 64QAM 8k MFN signal at 530MHz; the best
I can guess from the timestamp in your mail header is that
you are in west or central europe...

The current source I have shows these parameters for a few
locations in France, Italia, and Polska, if that helps.


barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
