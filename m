Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt1.poste.it ([62.241.4.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1JhKQ4-0007i7-9n
	for linux-dvb@linuxtv.org; Thu, 03 Apr 2008 10:03:38 +0200
Received: from nico2.od.loc (89.97.249.170) by relay-pt1.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 47F41E480000760C for linux-dvb@linuxtv.org;
	Thu, 3 Apr 2008 10:03:30 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Thu, 3 Apr 2008 10:05:31 +0200
References: <25709347.2350411207167811091.JavaMail.www@wwinf4612>
In-Reply-To: <25709347.2350411207167811091.JavaMail.www@wwinf4612>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804031005.31873.Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] Can't record transport stream - Error:
	cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)
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

On Wednesday 02 April 2008 22:23:31 Abdou NIANG wrote:

> But when i try to record an entire Transport Stream with dvbstream
> like this:
>
> $ dvbstream 8192 -o > test.ts
>
> My output file "test.ts" is always empty. When i try to see
> kernel's messages i've:


dvbstream  -f FREQ -bw BW   -o 8192 > test.ts

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
