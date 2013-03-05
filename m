Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab3CECbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 21:31:48 -0500
Date: Mon, 4 Mar 2013 23:31:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 06/11] em28xx: make sure we are at i2c bus A when
 calling em28xx_i2c_register()
Message-ID: <20130304233143.688cdace@redhat.com>
In-Reply-To: <5135111B.4010102@googlemail.com>
References: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
	<1362339464-3373-7-git-send-email-fschaefer.oss@googlemail.com>
	<20130304161415.4cf0442d@redhat.com>
	<5135111B.4010102@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 04 Mar 2013 22:24:43 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 04.03.2013 20:14, schrieb Mauro Carvalho Chehab:

> > 	3) It doesn't properly address the real issue: a separate I2C
> > register is needed for bus B.
> 
> Definitely. :(
> We talked about that at the beginning.
> 
> I have spent several ours working on this, but finally gave it up (for
> now), because
> a) it is a very huge change. I started changing/fixing one thing, then I
> noticed that this requires fixing 2 other issues first, which again made
> it necessary to change others and so on...
> The main problem isn't the i2c adapter/bus changes, it's the subdevice
> handling/tracking...
> b) the resulting code has a big overhead and I'm not sure if it is
> justified as long as there is no device yet using both busses in parallel.
> 
> Sure, we all like clean code and sooner or later we will likely be
> forced to do it properly.
> Maybe I will come back to it when the webcam stuff is finished.
> But for now (with regards to the eeprom reading), reordering the bus
> setup/configuration calls seems to be the easiest and appropriate
> solution to me.

Hmm... I found it easy to do it ;)

The fact that, currently, on all devices, The first bus has the eeprom[1]
and that all other devices are on the secondary bus makes easy to properly
implementing it with just a few changes. Ok, if/when we start to see
devices mixed, we'll need to add a more complex logic, but for now,
it can be simply done, and em28xx i2c scan can check both buses, with
may help future development.

I'll post some patches tomorrow after testing.

[1] That could be a hardware requirement, as it makes easier for the
device to seek for eeprom data.

Regards,
Mauro
