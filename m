Return-Path: <SRS0=PrKG=PU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82511C43387
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 09:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FFB620870
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 09:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbfALJRv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 12 Jan 2019 04:17:51 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:54152 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725816AbfALJRv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Jan 2019 04:17:51 -0500
Received: from [IPv6:2001:983:e9a7:1:e8cf:8a82:99b1:1cd8] ([IPv6:2001:983:e9a7:1:e8cf:8a82:99b1:1cd8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id iFQJgOOyjBDyIiFQKgkvJ6; Sat, 12 Jan 2019 10:17:49 +0100
Subject: Re: [GIT FIXES FOR v5.0] v4l2-ioctl: Clear only per-plane reserved
 fields
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
References: <7b7507b5-f4d1-d95b-b77b-bd7a8044a5ef@xs4all.nl>
 <20190111211010.volneg4ew4omg6ff@mara.localdomain>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f2686e34-0bee-127d-cfc5-01fb31eaf257@xs4all.nl>
Date:   Sat, 12 Jan 2019 10:17:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190111211010.volneg4ew4omg6ff@mara.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfD1cPlDji7OEdAN2aFvBBt75aCsHW9A7UqtTrlO73EM8ZXQAZJcDK0rxR83+IsaJDYrhSLWjJkgDdCBYdUZ1SsvbZGtkSCziJc72qVXTPMDBzCHfw+wQ
 +SHysvcbiyas7kJLzrFf/CQoen9F3GEtNpL5pzoxvV1mohabfRO+n+Ph8f4tkLsixmOiQ1x5Xq9e8xQTIHwXFyKW9YKhkT3i3/LfkXhlAaYrL5SZyc2GlHQe
 xBlRGc5uY0W40g4NT8FVBZIx+SGQOmhHkwJn3fv+FYrCQdt2rNw8MRZ1PX7dLvwOV1dF77upw0wXtK2m4P4MjXCl/b3PkL+WJVp3c+f/lraRHjW6eKIJmXEe
 HXkssTFe
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/11/19 10:10 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Fri, Jan 11, 2019 at 09:31:25AM +0100, Hans Verkuil wrote:
>> Three fixes for a bug introduced in 5.0.
>>
>> The last patch (Validate num_planes for debug messages) is also backported
>> to kernels >= 4.12 (the oldest kernel for which it applies cleanly).
> 
> The surrounding lines of code have changed slightly over the years. The
> older kernels still suffer from the same problem as far as I see, so the
> backport is relevant down to 3.16 at least (but older kernels aren't
> supported anyway so I didn't check further). The problem was likely
> introduced by the big IOCTL handling patches long, long time ago. Huh.
> 

I didn't plan on backporting this to older kernels. You have to be root
to enable this debugging, so it is not security bug.

Regards,

	Hans
