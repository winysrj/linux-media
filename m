Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:39762 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbbBUTI1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 14:08:27 -0500
Received: by mail-ig0-f175.google.com with SMTP id hn18so10178748igb.2
        for <linux-media@vger.kernel.org>; Sat, 21 Feb 2015 11:08:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALnjqVkteEsFGQXRdh3exzGrqdC=Qw4guSGRT_pCF50WjGqy1g@mail.gmail.com>
References: <CALnjqVkteEsFGQXRdh3exzGrqdC=Qw4guSGRT_pCF50WjGqy1g@mail.gmail.com>
Date: Sat, 21 Feb 2015 21:08:26 +0200
Message-ID: <CAAZRmGwmNhczjXNXdKkotS0YZ8Tc+kKb4b+SyNN_8KVj2H8xuQ@mail.gmail.com>
Subject: Re: Linux TV support Elgato EyeTV hybrid
From: Olli Salonen <olli.salonen@iki.fi>
To: Gilles Risch <gilles.risch@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gilles,

Not sure if the following information will help you, but here comes.
The USB bridge is EM2884, supported by em28xx driver. The Micronas
demodulator is probably supported by drxk driver. Tuner I did not
recognize after a quick glimpse. That sandwich construction look like
something PCTV has used with some of their designs (290e and 292e for
example).

In order to have a driver for your device you need to have each
individual component supported (USB bridge, demod and tuner). Then
these can be combined into a driver (typically by modifying the USB
bridge driver).

Cheers,
-olli

On 20 February 2015 at 18:19, Gilles Risch <gilles.risch@gmail.com> wrote:
> Hello,
>
> I'm owning an Elgato EyeTV hybrid USB stick that I'm using daily on my
> iMac, now I'd like to use it on my laptop too but I'm unable to get it
> running. Is this device already supported? If not, is there any way I
> can help? I've already opened my device and uploaded the photos to the
> linux TV wiki page
> (http://www.linuxtv.org/wiki/index.php/Elgato_EyeTV_hybrid).
> I'm not sure which tuner is mounted on the PCB, therefor I've made two
> USB traces, maybe someone could interpret them and conclude which one
> is used:
> https://www.dropbox.com/s/99b2a17ohu0zqpz/20150219-EyeTV_Hybrid_capturedTV.pcap?dl=0
> https://www.dropbox.com/s/q4k8zf8d3qpxznu/20150219-EyeTV_Hybrid_Pluggedin.pcap?dl=0
>
> Kind regards,
> Gilles
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
