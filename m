Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:32818 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbbETJBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 05:01:40 -0400
Date: Wed, 20 May 2015 06:01:33 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] [media] rc: lirc is not a protocol or a keymap
Message-ID: <20150520060133.5b2846ae@recife.lan>
In-Reply-To: <5b14c3fee1ee0a553db5dac7b01fbf0a@hardeman.nu>
References: <cover.1426801061.git.sean@mess.org>
	<2a2f4281ba60988242c11bdf2fda3243e2dc4467.1426801061.git.sean@mess.org>
	<20150514135123.4ba85dc7@recife.lan>
	<20150519203442.GB18036@hardeman.nu>
	<20150520051923.7cefe112@recife.lan>
	<5b14c3fee1ee0a553db5dac7b01fbf0a@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 20 May 2015 10:49:34 +0200
David Härdeman <david@hardeman.nu> escreveu:

> On 2015-05-20 10:19, Mauro Carvalho Chehab wrote:
> > Em Tue, 19 May 2015 22:34:42 +0200
> > David Härdeman <david@hardeman.nu> escreveu:
> > 
> >> On Thu, May 14, 2015 at 01:51:23PM -0300, Mauro Carvalho Chehab wrote:
> >> >Em Thu, 19 Mar 2015 21:50:15 +0000
> >> >Sean Young <sean@mess.org> escreveu:
> >> >
> >> >> Since the lirc bridge is not a decoder we can remove its protocol. The
> >> >> keymap existed only to select the protocol.
> >> >
> >> >This changes the userspace interface, as now it is possible to enable/disable
> >> >LIRC handling from a given IR via /proc interface.
> > 
> > I guess I meant to say: "as now it is not possible"
> > 
> >> I still like the general idea though.
> > 
> > Yeah, LIRC is not actually a decoder, so it makes sense to have it
> > handled differently.
> > 
> >> If we expose the protocol in the
> >> set/get keymap ioctls, then we need to expose the protocol enum to
> >> userspace (in which point it will be set in stone)...removing lirc 
> >> from
> >> that list before we do that is a worthwhile cleanup IMHO (I have a
> >> similar patch in my queue).
> >> 
> >> I think we should be able to at least not break userspace by still
> >> accepting (and ignoring) commands to enable/disable lirc.
> > 
> > Well, ignoring is not a good idea, as it still breaks userspace, but
> > on a more evil way. If one is using this feature, we'll be receiving
> > bug reports and fixes for it.
> 
> I disagree it's more "evil" (or at least I fail to see how it would be). 

Because the Kernel would be lying to userspace. If one tells the Kernel to
disable something, it should do it, or otherwise return an error explaining
why disabling was not possible.

> Accepting but ignoring "lirc" means that the same commands as before 
> will still be accepted (so pre-existing userspace scripts won't have to 
> change which they would if we made "lirc" an invalid protocol to echo to 
> the sysfs file).

Yes, but, if someone is trying to disable lirc, it is doing for some
reason. The script won't fail, but his application will.

> And saying that the change will "break" userspace is still something of 
> a misnomer. You'd basically expect userspace to open /sys/blabla, write 
> "-lirc" (which would disable the lirc output but the device node is 
> still in /dev), then later open /dev/lircX and be surprised that it's 
> still receiving lirc events on the lirc device it just opened? I think 
> that's a rather artificial scenario...

Well, lircd is a daemon. I can easily an usecase where some application
would like to prevent it to be running because such application would
read the RC codes directly from input/dev.

I'm not arguing that this is the best way of doing that (nor I have
myself any such usecases), but if some app relies on such behavior, then
this is an userspace breakage.

> >> That lirc won't actually be disabled/enabled is (imho) a lesser
> >> problem...is there any genuine use case for disabling lirc on a
> >> per-device basis?
> > 
> > People do weird things sometimes. I won't doubt that someone would
> > be doing that.
> > 
> > In any case, keep supporting disabling LIRC is likely
> > simple, even if we don't map it internally as a protocol anymore.
> 
> I could write a different patch that removes the protocol enum but still 
> allows lirc to be disabled/enabled. I doubt it'll be that simple though 
> (ugly hack rather), and I still don't see the benefits of doing so (or 
> downsides or "breakage" of not doing it).
> 
> Another option would be to commit the change a see if anyone screams (I 
> very much doubt it).

It may take months for people to discover, as it will only reach userspace
after distros merge the patch on their Kernel. Not nice. We should avoid
doing things like that.

Regards,
Mauro
