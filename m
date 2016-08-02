Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp00.uk.clara.net ([195.8.89.33]:38488 "EHLO
	claranet-outbound-smtp00.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757021AbcHBUNr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Aug 2016 16:13:47 -0400
Date: Tue, 2 Aug 2016 21:56:29 +0200
To: Baole Ni <baolex.ni@intel.com>
Cc: Mauro Carvalho Chehab <maurochehab@gmail.com>,
	gregkh@linuxfoundation.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, amitoj1606@gmail.com, arnd@arndb.de,
	hverkuil@xs4all.nl, chuansheng.liu@intel.com
Subject: Re: [PATCH 0947/1285] Replace numeric parameter like 0444 with macro
Message-ID: <20160802195629.ojiw5vph4y2lgjup@s.cotton.clara.co.uk>
References: <20160802120134.13166-1-baolex.ni@intel.com>
 <20160802095118.47dcc5a6@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160802095118.47dcc5a6@recife.lan>
From: Steve Cotton <steve@s.cotton.clara.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 02, 2016 at 09:51:18AM -0300, Mauro Carvalho Chehab wrote:
> Em Tue,  2 Aug 2016 20:01:34 +0800 Baole Ni <baolex.ni@intel.com> escreveu:
> 
> > I find that the developers often just specified the numeric value
> > when calling a macro which is defined with a parameter for access permission.
> > As we know, these numeric value for access permission have had the corresponding macro,
> > and that using macro can improve the robustness and readability of the code,
> > thus, I suggest replacing the numeric parameter with the macro.
> 
> Gah!
> 
> A patch series with 1285 patches with identical subject!
> 
> Please don't ever do something like that. My inbox is not trash!
> 
> Instead, please group the changes per subsystem, and use different
> names for each patch. Makes easier for people to review.

Hi Baole,

It may also be worth waiting for the first group to be reviewed before
sending the other groups, in case the review comments change what you
send later.

> > -module_param(sg_mode, bool, 0644);
> > +module_param(sg_mode, bool, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);

There's an S_IRUGO macro which makes the above just 'S_IRUGO | S_IWUSR'.

Regards,
Steve
