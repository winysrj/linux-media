Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60606 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaKYRRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 12:17:15 -0500
Date: Tue, 25 Nov 2014 15:17:10 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [git:media_tree/master] [media] em28xx: Add support for
 Terratec Cinergy T2 Stick HD
Message-ID: <20141125151710.60b3b658@recife.lan>
In-Reply-To: <5474B343.1070600@iki.fi>
References: <E1XtHEF-0002RQ-0i@www.linuxtv.org>
	<5474B343.1070600@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Nov 2014 18:50:11 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 11/25/2014 01:13 PM, Mauro Carvalho Chehab wrote:
> > This is an automatic generated email to let you know that the following patch were queued at the
> > http://git.linuxtv.org/media_tree.git tree:
> >
> > Subject: [media] em28xx: Add support for Terratec Cinergy T2 Stick HD
> > Author:  Olli Salonen <olli.salonen@iki.fi>
> > Date:    Mon Nov 24 03:57:34 2014 -0300
> >
> > Terratec Cinergy T2 Stick HD [eb1a:8179] is a USB DVB-T/T2/C tuner that
> > contains following components:
> >
> > * Empia EM28178 USB bridge
> > * Silicon Labs Si2168-A30 demodulator
> > * Silicon Labs Si2146-A10 tuner
> >
> > I don't have the remote, so the RC_MAP is a best guess based on the pictures of
> > the remote controllers and other supported Terratec devices with a similar
> > remote.
> >
> > [Antti: Resolved conflict caused by Leadtek VC100 patch]
> >
> > Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> > Signed-off-by: Antti Palosaari <crope@iki.fi>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> 
> Mauro, May I ask why you remove all the time my Reviewed-by tags? I have 
> added it explicitly when I do careful review for the patch. I think it 
> could be there even there is my Signed-off-by tag, which is there mainly 
> because patch was submitted via my tree (patch's delivery path).

A SOB by a non-author implies that the patch got reviewed, as otherwise
such patch won't be merged, as it doesn't make sense to forward a patch
that are known to be broken.

> 
> I cannot see any rule which says I cannot add both tags (especially 
> because meaning of both tags is bit different):
> 
> Documentation/SubmittingPatches

That documentation is for submitting patches. It doesn't describe
the process used by the drivers and subsystems maintainers.

>From time to time, people discuss about the usefulness of those
non-SOB tags, but the general consensus seems that a patch should
have just one tag from the same person.

The last one was during the last KS. See what's there at the end of
this article:
	http://lwn.net/Articles/608968/

	"The session ended with Linus jumping in and saying that,
	 in the end, the Reviewed-by, Acked-by, and Cc tags all mean
	 the same thing: the person named in the tag will be copied
	 on the report if the patch turns out to be buggy. Some
	 developers use one tag, while others use a different one,
	 but there is no real difference between them.
	 The session closed with some general disagreement over the
	 meanings of the different tags — and no new ideas on how
	 to get more review of kernel code."

Regards,
Mauro
