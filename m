Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5527C64EB1
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 16:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F9E120700
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 16:20:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F9E120700
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbeLFQTy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 11:19:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbeLFQTy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 11:19:54 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 542FAC00297D;
        Thu,  6 Dec 2018 16:19:54 +0000 (UTC)
Received: from redhat.com (ovpn-122-74.rdu2.redhat.com [10.10.122.74])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AFBE1001F5B;
        Thu,  6 Dec 2018 16:19:53 +0000 (UTC)
Date:   Thu, 6 Dec 2018 11:19:51 -0500
From:   Jerome Glisse <jglisse@redhat.com>
To:     "Koenig, Christian" <Christian.Koenig@amd.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] dma-buf: fix debugfs versus rcu and fence dumping
Message-ID: <20181206161950.GB3544@redhat.com>
References: <20181206014103.1364-1-jglisse@redhat.com>
 <b520e7b6-a8f6-da49-fc7d-460823eabf47@amd.com>
 <20181206152116.GA3544@redhat.com>
 <4e79bf05-864e-f3ca-194c-40c4504e472a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e79bf05-864e-f3ca-194c-40c4504e472a@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 06 Dec 2018 16:19:54 +0000 (UTC)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 06, 2018 at 04:08:12PM +0000, Koenig, Christian wrote:
> Am 06.12.18 um 16:21 schrieb Jerome Glisse:
> > On Thu, Dec 06, 2018 at 08:09:28AM +0000, Koenig, Christian wrote:
> >> Am 06.12.18 um 02:41 schrieb jglisse@redhat.com:
> >>> From: Jérôme Glisse <jglisse@redhat.com>
> >>>
> >>> The debugfs take reference on fence without dropping them. Also the
> >>> rcu section are not well balance. Fix all that ...
> >>>
> >>> Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
> >>> Cc: Christian König <christian.koenig@amd.com>
> >>> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> >>> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> >>> Cc: linux-media@vger.kernel.org
> >>> Cc: dri-devel@lists.freedesktop.org
> >>> Cc: linaro-mm-sig@lists.linaro.org
> >>> Cc: Stéphane Marchesin <marcheu@chromium.org>
> >>> Cc: stable@vger.kernel.org
> >> Well NAK, you are now taking the RCU lock twice and dropping the RCU and
> >> still accessing fobj has a huge potential for accessing freed up memory.
> >>
> >> The only correct thing I can see here is to grab a reference to the
> >> fence before printing any info on it,
> >> Christian.
> > Hu ? That is exactly what i am doing, take reference under rcu,
> > rcu_unlock print the fence info, drop the fence reference, rcu
> > lock rinse and repeat ...
> >
> > Note that the fobj in _existing_ code is access outside the rcu
> > end that there is an rcu imbalance in that code ie a lonlely
> > rcu_unlock after the for loop.
> >
> > So that the existing code is broken.
> 
> No, the existing code is perfectly fine.
> 
> Please note the break in the loop before the rcu_unlock();
> >    			if (!read_seqcount_retry(&robj->seq, seq))
> >    				break; <- HERE!
> >    			rcu_read_unlock();
> >    		}
> 
> So your patch breaks that and take the RCU read lock twice.

Ok missed that, i wonder if the refcount in balance explains
the crash that was reported to me ... i sent a patch just for
that.

Thank you for reviewing and pointing out the code i was
oblivious too :)

Cheers,
Jérôme
