Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:35127 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758328AbaLKABJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 19:01:09 -0500
Message-ID: <1418256064.18092.26.camel@perches.com>
Subject: Re: [PATCH v4 1/2] staging: media: lirc: lirc_zilog.c: fix quoted
 strings split across lines
From: Joe Perches <joe@perches.com>
To: Luis de Bethencourt <luis@debethencourt.com>
Cc: m.chehab@samsung.com, jarod@wilsonet.com,
	gregkh@linuxfoundation.org, mahfouz.saif.elyazal@gmail.com,
	gulsah.1004@gmail.com, tuomas.tynkkynen@iki.fi,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Date: Wed, 10 Dec 2014 16:01:04 -0800
In-Reply-To: <20141210235741.GA10195@biggie>
References: <20141210223339.GA9397@biggie>
	 <1418254749.18092.24.camel@perches.com> <20141210235741.GA10195@biggie>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2014-12-10 at 23:57 +0000, Luis de Bethencourt wrote:
> On Wed, Dec 10, 2014 at 03:39:09PM -0800, Joe Perches wrote:
> > On Wed, 2014-12-10 at 22:33 +0000, Luis de Bethencourt wrote:
> > > diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
[]
> > > +		dev_err(tx->ir->l.dev,
> > > +			"unsupported code set file version (%u, expected 1) -- please upgrade to a newer driver",
> > > +			version);
> > 
> > Unrelated but this one should have a '\n' termination
> > at the end of the format.
> I can add that change, no problem. As part of this patch or a third one?

Up to you.


