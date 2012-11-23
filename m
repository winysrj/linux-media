Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab2KWUK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 15:10:57 -0500
Date: Fri, 23 Nov 2012 18:10:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Mysterious USB device ID change on Hauppauge HVR-900 (em28xx)
Message-ID: <20121123181049.6ee0f487@redhat.com>
In-Reply-To: <50AFABDA.9050309@googlemail.com>
References: <50AFABDA.9050309@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 23 Nov 2012 18:01:14 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Hi,
> 
> I've got a Hauppauge HVR-900 (65008/A1C0) today. First,  the device
> showed up as USB device 7640:edc1 (even after several unplug - replug
> cycles), so I decided to add this VID:PID to the em28xx driver to see
> what happens.
> That worked fine, em2882/em2883, tuner xc2028/3028 etc. were detected
> properly.
> Later I noticed, that the device now shows up as 2040:6500, which is the
> expected ID for this device.
> Since then, the device maintains this ID. I also checked if Windows is
> involved, but it shows up with the same ID there.

This is a known hardware bug on some HVR devices. I have this problem with
one based on tm6000: sometimes, it is not able to read from the EEPROM.
When this happens, it gets the manufacturer's default USB ID.

You may force it to use the right em28xx entry using "card=" modprobe
parameter.

-- 
Regards,
Mauro
