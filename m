Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:38143 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932752Ab0FQMOK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jun 2010 08:14:10 -0400
Subject: Re: [PATCH 3/4] ir-core: move decoding state to ir_raw_event_ctrl
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
In-Reply-To: <AANLkTil6P0rnmViLwpkiBOYoC6qF217V90g7Nslk3DHN@mail.gmail.com>
References: <20100424211411.11570.2189.stgit@localhost.localdomain>
	 <4BDF2B45.9060806@redhat.com> <20100607190003.GC19390@hardeman.nu>
	 <20100607201530.GG16638@redhat.com> <20100608175017.GC5181@hardeman.nu>
	 <AANLkTimuYkKzDPvtnrWKoT8sh1H9paPBQQNmYWOT7-R2@mail.gmail.com>
	 <20100609132908.GM16638@redhat.com> <20100609175621.GA19620@hardeman.nu>
	 <20100609181506.GO16638@redhat.com>
	 <AANLkTims0dmYCOoI_K4S6Q8hwLV_MqUdGQjVwFu43sCL@mail.gmail.com>
	 <20100613202945.GA5883@hardeman.nu>
	 <AANLkTim6f6jM4TGzyQsuHDNPUSsjINXFHck0NevrtqHr@mail.gmail.com>
	 <AANLkTil6P0rnmViLwpkiBOYoC6qF217V90g7Nslk3DHN@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 08:14:19 -0400
Message-ID: <1276776859.2461.16.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-06-16 at 16:41 -0400, Jarod Wilson wrote:
> On Wed, Jun 16, 2010 at 4:04 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> ...
> >> I have another suggestion, let's keep the client register/unregister
> >> callbacks for decoders (but add a comment that they're only used for
> >> lirc). Then teach drivers/media/IR/ir-raw-event.c to keep track of the
> >> raw clients so that it can pass all pre-existing clients to newly added
> >> decoders.
> >>
> >> I'll post two patches (compile tested only) in a few seconds to show
> >> what I mean.
> >
> > Consider them now runtime tested as well. They appear to do the trick,
> > the lirc bridge comes up just fine, even when ir-lirc-codec isn't
> > loaded until after mceusb. *Much* better implementation than my ugly
> > trick. I'll ack your patches and submit a series on top of them for
> > lirc support, hopefully this evening (in addition to a few other fixes
> > that aren't dependent on any of them).
> 
> A fully functional tree carrying both of David's patches and the
> entire stack of other patches I've submitted today, based on top of
> the linuxtv staging/rc branch, can be found here:
> 
> http://git.wilsonet.com/linux-2.6-ir-wip.git/?a=shortlog;h=refs/heads/patches
> 
> Also includes the lirc patches that I believe are ready to be
> submitted for actual consideration (note that they're dependent on
> David's two patches).


I'll try and play with this this weekend along with some cx23885
cleanup.

Regards,
Andy




