Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4750 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0IKMLQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 08:11:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH v9 0/4] FM Radio driver.
Date: Sat, 11 Sep 2010 14:10:55 +0200
Cc: linux-media@vger.kernel.org, eduardo.valentin@nokia.com,
	mchehab@redhat.com
References: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009111410.55149.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Monday, August 30, 2010 13:38:18 Matti J. Aaltonen wrote:
> Hi again,
> 
> and thanks for the comments.
> I've left the audio codec out of this patch set.
> 
> Hans wrote:
> > > In principle yes, but we haven't yet decided to implement those now, at
> > > the moment the RDS interpretation is left completely to user space
> > > applications.
> > 
> > Matti, is it even possible to use the current FM TX RDS API for this chip?
> > That API expects that the chip can generate the correct RDS packets based on
> > high-level data. If the chip can only handle 'raw' RDS packets (requiring a
> > userspace RDS encoder), then that API will never work.
> > 
> > But if this chip can indeed handle raw RDS only, then we need to add some
> > capability flags to signal that to userspace.
> 
> It is possible to use the current FM TX RDS API, the chip supports at least
> most of it. I just haven't implemented the support into the driver yet,
> for a multiple of reasons. I'm planning of adding that in the relatively 
> near future.
> 
> Anyhow, I've now added a way of telling that only raw RDS is supported.
> Can we use one bit it the capability field for that?

No, I don't think that is the right place. I've been thinking about this and
I realized that the V4L2_TUNER_CAP_ bits are the best place to put this (these
capability defines are reused by the modulator as well).

It is a bit unfortunate that I didn't think about it some more when the RDS
output API was made because the current V4L2_TUNER_CAP_RDS bit is now used for
two different RDS formats: for capture it means the read() interface with a
stream of v4l2_rds_data blocks and for output it means using the RDS controls.

There are also up to three ways the RDS data can be received/sent: either as
RDS blocks, or using controls, or as a completely raw bitstream. The latter is
unlikely to be used for RDS output, but a cheap RDS receiver might just do this
(and I believe these devices actually exist).

So I propose to add the following tuner capability flags:

V4L2_TUNER_CAP_RDS_READWRITE	0x0100	Use read()/write()
V4L2_TUNER_CAP_RDS_CONTROLS	0x0200	Use RDS controls

And this allows us to add a RDS_RAW_READWRITE in the future should we need it.

We do need to add these capability flags to the existing RDS drivers (there
are only a few, so that's no problem) and we need to document that for RDS
capture the READWRITE is the default if neither READWRITE or CONTROLS is set,
and that for RDS output the CONTROLS is the default in that case.

Comments?

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
