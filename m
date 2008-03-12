Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+73100873cbc0c5744e24+1662+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JZY7A-0000Kb-2R
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 22:03:56 +0100
Date: Wed, 12 Mar 2008 18:03:21 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Hoogenraad <jan-conceptronic@h-i-s.nl>
Message-ID: <20080312180321.6a6800a1@gaivota>
In-Reply-To: <47D462DD.5080500@h-i-s.nl>
References: <1203538678.8313.12.camel@srv-roden.vogelwikke.nl>
	<47BCAC32.9050601@h-i-s.nl> <47BCB371.2020809@h-i-s.nl>
	<20080227075056.34a80abd@areia> <47D462DD.5080500@h-i-s.nl>
Mime-Version: 1.0
Cc: achasper@gmail.com, linux-dvb@linuxtv.org,
	stealth banana <stealth.banana@gmail.com>
Subject: Re: [linux-dvb] Driver source for Freecom DVB-T (with usb id
 14aa:0160)	v0.0.2 works
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

On Sun, 09 Mar 2008 23:21:17 +0100
Jan Hoogenraad <jan-conceptronic@h-i-s.nl> wrote:

> Mauro:
> 
> Thanks a lot for the comments.
> One clear problem with this particular driver is that the code that came 
> from RealTek does not conform to the Linux C coding style.
> Would that be an objection for the steps below ?

Considering that RealTek won't be interested on correcting the CodingStyle,
IMO, the better would be to commit RealTek code as-is, with their SOB, and then
adding an additional patch, authored by somebody else could fix the CodingStyle.

A very simple patch to fix CodingStyle can be created by running kernel
scripts/Lindent. Unfortunately, the results of this automatic tool are not
perfect, but generally are acceptable.

> Furthermore, can you confirm linux-dvb@linuxtv.org as the submission 
> address for the patch ?

Yes. Please C/C me also at the submission e-mail.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
