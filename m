Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD914C282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 14:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72C122184D
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 14:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548252294;
	bh=kDSBGLX2PNkg7XL0kjBL+5Zw95l+yMEWrrVlCxIEM5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=TJ3Y3NF8jeSAcaeufYOxK4YvNYhwATPBPsIikmlDRzYOwiChaj8kpHdbHeQHElB2b
	 R6McOJBcH6lrwi9KRUFXnCMMEaVg0Co5xieZrSqzw+x3RFP5r6H4rlXyOGCvajCQZZ
	 lqD2dOIALaVzCqB/XJIA7GYNFJpBv27548g0dlaE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfAWOEt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 09:04:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726122AbfAWOEt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 09:04:49 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F05A2184D;
        Wed, 23 Jan 2019 14:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548252288;
        bh=kDSBGLX2PNkg7XL0kjBL+5Zw95l+yMEWrrVlCxIEM5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=llr4S6SFcci6gFBfEnHx+5CMT0LAoeOeuGus/QYnf8nWjlJfOR0RG8Uqru+n80KTJ
         uVKPQ2pa9ZzyTOzNZMJ0FWaFse26G2Xh0PaxdzRhwpM3xoC4MmWizAyYKaAYtAWnxj
         6wqIyJDxIMjrVXBc/Y6UZ82LyVtyf6UTswn64JtQ=
Date:   Wed, 23 Jan 2019 09:04:47 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.20 056/117] media: cedrus: don't initialize
 pointers with zero
Message-ID: <20190123140447.GK202535@sasha-vm>
References: <20190108192628.121270-1-sashal@kernel.org>
 <20190108192628.121270-56-sashal@kernel.org>
 <20190109084854.GA1743@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190109084854.GA1743@kadam>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 09, 2019 at 11:48:54AM +0300, Dan Carpenter wrote:
>This is a pure cleanup patch, it doesn't affect runtime.
>
>On Tue, Jan 08, 2019 at 02:25:24PM -0500, Sasha Levin wrote:
>> From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>>
>> [ Upstream commit e4d7b113fdccde1acf8638c5879f2a450d492303 ]
>>
>> A common mistake is to assume that initializing a var with:
>> 	struct foo f = { 0 };
>>
>> Would initialize a zeroed struct. Actually, what this does is
>> to initialize the first element of the struct to zero.
>>
>> According to C99 Standard 6.7.8.21:
>>
>>     "If there are fewer initializers in a brace-enclosed
>>      list than there are elements or members of an aggregate,
>>      or fewer characters in a string literal used to initialize
>>      an array of known size than there are elements in the array,
>>      the remainder of the aggregate shall be initialized implicitly
>>      the same as objects that have static storage duration."
>
>Static storage is initialized to zero so this is fine.  It's just
>that Sparse complains if you mix NULL and zero.

I'll drop it, thank you.

--
Thanks,
Sasha
