Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f212.google.com ([209.85.218.212]:56701 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936066Ab0BZNFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 08:05:33 -0500
Received: by bwz4 with SMTP id 4so43610bwz.28
        for <linux-media@vger.kernel.org>; Fri, 26 Feb 2010 05:05:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B87B8E6.6040608@infradead.org>
References: <201002201500.21118.hverkuil@xs4all.nl>
	 <201002220012.20797.laurent.pinchart@ideasonboard.com>
	 <000901cab45b$a8c55a10$fa500e30$%osciak@samsung.com>
	 <201002260046.16878.laurent.pinchart@ideasonboard.com>
	 <001b01cab6b6$631d05f0$295711d0$%osciak@samsung.com>
	 <4B87B8E6.6040608@infradead.org>
Date: Fri, 26 Feb 2010 08:05:30 -0500
Message-ID: <55a3e0ce1002260505s798e3945ueb1e929dd87e6ea6@mail.gmail.com>
Subject: Re: More videobuf and streaming I/O questions
From: Muralidharan Karicheri <mkaricheri@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Pawel Osciak <p.osciak@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 26, 2010 at 7:04 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Pawel Osciak wrote:
>>> On Tuesday 23 February 2010 08:41:49 Pawel Osciak wrote:
>>>>> On Mon, 22 Feb 2010 00:12:18 +0100
>>>>> Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>>>> As for the REQBUF, I've always thought it'd be nice to be able to ask the
>>>> driver for the "recommended" number of buffers that should be used by
>>>> issuing a REQBUF with count=0...
>>> How would the driver come up with the number of recommended buffers ?
>>
>> From the top of my head: when encoding a video stream, a codec driver could
>> decide on the minimum number of input frames required (including reference
>> frames, etc.).
>>
>> Or maybe I am missing something, what is your opinion on that?
>
> There are some cases where this feature could be useful. For example, there are
> some devices used for surveillance that have one decoder connected to several
> inputs. For example, several bttv boards have one bt848 chip for each 8 inputs.
> Each input is connected to one camera. The minimum recommended number of buffers
> is 16 (2 per each input). This is poorly documented, on some wikis for some of
> the boards with such usage.
>
> That's said, there's currently a few missing features for surveillance: the user
> software need to manually switch from one input to another, and the video buffer
> metadata doesn't indicate the input.
>
> The better would be to provide a way to let the driver to switch to the next camera
> just after the reception of a new buffer (generally at the IRQ time), instead of
> letting the userspace software to do it at the DQBUF.
>
This is an interesting use case and I would like to know some details
on this use case.
When you say application manually switch the input, Is it implementing
some kind of
input multiplexing during the session (open, stream on - stream off,
close) ? We have
encountered a similar use case and I was wondering how this can be implemented
in v4l2 driver. In my understanding, a v4l2 device is not allowed to
switch input while
streaming. Does it require 2 buffers per input because every frame
period, you have multiple
frames to queue from the different inputs? Usually a minimum of 3
buffers are typically
required in a SoC case to do streaming. Could you share the details if possible?

Murali
> --
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Murali Karicheri
mkaricheri@gmail.com
