Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kosio.dimitrov@gmail.com>) id 1KTGXN-0008QF-N4
	for linux-dvb@linuxtv.org; Wed, 13 Aug 2008 15:37:21 +0200
Received: by wf-out-1314.google.com with SMTP id 27so2611304wfd.17
	for <linux-dvb@linuxtv.org>; Wed, 13 Aug 2008 06:37:12 -0700 (PDT)
Message-ID: <8103ad500808130637v50e9a64eg6eb1fbdd32071971@mail.gmail.com>
Date: Wed, 13 Aug 2008 16:37:11 +0300
From: "Konstantin Dimitrov" <kosio.dimitrov@gmail.com>
To: "Guy Martin" <gmsoft@tuxicoman.be>
In-Reply-To: <20080813123241.0f7cffca@bleh.bxl.tuxicoman.be>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080813123241.0f7cffca@bleh.bxl.tuxicoman.be>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] CT-3650 driver effort
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

hi Guy,

you can easily get (extract) the TDA10048 firmware from the
Technotrend CT-3650 Windows drivers:

1) wget http://technotrend-online.com/download/software/bda/usb2driver//ttusb2bda_1.0.2.20.zip

2) unzip -jo ttusb2bda_1.0.2.20.zip ttusb2bda_1.0.2.20/ttusb2bda.sys

3) dd if=ttusb2bda.sys of=dvb-fe-tda10048-1.0.fw bs=1 skip=532560 count=24878

best wishes,
konstantin

2008/8/13 Guy Martin <gmsoft@tuxicoman.be>:
>
> Hi all,
>
> I'm currently trying to get the CT-3650 working.
> It has the following chips :
>  - TDA8264 (tuner)
>  - TDA10023 (DVB-C demod)
>  - TDA10048 (DVB-T demod)
>
>
> I'm able to get the DVB-C frontend working using the attached patch.
> However I can't test the DVB-T nor the CI.
>
> To test the DVB-T frontend, I'm missing dvb-fe-tda10048-1.0.fw which I
> can't find anywhere.
>
> Regarding the CI, I'm only watching FTA so I won't be able to test that.
>
>
> Please review the attached patch. If I'm given the tda10048 firmware I
> should probably get it to work.
>
>
> Regards,
>  Guy
>
> --
> Guy Martin
> Gentoo Linux - HPPA port lead
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
