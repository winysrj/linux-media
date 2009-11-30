Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbZK3S2c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 13:28:32 -0500
Message-ID: <4B140EAC.9030005@redhat.com>
Date: Mon, 30 Nov 2009 16:27:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: kevin granade <kevin.granade@gmail.com>,
	Andy Walls <awalls@radix.net>, Ray Lee <ray-lk@madrabbit.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jon Smirl <jonsmirl@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <1259469121.3125.28.camel@palomino.walls.org> <20091129124011.4d8a6080@lxorguk.ukuu.org.uk> <1259515703.3284.11.camel@maxim-laptop> <2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com> <1259537732.5231.11.camel@palomino.walls.org> <4B13B2FA.4050600@redhat.com> <1259585852.3093.31.camel@palomino.walls.org> <4B13C799.4060906@redhat.com> <7004b08e0911300814tb474f96s42ec56ca2e43cf7a@mail.gmail.com> <4B140200.9020503@redhat.com> <20091130180241.GA2030@core.coreip.homeip.net>
In-Reply-To: <20091130180241.GA2030@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> On Mon, Nov 30, 2009 at 03:33:52PM -0200, Mauro Carvalho Chehab wrote:
>> kevin granade wrote:
>>> On Mon, Nov 30, 2009 at 7:24 AM, Mauro Carvalho Chehab
>>> <mchehab@redhat.com> wrote:
>>>
>>>> After the boot, a device can open the raw API, disabling any in-kernel
>>>> decoding/handling and handle IR directly. Alternatively, an udev rule
>>>> can load a different keymap based on some config written on a file.
>>> This idea of the in-kernel decoding being disabled when the raw API is
>>> opened worries me.  What guarantees that the following scenario will
>>> not happen?
>>>
>>> User uses apps which retrieve the decoded IR messages from the kernel.
>>> User installs an app which decodes messages via the raw API (not lirc).
>>> User's other applications no longer receive IR messages.
>>>
>>> I know the assumption has been that "only lirc will use the raw API",
>>> but this seems like a poor assumption for an API design to me.
>> All those questions are theoretical, as we haven't a raw API code
>> already merged in kernel. So, this is just my understanding on how
>> this should work.
>>
>> If the user wants to use the raw interface, it is because the in-kernel
>> decoding is not appropriate for his usage
> 
> Not necessarily, someone might just want to observe the data stream for
> one reason or enough. You would not believe how many times I wanted
> to use evtest from X but could not because X grabs the device and had
> to switch to console....
> 
>> (at least while such application
>> is opened). So, not disabling the evdev output seems senseless.
> 
> You know what they say when you assume things?
> 
>> Btw, this is the same behavior that happens when some application directly 
>> opens an evdev interface, instead of letting it to be redirected to stdin.
> 
> Well, console applications don't get their input directly from event
> device but even if they did "not redirecting it to stdin" will not
> affect any other application that has the same event device open.
> 
> This is a _huge_ difference.
> 
>>> A related question, what is an application developer who wishes to
>>> decode the raw IR signal (for whatever reason) to do?  Are they
>>> *required* to implement full decoding and feed all the messages back
>>> to the kernel so they don't break other applications?
>> If such application won't do it, the IR will stop working, while the
>> application is in use.
>>
> 
> I don't think it is indication of a good solution.

Well, maybe then we may have an ioctl to explicitly disable the evdev processing
of the data that could be applied to the raw IR interface, instead of making
assumptions.
> 

