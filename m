Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <andreas.regel@gmx.de>) id 1Jrugy-0007eG-Cu
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 14:49:01 +0200
Message-ID: <481B0D8F.9090402@gmx.de>
Date: Fri, 02 May 2008 14:48:15 +0200
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <38846.203.200.233.131.1209733086.squirrel@203.200.233.138>
In-Reply-To: <38846.203.200.233.131.1209733086.squirrel@203.200.233.138>
Subject: Re: [linux-dvb] pes to ts conversion
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

Gurumurti Laxman Maharana schrieb:
> Hi All
> I want to know the steps to convert the PES stream to TS.
> basically to break PES into TS.
> Can any body help inthis regard or siggest any document or site.
> thanks with regards.

Hi,

TS and PES formats are described in ISO 13818-1, you can find this 
standard there http://neuron2.net/library/mpeg2/

You may also have a look at vdr-pvrinput plugin. It contains a simple 
PES to TS conversion.

Regards
Andreas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
