Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1JXdRg-0005qd-WE
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 15:21:15 +0100
Received: by nf-out-0910.google.com with SMTP id d21so262385nfb.11
	for <linux-dvb@linuxtv.org>; Fri, 07 Mar 2008 06:21:04 -0800 (PST)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Fri, 7 Mar 2008 15:20:53 +0100
References: <47D0EA5B.8040105@philpem.me.uk>
In-Reply-To: <47D0EA5B.8040105@philpem.me.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803071520.53853.christophpfister@gmail.com>
Subject: Re: [linux-dvb] Updated scan file for uk-EmleyMoor
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

Am Freitag 07 M=E4rz 2008 schrieb Philip Pemberton:
> Here's a scan file for Emley Moor with the correct frequencies and tuning
> parameters... Seems the one in the linux-dvb distribution has frequencies
> with a -133kHz or so offset, and without the correct QAM parameters.

http://linuxtv.org/hg/dvb-apps/file/be328ab0f32f/util/scan/dvb-t/uk-EmleyMo=
or =

is correct.

> Probably my fault, because IIRC I submitted that tuning file...
>
> Data sourced from www.ukfree.tv, and works fine on my HVR-3000.
>
> # Emley Moor, West Yorkshire
> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> T 626000000 8MHz 2/3 3/4 QAM64 2k 1/32 NONE
> T 650000000 8MHz 2/3 3/4 QAM64 2k 1/32 NONE
> T 674000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE
> T 698000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE
> T 706000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE
> T 722000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
