Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1JP1aO-0003OE-Oz
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 21:18:36 +0100
Received: by nf-out-0910.google.com with SMTP id d21so1790701nfb.11
	for <linux-dvb@linuxtv.org>; Tue, 12 Feb 2008 12:18:35 -0800 (PST)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Tue, 12 Feb 2008 21:18:28 +0100
References: <47A9F742.3000708@winpe.com>
In-Reply-To: <47A9F742.3000708@winpe.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802122118.28355.christophpfister@gmail.com>
Subject: Re: [linux-dvb] New scan file
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Am Mittwoch 06 Februar 2008 schrieb clive:
> I couldn't find any reference to the uk-Belmont scan file, this caused
> me (a dvb numbskull) major problems in getting my DVB-T working.
> Finally I created a scan file that works.
> I have no idea how to submit this other than to post it to this mailing
> list.
> This really does need adding to the scan file list.

Meanwhile I've added / updated all uk-* files (because some had to be fixed).
Nevertheless thanks for your effort ...

> # uk-Belmont
> # file automatically generated by w_scan
> # (http://free.pages.at/wirbel4vdr/w_scan/index2.html)
> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> T 546000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE
> T 690000000 8MHz 2/3 1/2 QAM64 2k 1/32 NONE
> T 762000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO
^ (uhmm, quickly looking it up)
try "T 762167000 8MHz 3/4 NONE QAM16 2k 1/32 NONE" ;)

> T 786000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE
> T 834000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE
> T 850000000 8MHz 2/3 1/2 QAM64 2k 1/32 NONE
>
> Clive.

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
