Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:50823 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbIOUaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 16:30:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: y2038@lists.linaro.org
Cc: Andreas Oberritter <obi@saftware.de>, linux-media@vger.kernel.org,
	linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [Y2038] [PATCH 1/7] [media] dvb: use ktime_t for internal timeout
Date: Tue, 15 Sep 2015 22:30 +0200
Message-ID: <48082122.rhhMXK7OaH@wuerfel>
In-Reply-To: <55F85B97.8000700@saftware.de>
References: <1442332148-488079-1-git-send-email-arnd@arndb.de> <1442332148-488079-2-git-send-email-arnd@arndb.de> <55F85B97.8000700@saftware.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 15 September 2015 19:55:35 Andreas Oberritter wrote:

> >  		/* show speed every SPEED_PKTS_INTERVAL packets */
> >  		if (!(demux->speed_pkts_cnt % SPEED_PKTS_INTERVAL)) {
> > -			cur_time = current_kernel_time();
> > +			cur_time = ktime_get();
> >  
> > -			if (demux->speed_last_time.tv_sec != 0 &&
> > -					demux->speed_last_time.tv_nsec != 0) {
> > -				delta_time = timespec_sub(cur_time,
> > -						demux->speed_last_time);
> > +			if (ktime_to_ns(demux->speed_last_time) == 0) {
> 
> if ktime_to_ns does what I think it does, then you should invert the logic.

Thanks for taking a critical look here, you are absolutely right, and I've
now fixed it.

	Arnd
