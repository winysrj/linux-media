Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1627 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbZCQIpx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 04:45:53 -0400
Message-ID: <36896.62.70.2.252.1237279540.squirrel@webmail.xs4all.nl>
Date: Tue, 17 Mar 2009 09:45:40 +0100 (CET)
Subject: Re: qv4l2 (was [PATCH] LED control)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Jean-Francois Moine" <moinejf@free.fr>
Cc: "Trent Piepho" <xyzzy@speakeasy.org>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Sun, 15 Mar 2009 08:14:56 -0700 (PDT)
> Trent Piepho <xyzzy@speakeasy.org> wrote:
>
>> > - this asks to have a kernel generated with CONFIG_NEW_LEDS,
>>
>> So?
>>
>> > - the user must use some new program to
>> > access /sys/class/leds/<device>,
>>
>> echo, cat?
>>
>> > - he must know how the LEDs of his webcam are named in the /sys
>> > tree.
>>
>> Just give them a name like video0:power and it will be easy enough to
>> associate them with the device.  I think links in sysfs would do it
>> to, /sys/class/video4linux/video0/device/<ledname> or something like
>> that.
>>
>> The advantage of using the led class is that you get support for
>> triggers and automatic blink functions, etc.
>
> Sorry for I don't see the usage of blinking the LEDs for a webcam.
>
> Again, using the led class makes me wonder about:
>
> 1) The end users.
>
> Many Linux users don't know the kernel internal, nor which of the too
> many applications they should use to make their devices work. If no
> developper creates a tool to handle the webcams, the users have to
> search again and again. Even if there is a full documentation, they
> will try anything and eventually ask the kernel developpers why they
> cannot have their LEDs switched on.
>
> Actually, there are a few programs that can handle the webcam
> parameters. In fact I know only 'v4l2-ctl': I did not succeeded to
> compile qv4l2

What compile errors do you get?

If you do not have qt3 installed, then it will be interesting to see if
you can compile the qv4l2 in my ~hverkuil/v4l-dvb-qv4l2 tree which is qt4.
It still needs more cleanup and tweaking before I can merge that in the
v4l-dvb tree, though.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

