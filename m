Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52077 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbZFJV7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 17:59:39 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC,PATCH] VIDIOC_G_EXT_CTRLS does not handle NULL pointer correctly
Date: Wed, 10 Jun 2009 23:58:31 +0200
Cc: linux-media@vger.kernel.org, nm127@freemail.hu
References: <200905251317.02633.laurent.pinchart@skynet.be> <20090610105228.3ca409ba@pedra.chehab.org> <20090610105357.14aad29f@pedra.chehab.org>
In-Reply-To: <20090610105357.14aad29f@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906102358.31879.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 10 June 2009 15:53:57 Mauro Carvalho Chehab wrote:
> Em Wed, 10 Jun 2009 10:52:28 -0300
>
> Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
> > Em Mon, 25 May 2009 11:16:34 -0300
> >
> > Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
> > > Em Mon, 25 May 2009 13:17:02 +0200
> > >
> > > Laurent Pinchart <laurent.pinchart@skynet.be> escreveu:
> > > > Hi everybody,
> > > >
> > > > Márton Németh found an integer overflow bug in the extended control
> > > > ioctl handling code. This affects both video_usercopy and
> > > > video_ioctl2. See http://bugzilla.kernel.org/show_bug.cgi?id=13357
> > > > for a detailed description of the problem.
> > > >
> > > >
> > > > Restricting v4l2_ext_controls::count to values smaller than
> > > > KMALLOC_MAX_SIZE / sizeof(struct v4l2_ext_control) should be enough,
> > > > but we might want to restrict the value even further. I'd like
> > > > opinions on this.
> > >
> > > Seems fine to my eyes, but being so close to kmalloc size doesn't seem
> > > to be a good idea. It seems better to choose an arbitrary size big
> > > enough to handle all current needs.
> >
> > I'll apply the current version, but I still think we should restrict it
> > to a lower value.
>
> Hmm... SOB is missing. Márton and Laurent, could you please sign it

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>

Cheers,

Laurent Pinchart

