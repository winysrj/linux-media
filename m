Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39207 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaJCKwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Oct 2014 06:52:13 -0400
Date: Fri, 3 Oct 2014 07:52:06 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "AreMa Inc." <info@are.ma>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: [PATCH] pt3 (pci, tc90522, mxl301rf, qm1d1c0042):
 pt3_unregister_subdev(), pt3_unregister_subdev(), cleanups...
Message-ID: <20141003075206.331006bd@recife.lan>
In-Reply-To: <CAKnK8-QOU7szWNcC1BsBZtNmHBLiLqZuCVYpjsVBkpfNCxGa-A@mail.gmail.com>
References: <1412275758-31340-1-git-send-email-knightrider@are.ma>
	<542E2BF6.2090800@iki.fi>
	<CAKnK8-QOU7szWNcC1BsBZtNmHBLiLqZuCVYpjsVBkpfNCxGa-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 03 Oct 2014 14:45:19 +0900
"AreMa Inc." <info@are.ma> escreveu:

> Mauro & Antti
> 
> Please drop & replace Tsukada's PT3 patches.

It doesn't work like that. We don't simply drop a driver and replace by
some other one.

The way most open source project works with regards to patch reviewing
process work is via lazy consensus. The maintainer could, of course,
override it, but this is only done on exceptional cases and when there
is a strong reason for doing that.

The lazy consensus works like that: someone publish a patch at a public
mailing list. During a reasonable amount of time, everybody that
participates at the community can review the patch, and submit their
review publicly. After that time, it is assumed that everybody was happy
with the patch. The maintainers will then take it and merge.

The PT3 patches are floating around for at least 2 merge windows, with is
a more than reasonable time. There were requests to change some bad things
there, to split the big patches into a series of patches, etc. All of them
were satisfied. So, as everybody lazily agreed with the code, it got merged.

In other words, if you had anything against the merge of the PT3 driver,
you should have manifested before the merge during the ~2 months that this
was discussed, and not after that.

Yet, if the driver is not fully functional or if it have some issues, we do
accept and we do want incremental patches fixing it. Of course, those changes
should be properly described. The patch descriptions should answer three
questions:
	- What each patch is doing;
	- Why that patch is needed;
	- How the change was done.

As Antti stated, those incremental patches should be done with one logical
change per patch. That will allow us to better understand what's happening.

In other words, you could, for example, send us a patch inside a series that
would be doing (from your previous patch):
	- lightweight & yet precise CNR calculus

Such patch should look like:

Subject: pt3: improve and cleanup CNR calculus
From: your real name <your@email>

The current code uses a too complex logic to do CNR calculus.
Simplify the logic by doing ....
That keeps the CNR calculus precise, but makes the calculus
(quicker|easier to read|...).

Signed-off-by: your real name <your@email>

Please read what's written on our Wiki for more details, at:
	http://linuxtv.org/wiki/index.php/Developer_Section
Starting with:
	http://linuxtv.org/wiki/index.php/Development:_Submitting_Patches

> There are too many weird & violating codes in it.

You need to provide us a way more detailed descriptions than just the
above statement, as the above example

E. g.: What is weird and where? What's being violated and where? What
you're proposing to solve it?

Regards,
Mauro

> 
> Thanks
> -Bud
> 
> 
> 2014-10-03 13:54 GMT+09:00 Antti Palosaari <crope@iki.fi>:
> > On 10/02/2014 09:49 PM, Буди Романто, AreMa Inc wrote:
> >>
> >> DVB driver for Earthsoft PT3 PCIE ISDB-S/T receiver
> >> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >>
> >> Status: stable
> >>
> >> Changes:
> >> - demod & tuners converted to I2C binding model
> >> - i586 & x86_64 clean compile
> >> - lightweight & yet precise CNR calculus
> >> - raw CNR (DVBv3)
> >> - DVBv5 CNR @ 0.0001 dB (ref: include/uapi/linux/dvb/frontend.h, not
> >> 1/1000 dB!)
> >> - removed (unused?) tuner's *_release()
> >> - demod/tuner binding: pt3_unregister_subdev(), pt3_unregister_subdev()
> >> - some cleanups
> >
> >
> > These drivers are already committed, like you have noticed. There is surely
> > a lot of issues that could be improved, but it cannot be done by big patch
> > which replaces everything. You need to just take one issue at the time,
> > fix/improve it, send patch to mailing list for review. One patch per one
> > logical change.
> >
> > regards
> > Antti
> >
> > --
> > http://palosaari.fi/
