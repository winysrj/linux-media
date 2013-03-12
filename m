Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:62161 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab3CLIZS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 04:25:18 -0400
Received: by mail-ea0-f181.google.com with SMTP id z10so1531180ead.26
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2013 01:25:17 -0700 (PDT)
Subject: Re: [PATCH v2] media: i.MX27 camera: fix picture source width
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	javier Martin <javier.martin@vista-silicon.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	"Hans J. Koch" <hjk@hansjkoch.de>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1303120847480.680@axis700.grange>
References: <1360948121.29406.15.camel@mars>
	 <20130215172452.GA27113@kroah.com> <1361009964.5028.3.camel@mars>
	 <Pine.LNX.4.64.1303051845060.25837@axis700.grange>
	 <CACKLOr0smOW2cukSmeoexq3=b=dpGw=CDO3qo=gGm4+28iwb8Q@mail.gmail.com>
	 <Pine.LNX.4.64.1303120847480.680@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Mar 2013 09:25:13 +0100
Message-ID: <1363076713.3873.21.camel@mars>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2013-03-12 at 08:58 +0100, Guennadi Liakhovetski wrote:
> On Thu, 7 Mar 2013, javier Martin wrote: 

> > What mbus format are you using? Could you please check if the s_width
> > value that your sensor mt9m001 returns is correct? Remember it should
> > be in pixels, not in bytes.
> 
> Thanks for looking at this. But here's my question: for a pass-through 
> mode mx2_camera uses a 16-bpp (RGB565) format. But what if it's actually 
> an 8-bpp format, don't you then have to adjust line-width register 
> settings? If you don't do that, the camera interface would expect a double 
> number of bytes per line, so, it could get confused by HSYNC coming after 
> half-line?

To emphasize this: I'm using here a mt9m001 (monochrome) camera with an
8-bpp format.

Thanks
 -- Christoph

