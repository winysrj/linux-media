Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45412 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754689AbcIESYY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 14:24:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/2] v4l: vsp1: Add HGT support
Date: Mon, 05 Sep 2016 21:24:51 +0300
Message-ID: <2200910.O8YNAjPdlI@avalon>
In-Reply-To: <CAMuHMdXLS6FpZB0CkAvO2_oMUCv1q2Lxps2vMp4Ghu43bVQp9w@mail.gmail.com>
References: <20160902134714.12224-1-niklas.soderlund+renesas@ragnatech.se> <4112113.lBOXq3Iuhk@avalon> <CAMuHMdXLS6FpZB0CkAvO2_oMUCv1q2Lxps2vMp4Ghu43bVQp9w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 05 Sep 2016 17:57:11 Geert Uytterhoeven wrote:
> On Mon, Sep 5, 2016 at 5:43 PM, Laurent Pinchart wrote:
> >> +     for (n = 0; n < 6; n++)
> > 
> > Nitpicking, the driver uses pre-increment in for loops (++n), not post-
> > increment. This used to be a best-practice rule in C++, where
> > pre-increment can be faster for non-native types (see
> > http://antonym.org/2008/05/stl-iterators-and-performance.html for
> > instance). I'm not sure if that's still relevant, but I've taken the
> > habit of using the pre-increment operator in for loops, and that's what
> > the rest of this driver does. This comment applies to all other locations
> > in this file.
> 
> <surprised>
> Didn't know we used C++ and operator overloading in the kernel...
> </surprised>

Really ? Where were you when we decided to switch to C++ ? :-)

On a more serious note, as I've explained, the *style* comes from a best 
practice rule in C++. This obviously makes no difference whatsoever in C, nor 
does it in C++ for integer types, it's only a matter of consistency with the 
rest of the driver.

-- 
Regards,

Laurent Pinchart

