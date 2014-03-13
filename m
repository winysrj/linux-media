Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51286 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbaCMQFl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 12:05:41 -0400
Message-ID: <5321D750.9040103@iki.fi>
Date: Thu, 13 Mar 2014 18:05:36 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [REVIEW PATCH 02/16] e4000: implement controls via v4l2 control
 framework
References: <1393461025-11857-1-git-send-email-crope@iki.fi> <1393461025-11857-3-git-send-email-crope@iki.fi> <20140313105727.43c3d689@samsung.com> <5321CC1E.3080509@iki.fi>
In-Reply-To: <5321CC1E.3080509@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.03.2014 17:17, Antti Palosaari wrote:
> On 13.03.2014 15:57, Mauro Carvalho Chehab wrote:
>> Em Thu, 27 Feb 2014 02:30:11 +0200
>> Antti Palosaari <crope@iki.fi> escreveu:
>>
>>> Implement gain and bandwidth controls using v4l2 control framework.
>>> Pointer to control handler is provided by exported symbol.

>> There are two things to be noticed here:
>>
>> 1) Please don't add any EXPORT_SYMBOL() on a pure I2C module. You
>> should, instead, use the subdev calls, in order to callback a
>> function provided by the module;
>
> That means, I have to implement it as a V4L subdev driver then...
>
> Is there any problem to leave as it is? It just only provides control
> handler using that export. If you look those existing dvb frontend or
> tuner drivers there is many kind of resources exported just similarly
> (example DibCom PID filters, af9033 pid filters), so I cannot see why
> that should be different.
>
>> 2) As you're now using request_module(), you don't need to use
>> #if IS_ENABLED() anymore. It is up to the module to register
>> itself as a V4L2 subdevice. The caller module should use the
>> subdevice interface to run the callbacks.
>>
>> If you don't to that, you'll have several issues with the
>> building system.
>
> So basically you are saying I should implement that driver as a V4L
> subdev too?


That is not so simple!
If you look how that device is build on driver level

rtl28xxu USB-interface driver is *master*
rtl28xxu loads rtl2832 demod driver
rtl28xxu loads e4000 tuner driver
rtl28xxu loads rtl2832_sdr driver

Whole palette is build upon DVB API, but rtl2832_sdr driver offers SDR 
API for userspace. So it is not that simple "go to and implement V4L2 
subdevice to e4000 DVB driver". Only thing needed is to find out some 
way to pass control handler from e4000 to rtl2832_sdr. There is no 
likely any existing solution where DVB side uses V4L2 subdevice and 
implementing such at this tight schedule does not sound reasonable. Why 
you didn't mention you want subdevice earlier? At the very first I 
implemented that using DVB tuner .set_config() callback, but you asked 
to switch v4l2 control framework. And now I should switch to subdev.

There does not seems to be any suitable callback for getting that kind 
of pointer. There is only one existing quite similar solution what I 
know, it is stv6110x / stv090x and I don't like it :)

Any idea?

regards
Antti

-- 
http://palosaari.fi/
