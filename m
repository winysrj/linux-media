Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab0GaNX3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 09:23:29 -0400
Message-ID: <4C5423E1.30805@redhat.com>
Date: Sat, 31 Jul 2010 10:23:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Subject: Re: Handling of large keycodes
References: <20100731091936.GA22253@core.coreip.homeip.net>
In-Reply-To: <20100731091936.GA22253@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

Em 31-07-2010 06:19, Dmitry Torokhov escreveu:
> Hi Mauro,
> 
> I finally got a chance to review the patches adding handling of large
> scancodes to input core and there are a few things with this approach
> that I do not like.

Thanks for the review!

> First of all I do not think that we should be working with scancode via
> a pointer as it requires additional compat handling when running 32-bit
> userspace on 64-bit kernel. We can use a static buffer of sufficient
> size (lets say 32 bytes) to move scancode around and simply increase its
> size if we come upon device that uses even bigger scancodes. As long as
> buffer is at the end we can handle this in a compatible way.

Yes, this is the downside of using a pointer. I'm not aware of a Remote
Controller protocol using more than 256 bits for scancode, so 32 bits
should be ok.

> The other issue is that interface is notsymmetrical, setting is done by
> scancode but retrieval is done by index. I think we should be able to
> use both scancode and index in both operations.

Yes, this also bothered me. I was thinking to do something similar to your
approach of having a bool to select between them. This change is welcome.

> The usefulnes of reserved data elements in the structure is doubtful,
> since we do not seem to require them being set to a particular value and
> so we'll be unable to distinguish betwee legacy and newer users.

David proposed some parameters that we rejected on our discussions. As we
might need to add something similar, I decided to keep it on my approach,
since a set of reserved fields wouldn't hurt (and removing it on our discussions
would be easy), but I'm ok on removing them.

> I also concerned about the code very messy with regard to using old/new
> style interfaces instea dof converting old ones to use new
> insfrastructure,

Good cleanup at the code!

> I below is something that addresses these issues and seems to be working
> for me. It is on top of your patches and it also depends on a few
> changes in my tree that I have not publushed yet but plan on doing that
> tomorrow. I am also attaching patches converting sparse keymap and hid
> to the new style of getkeycode and setkeycode as examples.
> 
> Please take a look and let me know if I missed something important.

It seems to work for me. After you add the patches on your git tree, I'll 
work on porting the RC core to the new approach, and change the ir-keycode
userspace program to work with, in order to be 100% sure that it will work, 
but I can't foresee any missing part on it.

Currently, I'm not using my input patches, as I was waiting for your
review. I just patched the userspace application, in order to test the legacy
mode.

Cheers,
Mauro
