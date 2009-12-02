Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbZLBUyp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Dec 2009 15:54:45 -0500
Message-ID: <4B16D3FC.6070702@redhat.com>
Date: Wed, 02 Dec 2009 18:54:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	superm1@ubuntu.com, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com>	 <20091201175400.GA19259@core.coreip.homeip.net>	 <4B1567D8.7080007@redhat.com>	 <20091201201158.GA20335@core.coreip.homeip.net>	 <4B15852D.4050505@redhat.com>	 <20091202093803.GA8656@core.coreip.homeip.net>	 <4B16614A.3000208@redhat.com>	 <20091202171059.GC17839@core.coreip.homeip.net>	 <9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com>	 <20091202182329.GA20530@core.coreip.homeip.net> <9e4733910912021057s3e4ec06an906e3fb0d32aa301@mail.gmail.com>
In-Reply-To: <9e4733910912021057s3e4ec06an906e3fb0d32aa301@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> Some major use cases:
> using IR as a keyboard replacement, controlling X and apps with it in
> via mouse and keyboard emulation.
> using IR to control a headless embedded device possibly running
> multiple apps - like audio and home automation (my app)
> IR during boot when it is the only input device the box has.
> multifunction remote controlling several apps
> using several different remotes to control a single app

I think you reasonably described the major usecases.

>>> If everyone hates configfs the same mapping can be done via the set
>>> keys IOCTL and making changes to the user space apps like loadkeys.
>>>
>> It is not the hate of configfs per se, but rather concern that configfs
>> takes too much resources and is not normally enabled.
> 
> It adds about 35K on 64b x86. 30K on 32b powerpc. If it gets turned on
> by default other subsystems might start using it too. I work on an
> embedded system. These arguments about non-swapable vs swapable are
> pointless. Embedded systems don't have swap devices.

> Of course config can be eliminated by modifying the setkeys IOCTL and
> user space tools. It will require some more mods to input to allow
> multiple maps monitoring the input stream and splitting them onto
> multiple evdev devices. This is an equally valid way of building the
> maps.
> 
> The code I posted is just demo code. It is clearly not in shape to be
> merged. Its purpose was to spark a design discussion around creating a
> good long-term architecture for IR.

Unfortunately, afaik, most distros don't enable configfs yet. I have to
manually compile my kernel when I need some useful stuff there.

I agree with Dmitry: IR is probably not enough to have this enabled by
default on distros. I prefer a more traditional approach like ioctls 
(and/or sysfs) instead of configfs.

Cheers,
Mauro.
