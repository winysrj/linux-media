Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f51.google.com ([209.85.213.51]:46294 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762186Ab2FVOTy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 10:19:54 -0400
Received: by yhnn12 with SMTP id n12so1852081yhn.10
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 07:19:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1495058.aP2aaavdWk@avalon>
References: <1340029853-2648-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<CAGGh5h2NoojuguvRfQRsYx2xX1eRzXWw-sJYdnDgquWqoGbD-w@mail.gmail.com>
	<1495058.aP2aaavdWk@avalon>
Date: Fri, 22 Jun 2012 16:19:53 +0200
Message-ID: <CAGGh5h3yShG20XyUd_wkt0YKTxPV3ywGekhM2GoTMs9RFJ-7Dw@mail.gmail.com>
Subject: Re: [PATCH] omap3isp: preview: Add support for non-GRBG Bayer patterns
From: jean-philippe francois <jp.francois@cynove.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/6/22 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Jean-Philippe,
>
> On Thursday 21 June 2012 15:35:52 jean-philippe francois wrote:
>> 2012/6/18 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> > Rearrange the CFA interpolation coefficients table based on the Bayer
>> > pattern. Modifying the table during streaming isn't supported anymore,
>> > but didn't make sense in the first place anyway.
>> >
>> > Support for non-Bayer CFA patterns is dropped as they were not correctly
>> > supported, and have never been tested.
>> >
>> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> > ---
>> >  drivers/media/video/omap3isp/isppreview.c |  118 ++++++++++++++----------
>> >  1 files changed, 67 insertions(+), 51 deletions(-)
>> >
>> > Jean-Philippe,
>> >
>> > Could you please test this patch on your hardware ?
>>
>> Hi,
>>
>> I have applied it on top of your omap3isp-next branch, but my board is
>> oopsing right after the boot. I will try to get rid of this oops, but if you
>> eventually now another tree that includes the changes necessary for this
>> patch to apply, it could perhaps save me some time.
>
> The patch should apply on top of the omap3isp-omap3isp-next branch that I've
> just pushed to my linuxtv tree.
>

Turns out some work was necessary  to do to have a bootable board with
vanilla 3.4.

I successfully tested your patch on top of omap3isp-omap3isp-next
with SRGGB and SBGGR sources.

I tested it on top of your tree as it was 4 days ago, ie with
the last commit being 5472d3f17845c4....

Jean-Philippe François
