Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:61543 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbZLBT4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 14:56:35 -0500
Date: Wed, 2 Dec 2009 11:56:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	superm1@ubuntu.com, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
Message-ID: <20091202195634.GB22689@core.coreip.homeip.net>
References: <4B155288.1060509@redhat.com> <20091201175400.GA19259@core.coreip.homeip.net> <4B1567D8.7080007@redhat.com> <20091201201158.GA20335@core.coreip.homeip.net> <4B15852D.4050505@redhat.com> <20091202093803.GA8656@core.coreip.homeip.net> <4B16614A.3000208@redhat.com> <20091202171059.GC17839@core.coreip.homeip.net> <9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com> <4B16BE6A.7000601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B16BE6A.7000601@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 02, 2009 at 02:22:18PM -0500, Jarod Wilson wrote:
> On 12/2/09 12:30 PM, Jon Smirl wrote:
>>>>> (for each remote/substream that they can recognize).
>>>> >>
>>>> >>  I'm assuming that, by remote, you're referring to a remote receiver (and not to
>>>> >>  the remote itself), right?
>>> >
>>> >  If we could separate by remote transmitter that would be the best I
>>> >  think, but I understand that it is rarely possible?
> >
>> The code I posted using configfs did that. Instead of making apps IR
>> aware it mapped the vendor/device/command triplets into standard Linux
>> keycodes.  Each remote was its own evdev device.
>
> Note, of course, that you can only do that iff each remote uses distinct  
> triplets. A good portion of mythtv users use a universal of some sort,  
> programmed to emulate another remote, such as the mce remote bundled  
> with mceusb transceivers, or the imon remote bundled with most imon  
> receivers. I do just that myself.
>
> Personally, I've always considered the driver/interface to be the  
> receiver, not the remote. The lirc drivers operate at the receiver  
> level, anyway, and the distinction between different remotes is made by  
> the lirc daemon.

The fact that lirc does it this way does not necessarily mean it is the
most corerct way. Do you expect all bluetooth input devices be presented
as a single blob just because they happen to talk to the sane receiver
in yoru laptop? Do you expect your USB mouse and keyboard be merged
together just because they end up being serviced by the same host
controller? If not why remotes should be any different?

Now I understand that if 2 remotes send completely identical signals we
won't be able to separete them, but in cases when we can I think we
should.

-- 
Dmitry
