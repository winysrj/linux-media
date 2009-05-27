Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f216.google.com ([209.85.218.216])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1M9MZ1-0006NY-OT
	for linux-dvb@linuxtv.org; Wed, 27 May 2009 19:05:16 +0200
Received: by bwz12 with SMTP id 12so4762981bwz.17
	for <linux-dvb@linuxtv.org>; Wed, 27 May 2009 10:04:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090527105902.203620@gmx.net>
References: <20090527105902.203620@gmx.net>
Date: Wed, 27 May 2009 21:04:41 +0400
Message-ID: <1a297b360905271004w6736aefai6cae3c29a5886c48@mail.gmail.com>
From: Manu Abraham <abraham.manu@gmail.com>
To: Markus Oliver Hahn <markus.o.hahn@gmx.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] fe status values
Reply-To: linux-media@vger.kernel.org
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

On Wed, May 27, 2009 at 2:59 PM, Markus Oliver Hahn
<markus.o.hahn@gmx.de> wrote:
> Hi there,
> I was just going throug the dvbapi 5.0
> but I couldn`t find ow to interpret the
> values which I get by
>
>
>
> int ioctl( int fd, int request =3D FE_READ_SIGNAL_STRENGTH, int16_t *stre=
ngth);
>
> and
>
> int ioctl(int fd, int request =3D FE_READ_SNR, int16_t *snr)
>
> strengt should be (signed) dBm
> and
> =A0 =A00.snr dB
>
> is this right ?


dB scale is not something that which is supported by the API specification.
Mostly the scale, it depends on the implementation in the various drivers.
Which driver are you looking at ?

Something, that compliant in accordance:
http://linuxtv.org/hg/dvb-apps/file/9655c8cfeed8/util/szap/README

Regards,
Manu

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
