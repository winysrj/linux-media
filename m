Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3AWVPu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 16:15:50 -0500
Date: Wed, 23 Jan 2013 19:00:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130123190011.502517d7@redhat.com>
In-Reply-To: <51004014.8020809@iki.fi>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<20130116152151.5461221c@redhat.com>
	<CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
	<2817386.vHx2V41lNt@f17simon>
	<20130116200153.3ec3ee7d@redhat.com>
	<CAHFNz9L-Dzrv=+Z01ndrfK3GmvFyxT6941W4-_63bwn1HrQBYQ@mail.gmail.com>
	<50F7C57A.6090703@iki.fi>
	<20130117145036.55745a60@redhat.com>
	<50F831AA.8010708@iki.fi>
	<20130117161126.6b2e809d@redhat.com>
	<50F84276.3080909@iki.fi>
	<CAHFNz9JDqYnrmNDt0_nBJMgzAymZSCXBbwY5MHR8AkMopPPQOA@mail.gmail.com>
	<20130117165037.6ed80366@redhat.com>
	<50F84CCC.5040103@iki.fi>
	<20130122101626.006d2d87@redhat.com>
	<50FFFD0B.30701@iki.fi>
	<20130123161801.764495e5@redhat.com>
	<20130123165732.0e8e74bb@redhat.com>
	<51004014.8020809@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 23 Jan 2013 21:55:00 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 01/23/2013 08:57 PM, Mauro Carvalho Chehab wrote:
> > Em Wed, 23 Jan 2013 16:18:01 -0200
> > Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
> >
> >> I'll soon post patches 1 and 2 after those changes. The remaining 4 patches
> >> don't likely need any change.
> >
> > Actually, it sounds better to just do a diff between the two versions.
> > Each individual patch on v13 is at:
> > 	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/stats_v13
> >
> > Cheers,
> > Mauro
> >
> > v13:
> > - Add post-Viterbi BER on the API
> > - Some documentation adjustments as suggested by Antti
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> For all the DVB-core related statistics API changes in that patch serie:
> 
> Reviewed-by: Antti Palosaari <crope@iki.fi>

Thanks!
> 
> 
> I have still one comment about naming:
> DTV_STAT_PRE_BIT_ERROR_COUNT   => DTV_STAT_PRE_ERROR_BIT_COUNT
> DTV_STAT_PRE_TOTAL_BIT_COUNT
> DTV_STAT_POST_BIT_ERROR_COUNT  => DTV_STAT_POST_ERROR_BIT_COUNT
> DTV_STAT_POST_TOTAL_BIT_COUNT
> DTV_STAT_ERROR_BLOCK_COUNT
> DTV_STAT_TOTAL_BLOCK_COUNT
> 
> I like to change those two. Anyway, if you think current naming is 
> better then leave as it is.

Works for me.

-- 

Cheers,
Mauro
