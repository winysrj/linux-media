Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966965AbZLIA25 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 19:28:57 -0500
Message-ID: <4B1EEF40.30609@redhat.com>
Date: Tue, 08 Dec 2009 22:28:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Andy Walls <awalls@radix.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net,
	jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph>	 <20091208042210.GA11147@core.coreip.homeip.net>	 <1260275743.3094.6.camel@palomino.walls.org>	 <4B1E54FF.8060404@redhat.com>	 <9e4733910912080547j75c2c885o29664470ff5e2c6a@mail.gmail.com>	 <4B1E5BDF.7010202@redhat.com>	 <9e4733910912080619t36089c9bg5e54114844b9694a@mail.gmail.com>	 <4B1E640B.6030705@redhat.com>	 <9e4733910912080756j7e1fac32qc552c6514a307b7d@mail.gmail.com>	 <4B1E7E56.80701@redhat.com> <9e4733910912081015he8b9b63o27ee802dea7adcfc@mail.gmail.com>
In-Reply-To: <9e4733910912081015he8b9b63o27ee802dea7adcfc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:

>> I don't like the idea of automatically loading 3 different keycodes at the
>> same time. You may have overlaps between different keycode tables. The
>> better is to have some userspace GUI that will allow the user to select
>> what keycode table(s) he want to be available, if he decides to not use the
>> bundled IR.
> 
> Of course there is going to be overlap of the keycodes, but not the
> scancodes. There should be almost 100% overlap.

What prevents users to create overlaps at scancodes? We might add some
protection, but, providing that different keycode tables can be used by
different applications, why do we need to prevent it?

> The three maps are there to support a non-technical user, a
> sophisticated user will disable two of them. This works because the
> non-technical user is only going to use one of the three IR device
> profiles. The other two may be loaded, but the user isn't sending any
> IR signals that match their maps.

I doubt you can map all cases with just three profiles.

> 
> Where this breaks down is if they are using SciAtlanta_DVR to control
> MythTV and they also happen to have a physical Motorola DVR in the
> same room. 
> The Linux box is going to pick up the commands meant for
> the Motorola DVR and both boxes will respond.. In that cause they will
> need to figure figure out how to disable the Motorola DVR profile.

I used to have a Set Top Box that has some broken code to decode IR. So,
sometimes, when I used to press a key on my TV IR, the STB were getting
the code, producing a really bad result. That's really bad.

A normal user is able to click on some graphical application and
select his IR model. The app may even have some photos or pictures
representing the most used IR's. This is better than letting him to to
to some forum, asking his friends, etc, trying to figure out why his
PC is doing something wrong when he changes a channel on his TV.

> But is a non-technical person likely to have two DVRs in the same
> room?

Well, I know someone that has an 8 year old children with a setup like this: 
a PC monitor that has an IR, and a PC with a TV board also with IR.
Of course, both the monitor and the PC are at the same room.

Cheers,
Mauro.
