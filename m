Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32786 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab3GQLtR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 07:49:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Show Liu <show.liu@linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"tom.gall@linaro.org" <tom.gall@linaro.org>,
	"t.katayama@jp.fujitsu.com" <t.katayama@jp.fujitsu.com>,
	"vikas.sajjan@linaro.org" <vikas.sajjan@linaro.org>,
	"linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH 0/2][RFC] CDFv2 for VExpress HDLCD DVI output support
Date: Wed, 17 Jul 2013 13:50:01 +0200
Message-ID: <1532548.IzIlov8vgr@avalon>
In-Reply-To: <1374058189.3146.107.camel@hornet>
References: <1374055737-6643-1-git-send-email-show.liu@linaro.org> <1374058189.3146.107.camel@hornet>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 17 July 2013 11:49:49 Pawel Moll wrote:
> On Wed, 2013-07-17 at 11:08 +0100, Show Liu wrote:
> > This series patches extend Pawel's patches to
> > Versatile Express HDLCD DVI output support.
> > Before apply this patches, please apply Pawel's patches first.
> > This series patches implements base on Linaro release 13.06 branch
> > "ll_20130621.0".
> > 
> > here is Pawel's patches
> > [1] http://lists.freedesktop.org/archives/dri-devel/2013-April/037519.html
> 
> Glad to see someone thinking the same way ;-) Thanks for trying it and
> particularly for the fixes in vexpress-* code. I'll keep them in mind
> when the time comes :-)
> 
> Of course neither the CDF patch nor the HDLCD driver are upstream yet.
> Laurent promised to post next (hopefully final ;-)

I don't think it will be the final version, but there should be no major 
change to the API after that. I still expect a couple of versions before the 
code reaches a mergeable stable, but it shouldn't take too long this time. 
Further enhancements then will likely go in as follow-up patchs.

> version of his patches soon,

Hopefully by the end of the week (which ends on Sunday, not Friday ;-)), give 
or take a couple of days.

> but the API has apparently changed so we'll have to adapt to it. As to the
> HDLCD driver - there is some work going on converting it to DRM/KMS and
> upstreaming as such, using CDF if it's available by that time as well.

-- 
Regards,

Laurent Pinchart

