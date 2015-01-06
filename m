Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61854 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbbAFMc3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 07:32:29 -0500
Received: by mail-pd0-f175.google.com with SMTP id g10so30197900pdj.6
        for <linux-media@vger.kernel.org>; Tue, 06 Jan 2015 04:32:29 -0800 (PST)
Message-ID: <54ABD5D8.20408@gmail.com>
Date: Tue, 06 Jan 2015 21:32:24 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 4/5] dvb core: add media controller support for the demod
References: <cover.1420127255.git.mchehab@osg.samsung.com>	<16368e1f9dfb1db65ec6f0d91a38d5233a12542c.1420127255.git.mchehab@osg.samsung.com>	<54AAA150.7000109@gmail.com> <20150105162947.4ebc553f@concha.lan>
In-Reply-To: <20150105162947.4ebc553f@concha.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015年01月06日 03:29, Mauro Carvalho Chehab wrote:
> Em Mon, 05 Jan 2015 23:36:00 +0900

>> And if so,
>> Shouldn't only the (tuner) subdevices be registered separately
>> in dvb_i2c_attach_tuner(), instead of dvb_i2c_attach_fe()?
> 
> No, it seems better to let dmxdev to register. That means that even
> the non-converted I2C drivers, plus the non-I2C drivers may benefit
> from the Media controller as well.

I guess you meant dvbdev instead of dmxdev,
but still I'm afraid that media_entity for a tuner module is not
registered like FE(demod),dmxdev,net,ca, because dvb_frontend_register()
registers just a demod (or a whole FE module) for now.

Tuner subdevices don't have their own device nodes to be passed to
dvb_register_media_device() in the first place,
So I think we need to define MEDIA_ENT_T_DVB_SUBDEV{,_TUNER}
and register a media_entity of type:MEDIA_ENT_T_DVB_SUBDEV_TUNER,
if a separate tuner chip is used.
 (with {major,minor} of the parent FE dev?)

If we can distinguish if a separate tuner subdev is used or not
by looking into "fe", then we might be able to register
the subdev from within  dvb_register_[media_]device().
But if we cannot know from "fe",
dvb_i2c_attach_tuner() looks to be a good place.

Further, when a DTV board has multiple tuners and/or multiple demods
and the link between them can be dynamically configurable,
(via media controller API or a new DVB ioctl?),
then a tuner subdev can be unused and connected to no demod,
so we cannot identify all tuner subdevs from the demod ("fe") anyway.

> Yeah, we could map this way, but that would require to add an extra
> parameter to the fe register function, with has already too much
> parameters. So, as it already uses an struct to pass parameters into
> it, I decided to just re-use it.

if we add dvb_adapter.mdev and a user sets the pointer,
then we can retrieve mdev in all the registering functions
(dvb_register_frontend, dvb_{dmxdev,net,ca_en50221}_init),
as all of them take a dvb_adapter parameter.

or is it possible that the FE,demux,net,ca under one DVB adapter
belong to different mdev's and each of them must keep its parent mdev
separately?

regards,
akihiro
