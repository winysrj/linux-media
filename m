Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:65152 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbZLDVrY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 16:47:24 -0500
Date: 04 Dec 2009 22:46:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: mchehab@redhat.com
Cc: awalls@radix.net
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: jonsmirl@gmail.com
Cc: khc@pm.waw.pl
Cc: kraxel@redhat.com
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: superm1@ubuntu.com
Message-ID: <BEFgL6sXqgB@lirc>
In-Reply-To: <4B191DD4.8030903@redhat.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

on 04 Dec 09 at 12:33, Mauro Carvalho Chehab wrote:
> Christoph Bartelmus wrote:
>>>> Consider passing the decoded data through lirc_dev.
[...]
>> Consider cases like this:
>> http://lirc.sourceforge.net/remotes/lg/6711A20015N
>>
>> This is an air-conditioner remote.
>> The entries that you see in this config file are not really separate
>> buttons. Instead the remote just sends the current settings for e.g.
>> temperature encoded in the protocol when you press some up/down key. You
>> really don't want to map all possible temperature settings to KEY_*
>> events. For such cases it would be nice to have access at the raw scan
>> codes from user space to do interpretation of the data.
>> The default would still be to pass the data to the input layer, but it
>> won't hurt to have the possibility to access the raw data somehow.

> Interesting. IMHO, the better would be to add an evdev ioctl to return the
> scancode for such cases, instead of returning the keycode.

That means you would have to set up a pseudo keymap, so that you can get  
the key event which you could than react on with a ioctl. Or are you  
generating KEY_UNKNOWN for every scancode that is not mapped?
What if different scan codes are mapped to the same key event? How do you  
retrieve the scan code for the key event?
I don't think it can work this way.

Christoph
