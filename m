Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:48117 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbeBDW4V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Feb 2018 17:56:21 -0500
Subject: Re: [PATCH] media: uvcvideo: Fixed ktime_t to ns conversion
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@s-opensource.com, arnd@arndb.de
References: <1515925303-5160-1-git-send-email-jasmin@anw.at>
 <1778442.ouJt2D3mk7@avalon> <f2e313c8-6013-bd1b-09da-8fa4fc12814e@anw.at>
 <2251976.ODMGCFTTdz@avalon>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <c170e24a-2c78-c514-b4bc-ed944d45d6c7@anw.at>
Date: Sun, 4 Feb 2018 23:56:14 +0100
MIME-Version: 1.0
In-Reply-To: <2251976.ODMGCFTTdz@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> Strictly speaking, building the media subsystem on older kernels is a job of 
> the media build system.
Yes I agree.

> In general I would thus ask for the fix to be merged in media-build.git.
Which I do mostly, but in this case it is a coding error in mainline. 

> In this specific case, as the mainline code uses both u64 and ktime_t types,
> I'm fine with merging your patch to use explicit conversion functions in
> mainline even if the two types are now equivalent.
We had this already with other drivers and changes for ktime_t. In fact you
should always use the macro accessors. We don't know what will be changed in
the future with ktime_t, so using the macros -- on all places -- is save for
the future also. And using the macro accessors is automatically backward
compatible also.

> However, as this doesn't fix a bug in the mainline kernel, I don't think this
> patch is a candidate for stable releases, and should thus get merged in v4.17.
I am fine with this.

> It can also be included in media-build.git in order to build kernels that
> currently fail.
I just sent a temporary fix for media-build.
media-build works always with the latest media.git. So once it is merged, the
temporary fix can be removed again.

BR,
   Jasmin
