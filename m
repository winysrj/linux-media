Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48647 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZK1TqL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 14:46:11 -0500
Message-ID: <4B117DEA.3030400@s5r6.in-berlin.de>
Date: Sat, 28 Nov 2009 20:45:46 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>	 <4B116954.5050706@s5r6.in-berlin.de> <9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com>
In-Reply-To: <9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> On Sat, Nov 28, 2009 at 1:17 PM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>> Jon Smirl wrote:
>>> There are two very basic things that we need to reach consensus on first.
>>>
>>> 1) Unification with mouse/keyboard in evdev - put IR on equal footing.
>>> 2) Specific tools (xmodmap, setkeycodes, etc or the LIRC ones) or
>>> generic tools (ls, mkdir, echo) for configuration
>> About 2:  If at all, there only needs to be a decision about pulse/space
>> to scancode converter configuration.  In contrast, scancode to keycode
>> converter configuration is already solved; the interface is
>> EVIOCSKEYCODE.  If you find the EVIOCSKEYCODE interface lacking, extend
>> it or submit an alternative --- but this does not affect LIRC and
>> whether to merge it in any way.
> 
> EVIOCSKEYCODE is lacking, first parameter is an INT. Some decoded IR
> codes are over 32b. Christoph posted an example that needs 128b. This
> is a problem with ioctls, they change size depending on platform and
> endianess.

No, they do not "change size depending on platform and endianess" if
basic rules are observed.  Defining compatible ioctls is not rocket
science.  Sure, "int" should not be used in ioctl arguments or other
binary interfaces.

(I never said EVIOCSKEYCODE was not lacking, I only said it exists
already.  When you talk about better scancode-to-keycode converter
configuration, then you are talking about EVIOCSKEYCODE, not about LIRC
or a hypothetic replacement of LIRC.  Ergo, the decision about whether
to merge LIRC or not is not blocked by this configuration interface issue.)

> Also, how do you create the devices for each remote? You would need to
> create these devices before being able to do EVIOCSKEYCODE to them.

The input subsystem creates devices on behalf of input drivers.  (Kernel
drivers, that is.  Userspace drivers are per se not affected.)

>> PS:  Drop your "specific vs. generic tools" terminology already.  Your
>> configfs based proposal requires "specific" tools as well, it's just
>> that they can be implemented in bash, among else.
> 
> The shell commands are the most generic tools in Unix.

The shell scripts are still special-purpose programs.

> udev already knows how to run shell scripts.
[...]

Udev can run any kind of program, compiled or interpreted.
-- 
Stefan Richter
-=====-==--= =-== ===--
http://arcgraph.de/sr/
