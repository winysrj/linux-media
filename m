Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.105.134]:22347 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab0IMMQF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 08:16:05 -0400
Subject: Re: [PATCH v9 0/4] FM Radio driver.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>
In-Reply-To: <201009131406.42719.hverkuil@xs4all.nl>
References: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <201009131351.35487.hverkuil@xs4all.nl>
	 <1284379170.12913.50.camel@masi.mnp.nokia.com>
	 <201009131406.42719.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 15:15:00 +0300
Message-ID: <1284380100.12913.57.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2010-09-13 at 14:06 +0200, ext Hans Verkuil wrote:
> On Monday, September 13, 2010 13:59:30 Matti J. Aaltonen wrote:
> > On Mon, 2010-09-13 at 13:51 +0200, ext Hans Verkuil wrote:
> > > On Monday, September 13, 2010 13:44:31 Matti J. Aaltonen wrote:
> > > > On Mon, 2010-09-13 at 13:32 +0200, ext Hans Verkuil wrote:
> > > > > > Anyway the difference between the "completely raw bits" and the "raw"
> > > > > > blocks is small. And I doubt the usefulness of supporting the
> > > > > > "completely raw" format.
> > > > > 
> > > > > I don't intend to support it now. But we need to realize that it exists and
> > > > > we have to plan for it.
> > > > 
> > > > OK. So we can have RDS_RAW_READWRITE and also RDS_RAW_BLOCK_READWRITE
> > > > (or something to the same effect)?
> > > 
> > > In theory, yes. My proposed API additions allow for this to be added in the
> > > future. Frankly, I don't think it is likely that it will be needed, but you
> > > never know.
> > 
> > Yes but I would like to add the RDS_RAW_BLOCK_READWRITE possibility
> > right away because that's what the wl1273 driver does now... I guess
> > that's OK?
> 
> Well, yeah. That's what I proposed with the new tuner caps:

OK, I didn't fully get that... sorry...

> V4L2_TUNER_CAP_RDS_READWRITE    0x0100  Use read()/write()
> V4L2_TUNER_CAP_RDS_CONTROLS     0x0200  Use RDS controls

But now I see:-)

We'll have:

V4L2_TUNER_CAP_RDS_BLOCKS     read()/write()
V4L2_TUNER_CAP_RDS_CONTROLS   RDS controls
V4L2_TUNER_CAP_RDS_RAW        also read()/write()

B.R.
Matti.



