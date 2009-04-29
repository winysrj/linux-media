Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:2941 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752242AbZD2PPR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2009 11:15:17 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: [PATCH] uvc: Add Microsoft VX 500 webcam
Date: Wed, 29 Apr 2009 17:18:14 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <68cac7520904150003n150bff9bp616cc49e684d947d@mail.gmail.com> <200904202007.31599.laurent.pinchart@skynet.be> <20090423220525.307f1f6a@gmail.com>
In-Reply-To: <20090423220525.307f1f6a@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904291718.14608.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Douglas,

On Friday 24 April 2009 03:05:25 Douglas Schilling Landgraf wrote:
> On Mon, 20 Apr 2009 20:07:31 +0200 Laurent Pinchart wrote:
> > On Wednesday 15 April 2009 15:48:08 Douglas Schilling Landgraf wrote:
> > > On Wed, 15 Apr 2009 11:46:52 +0200 Laurent Pinchart wrote:
> > > >
> > > > The MINMAX quirk isn't required
> > > > anymore for most cameras (although the two supported Microsoft
> > > > webcams still need it, so I doubt it will work as-is).
> > >
> > > Indeed, attached new patch.
> >
> > The new patch shouldn't be needed at all, as it doesn't declare any
> > quirk. The camera should work out of the box using the latest driver.
>
> It doesn't work to me. :-(

That sounds weird. Are you telling me that your camera works when you apply 
your second patch and doesn't when you don't apply it ? I can understand that 
the first patch could be required, but the second one shouldn't make any 
difference. Make sure you removed the first before applying the second.

Best regards,

Laurent Pinchart

