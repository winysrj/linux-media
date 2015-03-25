Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:54832 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbbCYGw6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 02:52:58 -0400
In-Reply-To: <55103587.3080901@butterbrot.org>
References: <550FFFB2.9020400@butterbrot.org> <55103587.3080901@butterbrot.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: input_polldev interval (was Re: [sur40] Debugging a race condition)?
From: Florian Echtler <floe@butterbrot.org>
Date: Wed, 25 Mar 2015 07:52:54 +0100
To: linux-input <linux-input@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Benjamin Tissoires <benjamin.tissoires@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-ID: <43CDB224-5B10-4234-9054-7A7EC1EDA3BF@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for the continued noise, but this bug/crash is proving quite difficult to nail down.

Currently, I'm setting the interval for input_polldev to 10 ms. However, with video data being retrieved at the same time, it's quite possible that one iteration of poll() will take longer than that. Could this ultimately be the reason? What happens if a new poll() call is scheduled before the previous one completes?

Best, Florian

On March 23, 2015 4:47:19 PM CET, Florian Echtler <floe@butterbrot.org> wrote:
>Additional note: this happens almost never with the original code using
>dma-contig, which is why I didn't catch it during testing. I've now
>switched back and forth between the two versions multiple times, and
>it's definitely a lot less stable with dma-sg and usb_sg_init/_wait.
>Maybe that can help somebody in narrowing down the reason of the
>problem?
>
>Best, Florian
>
>On 23.03.2015 12:57, Florian Echtler wrote:
>> Hello everyone,
>> 
>> now that I'm using the newly merged sur40 video driver in a
>development
>> environment, I've noticed that a custom V4L2 application we've been
>> using in our lab will sometimes trigger a hard lockup of the machine
>> (_nothing_ works anymore, no VT switching, no network, not even Magic
>> SysRq).
>> 
>> This doesn't happen with plain old cheese or v4l2-compliance, only
>with
>> our custom application and only under X11, i.e. as far as I can tell,
>> when the input device is being polled at the same time. However, I
>have
>> a really hard time tracking this down, as even SysRq doesn't work
>> anymore. A console continuously dumping dmesg or strace of our tool
>> didn't really help, either.
>> 
>> I assume that somehow the input_polldev thread is put to
>sleep/waiting
>> for a lock due to the video functions and that causes the lockup, but
>I
>> can't really tell where that might happen. Can somebody with better
>> knowledge of the internals give some suggestions?
>> 
>> Thanks & best regards, Florian
>> 

-- 
SENT FROM MY PDP-11
