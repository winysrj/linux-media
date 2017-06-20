Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50686
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751002AbdFTTKw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 15:10:52 -0400
Date: Tue, 20 Jun 2017 16:10:43 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi,
        "Jasmin J." <jasmin@anw.at>
Subject: Re: DD support improvements (was: Re: [PATCH v3 00/13]
 stv0367/ddbridge: support CTv6/FlexCT hardware)
Message-ID: <20170620161043.1e6a1364@vento.lan>
In-Reply-To: <20170620204121.4cff42d1@macbox>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
        <20170412212327.5b75be19@macbox>
        <20170507174212.2e45ab71@audiostation.wuest.de>
        <20170528234537.3bed2dde@macbox>
        <20170619221821.022fc473@macbox>
        <20170620093645.6f72fd1a@vento.lan>
        <20170620204121.4cff42d1@macbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 20 Jun 2017 20:41:21 +0200
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> Am Tue, 20 Jun 2017 09:36:45 -0300
> schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> Hi Mauro,
> 
> > Em Mon, 19 Jun 2017 22:18:21 +0200
> > Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
> >   
> > > Well. From how things look, these and the cxd2841er+C2T2 ddbridge
> > > support patches won't make it in time for the 4.13 merge window.    
> > 
> > There is time. I just merged this series today.  
> 
> Oh. Well, this, together with the other series, came as a (quite
> positive) surprise this morning - thank you very very much!

Anytime. Sorry again for taking a long time reviewing it.
> 
> > The thing is that we currently have few developers working on
> > DVB, and no sub-maintainers. Due to that, I need to review
> > them myself, with I usually do after reviewing/applying patches
> > from sub-maintainers.  
> 
> Understood. Though, and please don't get me wrong - Tearing apart and
> under how things in the driver, the vendor driver package, the media and
> DVB subsystem aswell as kernel parts, additionally aligning the
> patches/commits with all remarks from previous submissions in mind took
> quite some spare time for more than a year now, getting no responses at
> all honestly started to get frustrating.

Yes, I know how frustrating it can be. The real fix for this issue
would be to get more people involved on dvb. 

> > > Also, unfortunately, the original owners and/or maintainers of the
> > > affected drivers (besides cxd2841er), namely stv0367 and ddbridge,
> > > either are MIA or not interested in reviewing or acking this.    
> > 
> > Yeah, it would be great if Ralph would have some time to review
> > them, or to submit a new series adding all pending features from
> > DD drivers upstream.  
> 
> This would of course be the way to go. OTOH, the in-kernel driver
> already diverged quite a lot to that what DD publishes and maintains,
> and lots of people agree this situation must be improved.

Ralph went to a media summit we did in Germany a few years ago. At that
time, it sounded that the way to go would be to submit a new version of
the DD driver, based on upstream Kernel, and then DD start maintaining it
for both DD internal tree and Kernel one. Unfortunately, he never had 
the required time for such task.

We usually don't like this kind of change, as it is disruptive, with
regards to bug fixes, but, if we do it only once, and, after that, go
to the normal Kernel way, it could be not that bad.

> > > I have plenty of more work (patches) done, all building upon this CT
> > > and C2T2 hardware support, which - together with the work Jasmin has
> > > done regarding the en50221 and cxd2099 support - would finally bring
> > > the in-tree ddbridge driver on par with the package Digital Devices'
> > > provides, having addressed most of the critics the previous
> > > attempts to bump the driver received (incremental changes which are
> > > more or less easy to review, from what can be done by tearing
> > > tarballs without proper changelogs apart).    
> > 
> > Both Jasmin and Thomas could have reviewed it, and replied
> > if they tested it, and on what conditions. I tend to give
> > people some time to review/test patches, before doing my
> > review, as I don't usually have time for testing everything
> > myself.  
> 
> Not sure about Thomas, but I know that Jasmin doesn't own and/ore uses
> such cards. However, for upcoming patches, I'll try to drag people to
> the list for some comments, thanks for the pointer.

Yeah, if you can drag people to help reviewing/testing (and even
coding), that would be really cool, as we'll be able to better
do our reviews.

> Speaking of patches and pending features (and generally syncing
> drivers), this is what I plan to send to the list (in order, mostly
> depending on each other):
> 
> - Maybe for 4.14: Support for the CineS2 V7 and FlexV4 line of
>   cards/modules. This mainly involves a new demod driver (stv0910) and
>   a new tuner driver (stv6111). Permissions for this are cleared with
>   Ralph already. The glue code needed in ddbridge is rather easy, and
>   as some ground work (mostly the MachXO2 support from the 2841 series)
>   is now in, the changes are quite small. Patches are ready so far but
>   need more cleanup (checkpatch fixes, camel case and such things).

