Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685AbZLGPhB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2009 10:37:01 -0500
Message-ID: <4B1D2109.9090108@redhat.com>
Date: Mon, 07 Dec 2009 13:36:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc>	 <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>	 <1260070593.3236.6.camel@pc07.localdom.local>	 <20091206065512.GA14651@core.coreip.homeip.net>	 <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain> <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
In-Reply-To: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> On Sun, Dec 6, 2009 at 12:48 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
>> Once again: how about agreement about the LIRC interface
>> (kernel-userspace) and merging the actual LIRC code first? 

That's fine for me.

>> In-kernel
>> decoding can wait a bit, it doesn't change any kernel-user interface.

This may occur in parallel, but, as we've been discussing, there are
still some needs there that will require kernel-user interfaces.

> I'd like to see a semi-complete design for an in-kernel IR system
> before anything is merged from any source.

There are some tasks there that are independent of any API design.

For example, I'm currently doing some cleanups and improvements 
at the existing IR in-kernel code to create a common IR core that replaces
the already existing feature of handling 7-bits scancode/keycode table to
use the complete scancodes found at the current in-kernel drivers.

This approach works for the current drivers, as none of them currently support
any protocol that requires more than 16 bits for scancodes. However, the
current EVIOGKEYCODE implementation won't scale with bigger scancode spaces.

This code is written to be generic enough to be used by V4L, DVB and LIRC
drivers. So, after having this work done, it should be easy to connect the lirc_dev
to a decoder and to this core support. There are already some in-kernel decoders
that can be used for some protocols, but the better is to review the decoders in
the light of lirc. I expect that the lirc decoders will be in a better shape.

While I'm here, I intend also to create the sysfs bits to create sys/class/irrcv,
as already discussed and submit the patch here for discussions.

Of course, after writing different API's to control the IR tables, we'll
need to improve it, but this depends on the results of the architecture discussions.

Cheers,
Mauro
