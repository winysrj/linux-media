Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41434 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab1IFLaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 07:30:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [media-ctl][PATCHv5 1/5] libmediactl: restruct error path
Date: Tue, 6 Sep 2011 13:30:10 +0200
Cc: linux-media@vger.kernel.org
References: <201109051657.21646.laurent.pinchart@ideasonboard.com> <1315305971.28628.11.camel@smile> <1315306225.28628.13.camel@smile>
In-Reply-To: <1315306225.28628.13.camel@smile>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109061330.11123.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Tuesday 06 September 2011 12:50:25 Andy Shevchenko wrote:
> On Tue, 2011-09-06 at 13:46 +0300, Andy Shevchenko wrote:
> > On Tue, 2011-09-06 at 12:25 +0200, Laurent Pinchart wrote:
> > > I've slightly modified 1/5 and 3/5 (the first one returned -1 from
> > > media_enum_entities(), which made media-ctl stop with a failure
> > > message) and pushed the result to the repository.
> > 
> > Okay. I looked at them.
> > One minor comment: udef_unref is aware of NULL.

I wasn't aware of that, thanks.

> Ah, and another. I don't get why you split snprintf() to that suboptimal
> strncpy + x[sizeof(x)-1] = 0?

snprintf needs to parse the format argument, is strncpy really suboptimal ?

-- 
Regards,

Laurent Pinchart
