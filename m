Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 626B3C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F1E02084F
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552312865;
	bh=bG5OwIwmR+hWZvgbd98yC8+4/IEBpTs08HFpJD400Cs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=mfMSXfzNkknsQsR9H3L7zHadbeLLQXUgR+WQpVFj1wvd0IxKQ9LvmKgBtN2HKqedH
	 4R+005PpV+AENPebxb3KVTVFUkjSUp337ENXZKEbNAEo4WWth+SoZjn7yAJ5Y1NTq5
	 crBYuW/GGWbRG5aemmDPlwj0gIddUbuzFYgWQybM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfCKOBE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:01:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49370 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbfCKOBE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 10:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YWgxNCrQzFWE/GOh7DzDHp6oSIy8Mr8nx1l6CJf0mig=; b=oZF30fVxNRj6DfI1lyBqpEjHx
        MhLeX2uhAx1wfi/SxH7fb6+EvkxtvT+Rz4lOLaeKKssAnbDvsVnfMHJwBg6to4zgENz4w7KfqIifZ
        /xoQ3eG2Dl0AfJMWvnz8ELWVzfMlb/rfnevXShtLw9HzXaIPzFBix3LHeMgRjPFshuGO4rbSUo0mv
        wInUCYv/El41d02zi+kwTTdR8ILvNSeOTaXOZ0Q+Ks3vyZa5MOZa8KS4YJvsZYZWtNsRDNbMYmTbm
        WV7RQxDErPpSLPmdYqzWuTUuQWCOoiX+rbkDYn9PDyKNyB+7JO07W2y78Y+34lxBs58MMCx1nfg+y
        nEzwnijeA==;
Received: from [177.157.99.145] (helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h3LU7-0008JL-CY; Mon, 11 Mar 2019 14:00:58 +0000
Date:   Mon, 11 Mar 2019 11:00:52 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Sakari Ailus <sakari.ailus@iki.fi>, media-workshop@linuxtv.org,
        linux-media@vger.kernel.org
Subject: Re: [media-workshop] [ANN] Edinburgh Media Summit 2018 meeting
 report
Message-ID: <20190311110052.1a4e3f2d@coco.lan>
In-Reply-To: <20190311122914.GP4775@pendragon.ideasonboard.com>
References: <CGME20181117224556epcas4p35542fe9cdf5ee333d388ec078b12c8e8@epcas4p3.samsung.com>
        <20181117224502.63hz6sh5qd6heolu@valkosipuli.retiisi.org.uk>
        <20181212053002.3c2c2f11@coco.lan>
        <20190311112358.7k5rt7ssmbuewuln@valkosipuli.retiisi.org.uk>
        <20190311122914.GP4775@pendragon.ideasonboard.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Mon, 11 Mar 2019 14:29:14 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> > > We actually reverted it, but it caused a huge confusion and produced
> > > lots of discussions. We lost several active developers: people that
> > > were not happy by the 9000 lines patchset stepping on everyone's feet
> > > and people that were not happy by reverting it.  
> > 
> > Do you happen to remember any details? Did that "reverting" for instance
> > involve rolling back to the state before the offending patch after more
> > comments had been done?  
> 
> I'd like a more detailed version of that story too. It's hard to comment
> on this particular example without knowing what happened.

You can take a look at the lore archives in 2008. There are lots of
threads from that time related to it. There were even some discussions
at LKML. I won't myself review the past, as those were very painful
days. Unfortunately, on that time, we weren't logging the IRC discussions.
A lot of the heat happened there.

> > That said, I feel this is not overly important. The DRM folks have proved
> > this model works. Still I agree this is good to remember and document, but
> > I don't see us getting into such situation _even if_ we'd switch to a
> > similar way of working.  
> 
> Agreed. I don't think the "9000 lines revert" is relevant anymore as
> such. What matters is how to keep existing and attract new developers,
> by making the linux-media subsystem attractive and easy and pleasant to
> work with.

No. What's relevant is that we tried a multiple committers model in
the past worked fine for 3 years, but it didn't survive to the first
crisis.

I'm OK to make the subsystem more attractive, provided that we won't
do the same mistakes. So, any change should happen on baby steps, and
on a way that it won't repeat the problem where a single developer
would be able to make everybody else unhappy.

> > > > Some opined that we do not have a bottleneck in reviewing patches and
> > > > getting them merged whilst others thought this was not the case. It is
> > > > certainly true that a very large number of patches (around 500 in the last
> > > > kernel release) went in through the media tree.
> > > > 
> > > > It still appears that there
> > > > would be more patches and more drivers to get in if the throughput was
> > > > higher.  
> > > 
> > > I'm not so sure about that (if we expect good quality patches),
> > > specially while we don't have any automatic testing tool to
> > > double check some stuff.  
> > 
> > I agree. To help improving the process from here, we do need automated
> > testing. I don't think anyone has really even argued against adding
> > automated testing.  
> 
> It won't be enough though. Testing is crucial to scale, but isn't a
> substitute for review, it won't solve the review bottleneck by itself.

I agree.

> > Considering the amount of coverage in the meeting as well as the interest
> > in general, it's just a question of time until we have something quite
> > usable.
> >   
> > > As a result of those discussions, One of the things that we've agreed
> > > there is to give trees at LinuxTV for more active developers that
> > > we trust enough to skip a sub-maintainer's review.  
> 
> No, please. *Nobody* *ever* should have review bypass rights, there is
> no single exception to that rule. I fully agree we should get more
> people on-board and give them trees on linuxtv.org, but that's not about
> skipping review.

This is what it was agreed there, and it applies only to drivers, not
to the subsystem's core.

We can review such policy on a next media summit.

In any case, I take a look on all patches I receive. If I notice something
that I believe it would require sub-maintainers review, I'll forward the
pull request to a sub-maintainer.

Thanks,
Mauro
