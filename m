Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nskntmtas01p.mx.bigpond.com ([61.9.168.137])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mickhowe@bigpond.net.au>) id 1KfPPa-00014I-VV
	for linux-dvb@linuxtv.org; Tue, 16 Sep 2008 03:31:28 +0200
Received: from nskntotgx02p.mx.bigpond.com ([124.186.164.191])
	by nskntmtas01p.mx.bigpond.com with ESMTP id
	<20080916013047.EUTF1812.nskntmtas01p.mx.bigpond.com@nskntotgx02p.mx.bigpond.com>
	for <linux-dvb@linuxtv.org>; Tue, 16 Sep 2008 01:30:47 +0000
Received: from fini.bareclan ([124.186.164.191])
	by nskntotgx02p.mx.bigpond.com with ESMTP
	id <20080916013047.CPXM1865.nskntotgx02p.mx.bigpond.com@fini.bareclan>
	for <linux-dvb@linuxtv.org>; Tue, 16 Sep 2008 01:30:47 +0000
From: mick <mickhowe@bigpond.net.au>
To: linux-dvb@linuxtv.org
Date: Tue, 16 Sep 2008 11:30:46 +1000
References: <200809152211.06386.jhhummel@bigpond.com>
In-Reply-To: <200809152211.06386.jhhummel@bigpond.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809161130.46410.mickhowe@bigpond.net.au>
Subject: Re: [linux-dvb] DTV2000H
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

On Mon, 15 Sep 2008 22:11:06 Jonathan wrote:
> Hi,
>
> I've had a look on Google, and there seems to be quite a bit of mail forums
> about a patch for rev J of this card, but they all seem to have issues of
> some form.
>
> Apparently the patch can get analogue TV and Radio working.
>
> Can anyone shed some light on this?
by changing
 +	if ((core->board)
to
+	if ((core->boardnr)
in the cx88-mpeg.c patch I got it to compile and can get analog tv without 
sound.

The sound problem may be unrelated to the patch as I have lost audio 
system-wide as a regular user and 'randomly' as root.

/]/]ik


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
