Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:32943 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbZE0Osw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 10:48:52 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1602681wfd.4
        for <linux-media@vger.kernel.org>; Wed, 27 May 2009 07:48:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090527105902.203620@gmx.net>
References: <20090527105902.203620@gmx.net>
Date: Wed, 27 May 2009 10:48:53 -0400
Message-ID: <829197380905270748h42ff6a3brf387016ddfe67a3f@mail.gmail.com>
Subject: Re: [linux-dvb] fe status values
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 27, 2009 at 6:59 AM, Markus Oliver Hahn
<markus.o.hahn@gmx.de> wrote:
> Hi there,
> I was just going throug the dvbapi 5.0
> but I couldn`t find ow to interpret the
> values which I get by
>
>
>
> int ioctl( int fd, int request = FE_READ_SIGNAL_STRENGTH, int16_t *strength);
>
> and
>
> int ioctl(int fd, int request = FE_READ_SNR, int16_t *snr)
>
> strengt should be (signed) dBm
> and
>    0.snr dB
>
> is this right ?
>
>
> regards markus
>
>
> --
> Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonanschluss für nur 17,95 Euro/mtl.!* http://portal.gmx.net/de/go/dsl02
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Hello Markus,

Unfortunately, there is currently no standard way in which the return
values can be interpreted.  The content varies by demodulator.  This
has been discussed at length on the linux-media ML if you want to read
the back history.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
