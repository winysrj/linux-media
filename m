Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39927 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2FON7v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 09:59:51 -0400
Received: by yenl2 with SMTP id l2so1873440yen.19
        for <linux-media@vger.kernel.org>; Fri, 15 Jun 2012 06:59:50 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 Jun 2012 10:59:50 -0300
Message-ID: <CALF0-+U_9Fa6n_2dFPjNoWaGBn1T-JMefQwn223zftvE65=rfw@mail.gmail.com>
Subject: STK1160 has audio now (was Re: [Q] Why is it needed to add an alsa
 module to v4l audio capture devices?)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again,

On Mon, Jun 11, 2012 at 1:39 PM, Ezequiel Garcia >>
>> some setup is required to configure the audio input associated with a video input,
>> and to enable clock for the audio sampler. Such setup is made when a video input is
>> selected. You likely need something similar for stk1160.
>>

I've added audio initialization as done by easycap (staging) driver
and now I'm capturing audio using snd-usb-audio :-)

It seems to me that almost everything in easycap_sound.c
is not actually needed,
since it's already implemented by snd-usb-audio.

In other words, there is nothing vendor specific there (except from
some register poking).

In yet another words, next time I'll submit stk1160 it won't have any
of easycap_sound.c code.
Instead, snd-usb-audio driver is expected to be used.

Thanks,
Ezequiel.
