Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbZLAP3E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 10:29:04 -0500
Message-ID: <4B153617.8070608@redhat.com>
Date: Tue, 01 Dec 2009 16:28:23 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, jonsmirl@gmail.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com> <4B1524DD.3080708@redhat.com>
In-Reply-To: <4B1524DD.3080708@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

   Hi,

> The big issue here is: how do we document that "EM28xxHVR950-00" is the Hauppauge Grey IR that
> is shipped with their newer devices.
 >
> A third approach would be to identify, instead, the Remote Controller directly. So, we would
> add a sysfs field like ir_type.

I'd pick a more descriptive name like 'bundled_remote'.
Maybe an additional attribute could say which protocol the bundled 
remote speaks (rc5, ...), so userspace could do something sensible by 
default even if it has no data about the bundled remote.

> There are two issues here:
> 	1) What's the name for this IR? We'll need to invent names for the existing IR's, as
> those devices don't have a known brand name;

Name them by the hardware they are bundled with should work reasonable well.

> 	2) there are cases where the same device is provided with two or more different IR
> types. If we identify the board type instead of the IR type, userspace can better handle
> it, by providing a list of the possibilities.

We also could also provide a list of possible remotes directly via sysfs 
instead of expecting userspace know which remotes can come bundled with 
which board.

> No matter how we map, we'll still need to document it somehow to userspace. What would be
> the better? A header file? A set of keymaps from the default IR's that will be added
> on some directory at the Linux tree? A Documentation/IR ?

I'd suggest tools/ir/ (map loader intended to be called by udev) and the 
maps being files in the linux source tree (next to the drivers?).  The 
maps probably should be installed on some standard location (pretty much 
like firmware).

> Anyway, we shouldn't postpone lirc drivers addition due to that. There are still lots of work
> to do before we'll be able to split the tables from the kernel drivers.

Indeed.  The sysfs bits are future work for both lirc and evdev drivers. 
  There is no reason to make the lirc merge wait for it.

cheers,
   Gerd
