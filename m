Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbZCZJyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 05:54:43 -0400
Date: Thu, 26 Mar 2009 06:54:36 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: vasaka@gmail.com
Cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: patchwork tool
Message-ID: <20090326065436.7f22af82@pedra.chehab.org>
In-Reply-To: <36c518800903260222j2ae177e9g9d3ad5f5b9d8d37d@mail.gmail.com>
References: <36c518800903251619j371b31bbyb6731d26c1357a34@mail.gmail.com>
	<20090326053409.6a310c6a@pedra.chehab.org>
	<36c518800903260222j2ae177e9g9d3ad5f5b9d8d37d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 26 Mar 2009 11:22:26 +0200
vasaka@gmail.com wrote:

> On Thu, Mar 26, 2009 at 10:34 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > On Thu, 26 Mar 2009 01:19:08 +0200
> > vasaka@gmail.com wrote:
> >
> >> Hello,
> >>
> >> how should I format my post in order to patchwork tool understand
> >> included patch correctly,
> >
> > If patchwork is not adding your patches there, then it means that the patches
> > are broken (for example, line-wrapped), or that you're attaching it, and your
> > emailer are using the wrong mime encoding type for diffs.
> >
> >> should I just format it like in v4l-dvb/README.patches described?
> >> then how should I add additional comments to the mail which I do not
> >> want to be in the patch log?
> >
> > All comments you add on your patch will be part of the commit message (except
> > for the meta-tags, like from:).
> >
> >> It seems it is possible without special comment symbols.
> >
> >
> > Cheers,
> > Mauro
> >
> 
> can it be that patch made by
> $diff -uprN v4l-dvb.orig v4l-dvb.my > patch.patch
> and make commit in .my tree did not complain still broken?
> 
> does gmail's web interface plain text mail composer has known issues,
> which can interfere with sending patches?

I never used a web interface to send patches. Since patches should be sent
inline, and such interfaces do line wrapping, they aren't good for patch
submission. 

Also, probably, they'll encode the attachments with text/plain or
application/octet-stream, instead of the proper text/x-patch mime type.

Cheers,
Mauro
