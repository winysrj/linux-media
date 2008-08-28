Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KYVDS-0000I8-6s
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 02:18:24 +0200
Received: by ey-out-2122.google.com with SMTP id 25so34256eya.17
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 17:18:18 -0700 (PDT)
Message-ID: <37219a840808271718y5c25d0d4y62f016de745143b2@mail.gmail.com>
Date: Wed, 27 Aug 2008 20:18:18 -0400
From: mkrufky@gmail.com
To: "Franck Bvl" <franckbvl@free.fr>
In-Reply-To: <48B5D5C7.6000802@free.fr>
MIME-Version: 1.0
Content-Disposition: inline
References: <48B5D5C7.6000802@free.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Signal strenght SNR and BER units
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

It is different for each demod, depending on who wrote the code. I can
list a bunch of drivers that report SNR in dB, but you cannot rely on
this because the drivers are not consistent between one another.  That
is why your searches didn't turn up any answers.  This is the first
email that i'm sending from my new cell phone - please excuse if the
quoting format got mangled...   -MiKE


On 8/27/08, Franck Bvl <franckbvl@free.fr> wrote:
> Hi,
>
> Whith dvbsnoop or femon, we can view the values of signal strenght (16
> bits),  SNR (16bits) and BER(32 bits). But what are the the scale and
> the units of this values. I Googling everywhere and can not find the
> meaning of its values. Are they're in DB ? I have just find, that the
> BER for the TT3200 are in 10E-7 scale, but that depends on card and drivers.
>
> Can You enlighten me ?
>
> I want to convert the hexadecimals values or the decimal form in human
> readable and explicit values.
>
> Best regards
>
> Franck
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
