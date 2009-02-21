Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1455 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZBUH2w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 02:28:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Minimum kernel version supported by v4l-dvb
Date: Sat, 21 Feb 2009 08:28:50 +0100
Cc: Jean Delvare <khali@linux-fr.org>, urishk@yahoo.com,
	linux-media@vger.kernel.org
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl> <200902210212.53245.hverkuil@xs4all.nl> <20090220231350.5467116a@pedra.chehab.org>
In-Reply-To: <20090220231350.5467116a@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902210828.50666.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 21 February 2009 03:13:50 Mauro Carvalho Chehab wrote:
> On Sat, 21 Feb 2009 02:12:53 +0100
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > I think that maybe we'll need some legacy-like support for bttv and
> > > cx88, since there are some boards that relies on the old i2c method
> > > to work. On those boards (like cx88 Pixelview), the same board model
> > > (and PCB revision) may or may not have a separate audio decoder. On
> > > those devices that have an audio decoder, the widely used solution is
> > > to load tvaudio module and let it bind at the i2c bus, on such cases.
> >
> > That's what the i2c_new_probed_device() call is for (called through
> > v4l2_i2c_new_probed_subdev). You pass a list of i2c addresses that the
> > i2c core will probe for you: but this comes from the adapter driver,
> > not from the i2c module.
>
> This is a problem. The current procedure used by end users will stop
> working. It is a little worse: as the adapter driver has no means to know
> that some device could need tvaudio or other similar devices, we would
> need some hacking to allow the user to pass a parameter to the driver in
> order to test/load such drivers, since there's no documentation of when
> such things are needed.

No big deal. Yes, we have to add module options for that, and in the 
parameter description we can point to this list with the request that the 
fact that you have to set this 'autoload_tvaudio' module option is passed 
on to us so we can fix our card definitions. Easy to implement and we 
hopefully get feedback about this. Not converting is not an option as the 
autoprobe behavior will be removed by Jean (and good riddance). This is 
unrelated with backwards compatibility issues, this is a fact of life.

> > And that makes all the difference. So bttv, cx88, etc. are
> > all on my list to be converted. The drivers pvrusb2, cx18 and em28xx
> > are already being converted by Mike Isely, Andy Walls and Douglas
> > Landgraf. I'm doing usbvision and w9968cf. I have already done zoran,
> > vino and cafe_ccic which are waiting for test results. That leaves
> > bttv, cx88 and cx23885 which still need a volunteer.
>
> The worse one will be bttv. For sure there are several cases where users
> need to load the i2c modules by hand.
>
> On cx88, the only case I know is with Pixelview Ultra Pro devices. Yet, I
> dunno how to properly solve it. The manufacturer chipped a dozen of
> different boards, all of them without eeproms - so using the generic
> address - and most using the same PCB revision.
>
> I've seen models of PV ultra with Philips 1236 tuners, with Tena tuners,
> with TI-based tuners, with tvaudio and without tvaudio chips, with
> tea5767, without tea5767... There's no external indication about what's
> inside the device. All of them are branded with the same name and the
> same model number.

If you know it is this card, then you can try to probe for all of these 
devices. The good think about the new approach is that you can do these 
probes safely since they will only happen on the i2c adapter of the card in 
question, so you can make sure that no eeprom or other important devices 
are being probed that shouldn't have. In other words: you get deterministic 
behavior and control over what you are doing.

