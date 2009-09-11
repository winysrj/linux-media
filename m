Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3871 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZIKWZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 18:25:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: RFCv2: Media controller proposal
Date: Sat, 12 Sep 2009 00:25:13 +0200
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <200909100913.09065.hverkuil@xs4all.nl> <200909112215.15155.hverkuil@xs4all.nl> <20090911183758.31184072@caramujo.chehab.org>
In-Reply-To: <20090911183758.31184072@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909120025.13623.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 11 September 2009 23:37:58 Mauro Carvalho Chehab wrote:
> Em Fri, 11 Sep 2009 22:15:15 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Friday 11 September 2009 21:59:37 Mauro Carvalho Chehab wrote:
> > > Em Fri, 11 Sep 2009 21:23:44 +0200
> > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > > 
> > > > > In the case of resizer, I don't see why this can't be implemented as an ioctl
> > > > > over /dev/video device.
> > > > 
> > > > Well, no. Not in general. There are two problems. The first problem occurs if
> > > > you have multiple instances of a resizer (OK, not likely, but you *can* have
> > > > multiple video encoders or decoders or sensors). If all you have is the
> > > > streaming device node, then you cannot select to which resizer (or video
> > > > encoder) the ioctl should go. The media controller allows you to select the
> > > > recipient of the ioctl explicitly. Thus providing the control that these
> > > > applications need.
> > > 
> > > This case doesn't apply, since, if you have multiple encoders and/or decoders,
> > > you'll also have multiple /dev/video instances. All you need is to call it at
> > > the right device you need to control. Am I missing something here?
> > 
> > Typical use-case: two video decoders feed video into a composer that combines
> > the two (e.g. for PiP) and streams the result to one video node.
> > 
> > Now you want to change e.g. the contrast on one of those video decoders. That's
> > not going to be possible using /dev/video.
> 
> On your above example, each video decoder will need a /dev/video, and also the
> video composer. 

Why? The video decoders do not do any streaming. There may well be just one
DMA engine that DMAs the output from the video composer.

Regards,

	Hans



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
