Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp04.msg.oleane.net ([62.161.4.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1KNP2M-0000BA-Pb
	for linux-dvb@linuxtv.org; Mon, 28 Jul 2008 11:29:04 +0200
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <nicola.sabbi@poste.it>, <linux-dvb@linuxtv.org>
Date: Mon, 28 Jul 2008 11:28:36 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAA+WVUb3rAwE+iBca0aK1CUAEAAAAA@tv-numeric.com>
MIME-Version: 1.0
In-Reply-To: <1216992923.3726.1.camel@suse.site>
Subject: [linux-dvb] RE : question about definition of section in PSI of
	Transport stream
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

> Nico Sabbi wrote:
>
> yes, but in theory even PMTs can be sectioned

No, this is forbidden by ISO 13818-1:

2.4.4.9 Semantic definition of fields in Transport Stream program map section
[...]
section_number - The value of this 8-bit field shall be 0x00.
last_section_number - The value of this 8-bit field shall be 0x00.

-Thierry


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
