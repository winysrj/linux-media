Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail12.sea5.speakeasy.net ([69.17.117.14]:59940 "EHLO
	mail12.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758108AbZC0VMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 17:12:46 -0400
Date: Fri, 27 Mar 2009 14:12:44 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?iso-8859-1?q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l2: fill reserved fields of VIDIOC_ENUMAUDIO also
In-Reply-To: <200903272134.07576.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903271406080.28292@shell2.speakeasy.net>
References: <49CA611B.5050902@freemail.hu> <20090327131729.0842bdec@pedra.chehab.org>
 <Pine.LNX.4.58.0903271241360.28292@shell2.speakeasy.net>
 <200903272134.07576.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Mar 2009, Hans Verkuil wrote:
> On Friday 27 March 2009 20:45:40 Trent Piepho wrote:
> > On Fri, 27 Mar 2009, Mauro Carvalho Chehab wrote:
> > > On Wed, 25 Mar 2009 17:51:39 +0100
> > >
> > > Németh Márton <nm127@freemail.hu> wrote:
> > > > From: Márton Németh <nm127@freemail.hu>
> > > >
> > > > When enumerating audio inputs with VIDIOC_ENUMAUDIO the gspca_sunplus
> > > > driver does not fill the reserved fields of the struct v4l2_audio
> > > > with zeros as required by V4L2 API revision 0.24 [1]. Add the missing
> > > > initializations to the V4L2 framework.
> > > >
> > > > The patch was tested with v4l-test 0.10 [2] with gspca_sunplus driver
> > > > and with Trust 610 LCD POWERC@M ZOOM webcam.
> > >
> > > It didn't apply against the development tree. Anyway, a recent patch
> > > removed the need of memset there. the memory fill with zero now happens
> > > at the same code we copy the structure values.
> >
> > That code is in video_ioctl2, which gspca doesn't use.
>
> Yes, gspca does use video_ioctl2. You're probably confused with uvcvideo,
> which doesn't use it.

You're right, I was thinking about Németh's earlier patches for the same
things in uvcvideo.  This patch wasn't for gspca anyway, it was for the
v4l2 core, and Mauro's right it's not necessary as my patch series fixed
all these problems.
