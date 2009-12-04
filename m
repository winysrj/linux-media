Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54764 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZLDXDd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 18:03:33 -0500
Date: 05 Dec 2009 00:01:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: dmitry.torokhov@gmail.com
Cc: awalls@radix.net
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: jonsmirl@gmail.com
Cc: khc@pm.waw.pl
Cc: kraxel@redhat.com
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BEJgSGGXqgB@lirc>
In-Reply-To: <20091204220708.GD25669@core.coreip.homeip.net>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

on 04 Dec 09 at 14:07, Dmitry Torokhov wrote:
> On Fri, Dec 04, 2009 at 10:46:00PM +0100, Christoph Bartelmus wrote:
>> Hi Mauro,
>>
>> on 04 Dec 09 at 12:33, Mauro Carvalho Chehab wrote:
>>> Christoph Bartelmus wrote:
>>>>>> Consider passing the decoded data through lirc_dev.
>> [...]
>>>> Consider cases like this:
>>>> http://lirc.sourceforge.net/remotes/lg/6711A20015N
>>>>
>>>> This is an air-conditioner remote.
>>>> The entries that you see in this config file are not really separate
>>>> buttons. Instead the remote just sends the current settings for e.g.
>>>> temperature encoded in the protocol when you press some up/down key. You
>>>> really don't want to map all possible temperature settings to KEY_*
>>>> events. For such cases it would be nice to have access at the raw scan
>>>> codes from user space to do interpretation of the data.
>>>> The default would still be to pass the data to the input layer, but it
>>>> won't hurt to have the possibility to access the raw data somehow.
>>
>>> Interesting. IMHO, the better would be to add an evdev ioctl to return the
>>> scancode for such cases, instead of returning the keycode.
>>
>> That means you would have to set up a pseudo keymap, so that you can get
>> the key event which you could than react on with a ioctl. Or are you
>> generating KEY_UNKNOWN for every scancode that is not mapped?
>> What if different scan codes are mapped to the same key event? How do you
>> retrieve the scan code for the key event?
>> I don't think it can work this way.
>>

> EV_MSC/MSC_SCAN.

How would I get the 64 bit scan codes that the iMON devices generate?
How would I know that the scan code is 64 bit?
input_event.value is __s32.

BTW, I just came across a XMP remote that seems to generate 3x64 bit scan  
codes. Anyone here has docs on the XMP protocol?

Christoph