Please try to sync it with Ralph, in a way that his code won't
diverge from the upstream one, as this will make easier for both
sides to keep the Kernel in track with driver improvements.

> 
> - The "big" ddbridge update. I'm thinking of two ways to do this:
> 
>   * Do this in one commit, being a huge code bump, bringing ddbridge to
>     version 0.9.28 (as per vendor versioning). This is mostly ready and
>     successful in use by many testers and in my Gentoo ddbridge kernel
>     sources overlay. Should get some more cleanups though (still some
>     GTL link bits left which are not needed), and all fixes which went
>     to the in-kernel driver like __user annotations need to be put back
>     in. Big drawback: A mess to review.
> 
>   * Try to tear apart most if not all upstream vendor driver tar
>     archives and recreate individual patches out of this. For
>     reference, we need to go from what is in the kernel which is
>     something inbetween v0.5 and v0.8 up to and including version
>     0.9.29. I'm currently working on this from time to time, and I can
>     assure you that this is an extremely tedious and unthankful thing
>     to do (currently nearly done with 0.9.9b, approx. 20 releases
>     left). This might be better to review, but this will also result in
>     something like 100-200 commits, without guarantee of having
>     everything correct.

The second approach is preferred, but, as you said, it is a very
complex task, and has bad effect that, at the time you're updating
it, the DD driver will be changed.

The first approach will require some things to work, though:

- the "legacy" driver should be kept at the Kernel for some time,
  in order to provide a "fall back" for those that find issues with
  the new version;

- you'll still need to patch DD tree, as I'm pretty sure there are
  changes on the upstream driver that will need to be ported there;

- This is a very painful thing to do. While I might accept do it
  once, I won't accept repeat it again a second time. So, if we do
  that, we need to agree with you and Ralph that any change at the
  DD tree will be submitted ASAP upstream, in order to avoid future
  gaps.

>   Reviewers will hate me for this, but I'd personally prefer the first
>   option (less work, verified working on quite some installs, less
>   clutter in GIT, but the drawback of reviewability).
> 
> - Last bit: DD MaxS4/S8 support. Requires another new demod driver
>   (mxl5xx) and some more bits (not only glue code, but also some
>   operation mode control and LNB handling) in ddbridge. Least work went
>   into this so far an the mxl5xx driver code needs quite some cleanup.
> 
> Note on the ddbridge update: This is mostly code refactoring and
> reorganisation, and feature-wise this is MSI interrupt and DD CI
> Single/Duo Bridge support. The vendor package also carries support for
> their OctoNET SATIP boxes and the DVB-C modulator support, which I
> intentionally leave out. Both features require quite some DVB core API
> changes which I can't argue on, but everything should be fairly easy to
> add back in if desired (that said, I didn't meet anyone with such a
> modulator card in the wild yet...)

On the other hand, a modulator card support upstream would be a really
cool thing :-)

But yeah, that sounds a separate project.

> 
> If you like, I'm happy and very open to discuss this further with you!

Feel free to do it ;)
> 
> > > (Cc Hans since you also seem to be reviewing patches)    
> > 
> > Hans is focused at V4L2 side.  
> 
> Wasn't aware of this, sorry.
> 
> > Btw, while you're here, it would be great if you could take
> > a look on those warnings (that comes via smatch):
> > 
> > 	drivers/media/pci/ddbridge/ddbridge-core.c:1009
> > input_tasklet() warn: this loop depends on readl() succeeding
> > drivers/media/pci/ddbridge/ddbridge-core.c:1353 flashio() warn: this
> > loop depends on readl() succeeding
> > drivers/media/pci/ddbridge/ddbridge-core.c:1373 flashio() warn: this
> > loop depends on readl() succeeding  
> 
> Sure, will take a peek on this.
> 
> BTW, you might have seen this - I posted four more patches which'll add
> DVBv5 signal stats to the DDB part of the stv0367 code. If you don't
> mind doing a quick inbetween-review of this, this would be nice if this
> could go in alongside the DD support (so, for 4.13 aswell).

I intend to do more patch reviews this week. I'll try to take a look
on them.

Regards,
Mauro
