Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab3CLJjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 05:39:18 -0400
Date: Tue, 12 Mar 2013 10:39:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: Christoph Fritz <chf.fritz@googlemail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	"Hans J. Koch" <hjk@hansjkoch.de>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] media: i.MX27 camera: fix picture source width
In-Reply-To: <CACKLOr2oFe-ME47UV_Osme4=-7nErYts6UpE8dCAN2E2Yi+q0A@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1303121031200.680@axis700.grange>
References: <1360948121.29406.15.camel@mars> <20130215172452.GA27113@kroah.com>
 <1361009964.5028.3.camel@mars> <Pine.LNX.4.64.1303051845060.25837@axis700.grange>
 <CACKLOr0smOW2cukSmeoexq3=b=dpGw=CDO3qo=gGm4+28iwb8Q@mail.gmail.com>
 <Pine.LNX.4.64.1303120847480.680@axis700.grange> <1363076713.3873.21.camel@mars>
 <CACKLOr2oFe-ME47UV_Osme4=-7nErYts6UpE8dCAN2E2Yi+q0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 12 Mar 2013, javier Martin wrote:

> Hi Guernnadi, Christoph,
> 
> On 12 March 2013 09:25, Christoph Fritz <chf.fritz@googlemail.com> wrote:
> > On Tue, 2013-03-12 at 08:58 +0100, Guennadi Liakhovetski wrote:
> >> On Thu, 7 Mar 2013, javier Martin wrote:
> >
> >> > What mbus format are you using? Could you please check if the s_width
> >> > value that your sensor mt9m001 returns is correct? Remember it should
> >> > be in pixels, not in bytes.
> >>
> >> Thanks for looking at this. But here's my question: for a pass-through
> >> mode mx2_camera uses a 16-bpp (RGB565) format. But what if it's actually
> >> an 8-bpp format, don't you then have to adjust line-width register
> >> settings? If you don't do that, the camera interface would expect a double
> >> number of bytes per line, so, it could get confused by HSYNC coming after
> >> half-line?
> 
> You are right.
> 
> > To emphasize this: I'm using here a mt9m001 (monochrome) camera with an
> > 8-bpp format.
> 
> Ok, now that makes sense.
> 
> Then, what you should do is apply your patch conditionally so that you
> don't break other working cases:
> - Channel 1 is being used.
> - Channel 1 is in pass-through mode.

which would be

	if (!prp->in_fmt && !prp->out_fmt)

> - The sensor uses an 8-bpp format.

No, the format in unimportant - you pretend to use a 16-bit format, so, 
your "simulated" line is always bytesperline / 2 pseudo-pixels long. 
Christoph, in your next comment please add a comment something like

	/*
	 * In pass-through we configure EMMA with a 16-bpp format,
	 * set the line-width accordingly.
	 */

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