> > > > > > The only reasonable criterium I see is technical: when you
> > > > > > start to introduce cruft into the kernel just to support older
> > > > > > kernels, then it is time to cut off support to those kernels.
> > > > >
> > > > > The criteria for backport is not technical.
> > > >
> > > > That technical isn't the only criteria, I agree with. But claiming
> > > > that technical isn't a criteria at all is plain wrong. This is
> > > > equivalent to claiming that development time doesn't cost anything.
> > >
> > > Well, what's the technical criteria? I don't see much #if's inside
> > > the i2c part of the drivers.
> >
> > Look in include/media/v4l2-i2c-drv*.h and v4l2-common.c. That's why I
> > created these headers: to keep the #if's to a minimum in the actual i2c
> > modules. The -legacy variant is really bad, but when I'm done with the
> > conversion it can actually disappear, so in all fairness we can ignore
> > that header.
> >
> > But v4l2-i2c-drv.h is bad enough, and even worse is what it looks like
> > in the kernel when the compat code has been stripped from it: it's
> > turned into a completely pointless header. And all the v4l2 i2c modules
> > look peculiar as well due to that header include.
>
> IMO, we should first focus on removing the legacy code. Even on
> v4l2-common.c, we have some tricks due to legacy support. After removing
> the legacy code, I suspect that the code will be simpler to understand
> the code and to find other ways to preserve compatibility if needed. I
> suspect that just removing 2.6.22 or lower support is not enough to
> remove v4l2-i2c-drv.h.

OK, once more: there are two types of legacy code: one is that drivers have 
to be switched to use the new i2c API. That's what I've been working on all 
these months since Plumbers 2008. When all drivers that use i2c modules 
have been converted, then we can drop v4l2-i2c-drv-legacy.h and Jean can 
drop the autoprobing code in the i2c core.

The second type of legacy code is that if we want to support kernels older 
than 2.6.22, then we STILL have to support the old autoprobing model. 
That's what v4l2-i2c-drv.h and v4l2_i2c_legacy_find_client() and 
v4l2_i2c_attach() in v4l2-common.c are for. And there is no easy solution 
for this.

And yes, when support for kernels pre-2.6.22 is dropped, then all of this 
can disappear. There are still a few #ifs, but those are for the 
more 'normal' datastructure changes that happened in 2.6.26. In my reply to 
this thread on Wednesday I showed how an i2c module would look if we can 
drop support for these older kernels. Perfectly acceptable IMHO.

Please, I've been working on this together with Jean for a year or more, I 
know what I'm talking about.

> > > Maybe we should have some sort of scripts to auto-generate tarballs
> > > with backport patches inside (alsa has a model like this). They are
> > > now using -git for development, and stopped using -hg. The issue here
> > > is that we should take some time to think on how this will work, and
> > > design a set of scripts to generate the backport tree.
> >
> > As long as we intend to provide some sort of backwards compatibility we
> > will hit the same problem: for how long will you keep supporting
> > kernels? And the reason why the i2c part is so hard is that it isn't a
> > case of changed data structures or some data that's been move from one
> > place to another, but it is a complete change in the i2c model. And the
> > solutions to that end up affecting the code as it appears in the
> > kernel, and that's really bad.
>
> Eventually, things could be easier if we found better model. For example,
> a configure script could seek for a particular string on a kernel header.
> If not found, it may apply a patch, or run a parser to replace one code
> into another.
>
> This way, the development code won't have any #if's or compat code. I'm
> afraid that just using patches may also bring another range of troubles
> of needing to periodically maintain the backports. On the other hand, a
> syntax/semantic parser would be much more complex to develop.

I saw an article on lwn about the Coccinelle tool: 
http://lwn.net/Articles/315069/

I very much doubt this will be any help with this i2c problem, but for other 
transformations it may very well be useful. Unfortunately it is written in 
OCaml, in the best tradition of universities of developing a great idea but 
implementing it in an obscure programming language :-(

Regards,

	Hans

> > > I agree that we shouldn't just use -git and forget about all the
> > > users of v4l-dvb hg tree. That's why I've asked Hans to open a
> > > separate thread: in order to remove -hg, in favor of -git, we need to
> > > have some solutions to keep allowing the users to compile and test
> > > with their environments, without asking they to upgrade to the latest
> > > kernel version. So, we'll need good ideas and volunteers to
> > > implement.
> >
> > I'll write the document tomorrow (hmm, 2 AM, it's tomorrow already :-)
> > ).
>
> Ok.
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
