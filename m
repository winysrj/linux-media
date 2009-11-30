Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:38110 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbZK3NXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 08:23:00 -0500
MIME-Version: 1.0
In-Reply-To: <1259585852.3093.31.camel@palomino.walls.org>
References: <m3r5riy7py.fsf@intrepid.localdomain>
	 <m3aay6y2m1.fsf@intrepid.localdomain>
	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	 <1259469121.3125.28.camel@palomino.walls.org>
	 <20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
	 <1259515703.3284.11.camel@maxim-laptop>
	 <2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com>
	 <1259537732.5231.11.camel@palomino.walls.org>
	 <4B13B2FA.4050600@redhat.com>
	 <1259585852.3093.31.camel@palomino.walls.org>
Date: Mon, 30 Nov 2009 08:23:05 -0500
Message-ID: <9e4733910911300523y69b66963t36db6d52def6679d@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ray Lee <ray-lk@madrabbit.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 30, 2009 at 7:57 AM, Andy Walls <awalls@radix.net> wrote:
> I suppose my best answer to that is question back to you: Why does udev
> run in userspace versus a kernel thread?

Because udev is a scripting system. I've always said that the
scripting piece of IR belongs in user space. IR scripting should be
optional, none of the systems I work on need it.

This is the event flow being built...

device timing data
 -- send timing data to user space
 -- do protocol decode (40K code)
 -- send decoded data back to kernel
other devices that decode in HW add events here
 -- send decoded data to user space
 -- map to keys (30K code)
 -- send keys back to kernel
apps listen for keys
 -- send keys back to user space
 -- user space apps act on key (possibly run scripts)

I'd like to see...

device timing data
-- user space can inject timing data from user space drivers
do protocol decode (40K code)
other devices that decode in HW add events here
-- user space can inject decoded data from user space drivers
map to keys (30K code)
apps listen for keys
 -- send keys back to user space
 -- user space apps act on key (possibly run scripts)



>
> My personal thoughts on why user space is more flexible:
>
> 1. You have all of *NIX available to you to use as tools to achieve your
> requirements.
>
> 2. You are not constrained to use C.
>
> 3. You can link in libraries with functions that are not available in
> the kernel.  (udev has libudev IIRC to handle complexities)
>
> 4. Reading a configuration file or other file from the filesystem is
> trivial - file access from usespace is easy.
>
> 5. You don't have to be concerned about the running context (am I
> allowed to sleep here or not?).
>
>
>
>
>
>
>> A kernelspace input device driver can start working since boot time.
>> On the other hand, an userspace device driver will be available only
>> after mounting the filesystems and starting the deamons
>> (e. g. after running inittab).
>>
>> So, you cannot catch a key that would be affecting the boot
>> (for example to ask the kernel to run a different runlevel or entering
>> on some administrative mode).
>
> Right.  That's another requirement that makes sense, if we're talking
> about systems that don't have any other keyboard handy to the user.
>
> So are we optimizing for the embedded/STB and HTPC with no keyboard use
> case, or the desktop or HTPC with a keyboard for maintencance?
>
>
> Regards,
> Andy
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Jon Smirl
jonsmirl@gmail.com
