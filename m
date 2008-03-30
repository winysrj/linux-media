Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.uli-eckhardt.de ([81.169.169.160])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <uli-dvb@uli-eckhardt.de>) id 1JftVs-0005Fe-1h
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 11:07:40 +0200
Received: from [192.168.1.2] (IP-213157026094.dialin.heagmedianet.de
	[213.157.26.94])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.uli-eckhardt.de (Postfix) with ESMTP id D7D8715A0548
	for <linux-dvb@linuxtv.org>; Sun, 30 Mar 2008 11:07:28 +0200 (CEST)
Message-ID: <47EF5855.1060202@uli-eckhardt.de>
Date: Sun, 30 Mar 2008 11:07:33 +0200
From: Ulrich Eckhardt <uli-dvb@uli-eckhardt.de>
MIME-Version: 1.0
To: Linux DVB <linux-dvb@linuxtv.org>
References: <c112e7e90803280226h49820354r6520ca723e3a3584@mail.gmail.com>
In-Reply-To: <c112e7e90803280226h49820354r6520ca723e3a3584@mail.gmail.com>
Subject: Re: [linux-dvb] HVR-3000 - cx22702 DVB-T Problem cx22702_readreg:
 /	cx22702_writereg:
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Mike Russell wrote:
> Hi
> =

> I am currently having problems getting this card working under 2.6.24 =

> for DVB-T.  The driver appears to load ok, but produces errors in dmesg =

> when attempting to scan for channels.

Hi,

it seems to me, that you use the original drivers from the linux kernel.
Installing the drivers as described in =

http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-3000
workes for kernel 2.6.24-4.

Uli
-- =

Ulrich Eckhardt                  http://www.uli-eckhardt.de

Ein Blitzableiter auf dem Kirchturm ist das denkbar st=E4rkste
Misstrauensvotum gegen den lieben Gott. (Karl Krauss)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
