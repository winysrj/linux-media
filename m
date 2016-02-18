Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:36185 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424395AbcBRBv5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 20:51:57 -0500
Received: by mail-lf0-f53.google.com with SMTP id 78so22878890lfy.3
        for <linux-media@vger.kernel.org>; Wed, 17 Feb 2016 17:51:56 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Thu, 18 Feb 2016 02:51:54 +0100
To: Ulrich Hecht <ulrich.hecht@gmail.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	Laurent <laurent.pinchart@ideasonboard.com>,
	hans.verkuil@cisco.com, linux-renesas-soc@vger.kernel.org
Subject: Re: [RFC/PATCH] [media] rcar-vin: add Renesas R-Car VIN IP core
Message-ID: <20160218015153.GB12338@bigcity.dyn.berto.se>
References: <1455468932-8573-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
 <CAO3366zt+O0JTGjPm1QA4VtksycAgDeVf3VzK3rWBeWXVtYdzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO3366zt+O0JTGjPm1QA4VtksycAgDeVf3VzK3rWBeWXVtYdzg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

Thanks for testing.

On 2016-02-15 12:40:12 +0100, Ulrich Hecht wrote:
> On Sun, Feb 14, 2016 at 5:55 PM, Niklas Söderlund
> <niklas.soderlund+renesas@ragnatech.se> wrote:
> > A V4L2 driver for Renesas R-Car VIN IP cores that do not depend on
> > soc_camera. The driver is heavily based on its predecessor and aims to
> > replace the soc_camera driver.
>
> Thanks a lot, this will allow me to implement HDMI input properly.
>
> One issue: With either HDMI or analog, I get a black picture using
> MMIO, while using read() works.

I will look into it. A quick test using v4l2grab I can as you say grab
frames using read but mmap hangs the tool. What tool are you using to
test?

>
> > The driver is tested on Koelsch and can grab frames using yavta.  It
> > also passes a v4l2-compliance (1.10.0) run without failures. There is
> > however a issues sometimes if one first run v4l2-compliance and then
> > yavta the grabbed frames are a bit fuzzy. I'm working on it.
>
> For the record, I have had the same problem with the old driver, but I
> was not able to reproduce it reliably.

Good to know I'm not the only one, I will see if I can fix it.
