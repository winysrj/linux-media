Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64311 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab2KTL17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Nov 2012 06:27:59 -0500
Received: by mail-qa0-f53.google.com with SMTP id k31so679587qat.19
        for <linux-media@vger.kernel.org>; Tue, 20 Nov 2012 03:27:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1603480.BOCkXrJCoo@dibcom294>
References: <CAKQROYXaEVasawMTd7XiDOvx_ZxL6H=0MqEds2-C+WFDru0m=Q@mail.gmail.com>
	<1603480.BOCkXrJCoo@dibcom294>
Date: Tue, 20 Nov 2012 11:27:58 +0000
Message-ID: <CAKQROYVznWot6Y3gV+2x2rsGKq0NhJwkFQVg8L0vPwQj0XABJQ@mail.gmail.com>
Subject: Re: Linux DVB Explained..
From: Richard <tuxbox.guru@gmail.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

Thanks for some clarifications, they are invaluable.

On 19 November 2012 10:52, Patrick Boettcher <pboettcher@kernellabs.com> wrote:
> Hi Richard,

>>
>> -------------------
>> The hardware I am using has 6 TS data inputs, 4 tuners (linked to TS
>> inputs)  and hardware PID filters and I am trying to establish the
>> relationship of dmx and dmxdev.
>
> Before understanding the relationship you need to know where, in the end,
> you want your TS-packets. In user-space? Sent to a hardware-decoder?
> Somewhere else? All of that?
>
> HTH a litte bit,
> --
> Patrick
>

A brief description of the hardware platform :
The device is a Dual Core ARM A9 SoC with 8 TS inputs (each TS channel
has a dedicated PID filter) . There are 8 MPEG decoders and two live
video surfaces.  All TS channels can go to a mpeg decoder directly OR
can be placed in a ringbuffer so that it can be sent to userspace (DVR
perhaps)

My aim is to create a skeleton DVB device (that works with my
hardware) with documentation so that others dont have to learn the
lessons I have :D

It sounds easy, but I doubt it is..
Richard
