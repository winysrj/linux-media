Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42837 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaGVQb6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 12:31:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico <ebutera@users.sourceforge.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Enric Balletbo Serra <eballetbo@gmail.com>,
	stefan@herbrechtsmeier.net
Subject: Re: [PATCH 00/11] OMAP3 ISP BT.656 support
Date: Tue, 22 Jul 2014 18:32:05 +0200
Message-ID: <2638081.aLalCDHyz1@avalon>
In-Reply-To: <CA+2YH7vNd4kC3=82M=UhHmNcXFGxBaiLUVbSkoXRvT8tfZkfcA@mail.gmail.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com> <5099401.EbLZaQU31t@avalon> <CA+2YH7vNd4kC3=82M=UhHmNcXFGxBaiLUVbSkoXRvT8tfZkfcA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Tuesday 22 July 2014 18:26:52 Enrico wrote:
> On Tue, Jul 22, 2014 at 6:04 PM, Laurent Pinchart wrote:
> > Hi Enrico,
> > 
> > You will need to upgrade media-ctl and yavta to versions that support
> > interlaced formats. media-ctl has been moved to v4l-utils
> > (http://git.linuxtv.org/cgit.cgi/v4l-utils.git/) and yavta is hosted at
> > git://git.ideasonboard.org/yavta.git. You want to use the master branch
> > for both trees.
> 
> It seems that in v4l-utils there is no field support in media-ctl, am i
> wrong?

Oops, my bad, you're absolutely right.

> I forgot to add that i'm using yavta master and media-ctl "field"
> branch (from ideasonboard).

Could you please try media-ctl from

	git://linuxtv.org/pinchartl/v4l-utils.git field

The IOB repository is deprecated, although the version of media-ctl present 
there might work, I'd like to rule out that issue.

The media-ctl output you've posted doesn't show field information, so you're 
probably running either the wrong media-ctl version or the wrong kernel 
version.

-- 
Regards,

Laurent Pinchart

