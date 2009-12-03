Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:38701
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZLCE3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 23:29:49 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <4B153617.8070608@redhat.com>
Date: Wed, 2 Dec 2009 23:29:39 -0500
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jonsmirl@gmail.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Content-Transfer-Encoding: 8BIT
Message-Id: <A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com>
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com> <4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Dec 1, 2009, at 10:28 AM, Gerd Hoffmann wrote:

>> Anyway, we shouldn't postpone lirc drivers addition due to that. There are still lots of work
>> to do before we'll be able to split the tables from the kernel drivers.
> 
> Indeed.  The sysfs bits are future work for both lirc and evdev drivers.  There is no reason to make the lirc merge wait for it.

At this point, my plan is to try to finish cleaning up lirc_dev and lirc_mceusb at least over the weekend while at FUDCon up in Toronto, and resubmit them next week.

I'm still on the fence over what to do about lirc_imon. The driver supports essentially 3 generations of devices. First-gen is very old imon parts that don't do onboard decoding. Second-gen is the devices that all got (insanely stupidly) tagged with the exact same usb device ID (0x15c2:0xffdc), some of which have an attached VFD, some with an attached LCD, some with neither, some that are actually RF parts, but all (I think) of which do onboard decoding. Third-gen is the latest stuff, which is all pretty sane, unique device IDs for unique devices, onboard decoding, etc.

So the lirc_imon I submitted supports all device types, with the onboard decode devices defaulting to operating as pure input devices, but an option to pass hex values out via the lirc interface (which is how they've historically been used -- the pure input stuff I hacked together just a few weeks ago), to prevent functional setups from being broken for those who prefer the lirc way.

What I'm debating is whether this should be split into two drivers, one for the older devices that don't do onboard decoding (which would use the lirc_dev interface) called 'lirc_imon' or 'lirc_imon_legacy', and one that is a pure input driver, not unlike the ati_remote{,2} drivers, with no lirc_dev dependency at all, probably called simply 'imon'. Could still be used with lirc via its devinput userspace driver, of course. But if I split it out, there may end up being a fair amount of code duplication, and the resulting lirc_imon wouldn't be as interesting to submit, and I wouldn't have any devices that worked with it, I've only got onboard decode devices... The new imon input driver would be a separate submission that is completely irrelevant to this whole discussion.

So perhaps for round three, lirc_dev, lirc_mceusb and lirc_zilog, to make it more interesting...

-- 
Jarod Wilson
jarod@wilsonet.com



