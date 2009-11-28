Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:55853 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZK1S6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 13:58:21 -0500
MIME-Version: 1.0
In-Reply-To: <4B116954.5050706@s5r6.in-berlin.de>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	 <4B116954.5050706@s5r6.in-berlin.de>
Date: Sat, 28 Nov 2009 13:58:27 -0500
Message-ID: <9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 28, 2009 at 1:17 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Jon Smirl wrote:
>> There are two very basic things that we need to reach consensus on first.
>>
>> 1) Unification with mouse/keyboard in evdev - put IR on equal footing.
>> 2) Specific tools (xmodmap, setkeycodes, etc or the LIRC ones) or
>> generic tools (ls, mkdir, echo) for configuration
>
> About 2:  If at all, there only needs to be a decision about pulse/space
> to scancode converter configuration.  In contrast, scancode to keycode
> converter configuration is already solved; the interface is
> EVIOCSKEYCODE.  If you find the EVIOCSKEYCODE interface lacking, extend
> it or submit an alternative --- but this does not affect LIRC and
> whether to merge it in any way.

EVIOCSKEYCODE is lacking, first parameter is an INT. Some decoded IR
codes are over 32b. Christoph posted an example that needs 128b. This
is a problem with ioctls, they change size depending on platform and
endianess.

Also, how do you create the devices for each remote? You would need to
create these devices before being able to do EVIOCSKEYCODE to them.

>
> PS:  Drop your "specific vs. generic tools" terminology already.  Your
> configfs based proposal requires "specific" tools as well, it's just
> that they can be implemented in bash, among else.

The shell commands are the most generic tools in Unix. udev already
knows how to run shell scripts.

But there is no technical reason why setkeycodes, getkeycodes,
showkey, loadkeys, xmodmap, and dump-keys can't be modified to support
IR. I already have to have the man page on the screen when using these
commands so adding a bunch more parameters won't hurt.

> --
> Stefan Richter
> -=====-==--= =-== ===--
> http://arcgraph.de/sr/
>



-- 
Jon Smirl
jonsmirl@gmail.com
