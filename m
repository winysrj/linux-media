Return-path: <mchehab@localhost.localdomain>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4912 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab0IMLch (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 07:32:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: matti.j.aaltonen@nokia.com
Subject: Re: [PATCH v9 0/4] FM Radio driver.
Date: Mon, 13 Sep 2010 13:32:15 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>
References: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com> <201009111410.55149.hverkuil@xs4all.nl> <1284375031.12913.35.camel@masi.mnp.nokia.com>
In-Reply-To: <1284375031.12913.35.camel@masi.mnp.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131332.15287.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

On Monday, September 13, 2010 12:50:31 Matti J. Aaltonen wrote:
> On Sat, 2010-09-11 at 14:10 +0200, ext Hans Verkuil wrote:
> > There are also up to three ways the RDS data can be received/sent: either as
> > RDS blocks, or using controls, or as a completely raw bitstream. The latter is
> > unlikely to be used for RDS output, but a cheap RDS receiver might just do this
> > (and I believe these devices actually exist).
> 
> I thought that the "raw" mode meant reading and writing (uninterpreted)
> RDS blocks. At least that's what the wl1273 chip does and that was what
> I meant. Is there already a way to deal with this case?

I had to dig into the linux-media archives, but I found one chip (the cx2388x)
that produces a 38 kHz 16 bit RDS data stream that needs to be demodulated in
software. That's really raw :-) But I'm not aware of any board based on this
chipset that actually uses this.

> Anyway the difference between the "completely raw bits" and the "raw"
> blocks is small. And I doubt the usefulness of supporting the
> "completely raw" format.

I don't intend to support it now. But we need to realize that it exists and
we have to plan for it.

Regards,

	Hans

> 
> B.R.
> Matti
> 
> > So I propose to add the following tuner capability flags:
> > 
> > V4L2_TUNER_CAP_RDS_READWRITE	0x0100	Use read()/write()
> > V4L2_TUNER_CAP_RDS_CONTROLS	0x0200	Use RDS controls
> > 
> > And this allows us to add a RDS_RAW_READWRITE in the future should we need it.
> > 
> > We do need to add these capability flags to the existing RDS drivers (there
> > are only a few, so that's no problem) and we need to document that for RDS
> > capture the READWRITE is the default if neither READWRITE or CONTROLS is set,
> > and that for RDS output the CONTROLS is the default in that case.
> > 
> > Comments?
> > 
> > 	Hans
> > 
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
