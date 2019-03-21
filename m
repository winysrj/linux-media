Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1D4C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 09:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BCB4218D4
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 09:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfCUJla (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 05:41:30 -0400
Received: from gofer.mess.org ([88.97.38.141]:56675 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727946AbfCUJla (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 05:41:30 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 4BAF3616B9; Thu, 21 Mar 2019 09:41:28 +0000 (GMT)
Date:   Thu, 21 Mar 2019 09:41:28 +0000
From:   Sean Young <sean@mess.org>
To:     Gregor Jasny <gjasny@googlemail.com>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        CHEMLA Samuel <chemla.samuel@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [Bug report] dvbv5-zap crash dvb-tool ARMHF builds
Message-ID: <20190321094127.ysurm4u26zugmnmv@gofer.mess.org>
References: <f4b69417-06c3-f9ab-2973-ae23d76088b8@gmail.com>
 <29bad771-843c-1dee-906c-6e9475aed7d8@gmail.com>
 <d291e164-993f-232a-f01b-0f8c17087004@googlemail.com>
 <20190315223425.hiq3qcjhjnirsizh@gofer.mess.org>
 <20190317065242.137cb095@coco.lan>
 <20190319164507.7f95af89@coco.lan>
 <a1f296ba-3c27-ed2c-3912-4edbeeb21eba@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1f296ba-3c27-ed2c-3912-4edbeeb21eba@googlemail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Mar 20, 2019 at 08:38:52PM +0100, Gregor Jasny wrote:
> Hello Mauro,
> 
> On 19.03.19 20:45, Mauro Carvalho Chehab wrote:
> > Hi Gregor,
> > 
> > Samuel reported in priv that the issues he had with user after free were
> > solved by the patchsets merged at 1.12 and 1.16 stable branches.
> > 
> > Could you please generate a new staging release for them?
> 
> Sure, I can create a new 1.12 and 1.16 stable release. But when reviewing
> the patches for approval by debian release managers I noticed an additional
> double-free that Sean addressed with the following patch:
> 
> > https://git.linuxtv.org/v4l-utils.git/commit/?id=ebd890019ba7383b8b486d829f6683c8f49fdbda
> 
> Could you please give that patch a thorough review, some testing, and
> cherry-pick it to stable-1.12 and -1.16 as well?

I did test it myself (and also under valgrind). The bad paths are hard
to hit though. I'd say just go ahead with merging and releasing, the patch
isn't that controversial (I hope!).


Sean
