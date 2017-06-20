Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36209 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750993AbdFTSl0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 14:41:26 -0400
Received: by mail-wr0-f193.google.com with SMTP id 77so19578954wrb.3
        for <linux-media@vger.kernel.org>; Tue, 20 Jun 2017 11:41:26 -0700 (PDT)
Date: Tue, 20 Jun 2017 20:41:21 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi,
        "Jasmin J." <jasmin@anw.at>
Subject: DD support improvements (was: Re: [PATCH v3 00/13]
 stv0367/ddbridge: support CTv6/FlexCT hardware)
Message-ID: <20170620204121.4cff42d1@macbox>
In-Reply-To: <20170620093645.6f72fd1a@vento.lan>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
        <20170412212327.5b75be19@macbox>
        <20170507174212.2e45ab71@audiostation.wuest.de>
        <20170528234537.3bed2dde@macbox>
        <20170619221821.022fc473@macbox>
        <20170620093645.6f72fd1a@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Tue, 20 Jun 2017 09:36:45 -0300
schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

Hi Mauro,

> Em Mon, 19 Jun 2017 22:18:21 +0200
> Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
> 
> > Well. From how things look, these and the cxd2841er+C2T2 ddbridge
> > support patches won't make it in time for the 4.13 merge window.  
> 
> There is time. I just merged this series today.

Oh. Well, this, together with the other series, came as a (quite
positive) surprise this morning - thank you very very much!

> The thing is that we currently have few developers working on
> DVB, and no sub-maintainers. Due to that, I need to review
> them myself, with I usually do after reviewing/applying patches
> from sub-maintainers.

Understood. Though, and please don't get me wrong - Tearing apart and
under how things in the driver, the vendor driver package, the media and
DVB subsystem aswell as kernel parts, additionally aligning the
patches/commits with all remarks from previous submissions in mind took
quite some spare time for more than a year now, getting no responses at
all honestly started to get frustrating.

> > Also, unfortunately, the original owners and/or maintainers of the
> > affected drivers (besides cxd2841er), namely stv0367 and ddbridge,
> > either are MIA or not interested in reviewing or acking this.  
> 
> Yeah, it would be great if Ralph would have some time to review
> them, or to submit a new series adding all pending features from
> DD drivers upstream.

This would of course be the way to go. OTOH, the in-kernel driver
already diverged quite a lot to that what DD publishes and maintains,
and lots of people agree this situation must be improved.

> > I have plenty of more work (patches) done, all building upon this CT
> > and C2T2 hardware support, which - together with the work Jasmin has
> > done regarding the en50221 and cxd2099 support - would finally bring
> > the in-tree ddbridge driver on par with the package Digital Devices'
> > provides, having addressed most of the critics the previous
> > attempts to bump the driver received (incremental changes which are
> > more or less easy to review, from what can be done by tearing
> > tarballs without proper changelogs apart).  
> 
> Both Jasmin and Thomas could have reviewed it, and replied
> if they tested it, and on what conditions. I tend to give
> people some time to review/test patches, before doing my
> review, as I don't usually have time for testing everything
> myself.

Not sure about Thomas, but I know that Jasmin doesn't own and/ore uses
such cards. However, for upcoming patches, I'll try to drag people to
the list for some comments, thanks for the pointer.

Speaking of patches and pending features (and generally syncing
drivers), this is what I plan to send to the list (in order, mostly
depending on each other):

- Maybe for 4.14: Support for the CineS2 V7 and FlexV4 line of
  cards/modules. This mainly involves a new demod driver (stv0910) and
  a new tuner driver (stv6111). Permissions for this are cleared with
  Ralph already. The glue code needed in ddbridge is rather easy, and
  as some ground work (mostly the MachXO2 support from the 2841 series)
  is now in, the changes are quite small. Patches are ready so far but
  need more cleanup (checkpatch fixes, camel case and such things).

- The "big" ddbridge update. I'm thinking of two ways to do this:

  * Do this in one commit, being a huge code bump, bringing ddbridge to
    version 0.9.28 (as per vendor versioning). This is mostly ready and
    successful in use by many testers and in my Gentoo ddbridge kernel
    sources overlay. Should get some more cleanups though (still some
    GTL link bits left which are not needed), and all fixes which went
    to the in-kernel driver like __user annotations need to be put back
    in. Big drawback: A mess to review.

  * Try to tear apart most if not all upstream vendor driver tar
    archives and recreate individual patches out of this. For
    reference, we need to go from what is in the kernel which is
    something inbetween v0.5 and v0.8 up to and including version
    0.9.29. I'm currently working on this from time to time, and I can
    assure you that this is an extremely tedious and unthankful thing
    to do (currently nearly done with 0.9.9b, approx. 20 releases
    left). This might be better to review, but this will also result in
    something like 100-200 commits, without guarantee of having
    everything correct.

  Reviewers will hate me for this, but I'd personally prefer the first
  option (less work, verified working on quite some installs, less
  clutter in GIT, but the drawback of reviewability).

- Last bit: DD MaxS4/S8 support. Requires another new demod driver
  (mxl5xx) and some more bits (not only glue code, but also some
  operation mode control and LNB handling) in ddbridge. Least work went
  into this so far an the mxl5xx driver code needs quite some cleanup.

Note on the ddbridge update: This is mostly code refactoring and
reorganisation, and feature-wise this is MSI interrupt and DD CI
Single/Duo Bridge support. The vendor package also carries support for
their OctoNET SATIP boxes and the DVB-C modulator support, which I
intentionally leave out. Both features require quite some DVB core API
changes which I can't argue on, but everything should be fairly easy to
add back in if desired (that said, I didn't meet anyone with such a
modulator card in the wild yet...)

If you like, I'm happy and very open to discuss this further with you!

> > (Cc Hans since you also seem to be reviewing patches)  
> 
> Hans is focused at V4L2 side.

Wasn't aware of this, sorry.

> Btw, while you're here, it would be great if you could take
> a look on those warnings (that comes via smatch):
> 
> 	drivers/media/pci/ddbridge/ddbridge-core.c:1009
> input_tasklet() warn: this loop depends on readl() succeeding
> drivers/media/pci/ddbridge/ddbridge-core.c:1353 flashio() warn: this
> loop depends on readl() succeeding
> drivers/media/pci/ddbridge/ddbridge-core.c:1373 flashio() warn: this
> loop depends on readl() succeeding

Sure, will take a peek on this.

BTW, you might have seen this - I posted four more patches which'll add
DVBv5 signal stats to the DDB part of the stv0367 code. If you don't
mind doing a quick inbetween-review of this, this would be nice if this
could go in alongside the DD support (so, for 4.13 aswell).

Thanks & best regards,
Daniel Scheller
