Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1KpQMH-0000wp-Sj
	for linux-dvb@linuxtv.org; Mon, 13 Oct 2008 18:33:27 +0200
Received: by qw-out-2122.google.com with SMTP id 9so518771qwb.17
	for <linux-dvb@linuxtv.org>; Mon, 13 Oct 2008 09:33:21 -0700 (PDT)
Message-ID: <854d46170810130933jab08cdetd16a11654615bf7c@mail.gmail.com>
Date: Mon, 13 Oct 2008 18:33:21 +0200
From: "Faruk A" <fa@elwak.com>
To: christian@heidingsfelder.eu
In-Reply-To: <48F371C6.3040401@heidingsfelder.eu>
MIME-Version: 1.0
Content-Disposition: inline
References: <48F360B1.7070705@heidingsfelder.eu>
	<854d46170810130834p6118793co49ecb6ed8809062@mail.gmail.com>
	<48F371C6.3040401@heidingsfelder.eu>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend TT-Connect S2-3650 CI
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

> Yes , i read that.
> Unfortunately my hardware (Toshiba M-60 167) works perfectly with the .26
> kernel and i dont want to downgrade the kernel to .25 .
> I am lucky that all  works now as i a am not that linux  Expert (using
> gentoo  since 2 Months).
> Thanks for answering :-)
> --

Unfortunately there has been changes with linux-dvb this past 2-3 weeks they
switched api from multiproto to S2, so we have to wait untill someone port the
drivers.
The old drivers is for multiproto and i don't think they will get
support for the latest
and future kernels.
But you can try talking to "Dominik Kuhlen", dkuhlen (at) gmx.net he
wrote the driver
maybe he can provide a patch to support latest kernels.
Try "Michael H. Schimek" too mschimek (at) gmx.at  he wrote the Common
Interface support.

Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
