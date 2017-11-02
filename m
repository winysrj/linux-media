Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:46019 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbdKBEG5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 00:06:57 -0400
Received: by mail-yw0-f180.google.com with SMTP id j4so3668534ywb.2
        for <linux-media@vger.kernel.org>; Wed, 01 Nov 2017 21:06:57 -0700 (PDT)
Received: from mail-yw0-f170.google.com (mail-yw0-f170.google.com. [209.85.161.170])
        by smtp.gmail.com with ESMTPSA id e124sm983223ywc.34.2017.11.01.21.06.55
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Nov 2017 21:06:55 -0700 (PDT)
Received: by mail-yw0-f170.google.com with SMTP id q1so3663250ywh.5
        for <linux-media@vger.kernel.org>; Wed, 01 Nov 2017 21:06:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BWExq1mqAhg6z-=rRvwLh_HMdVdqPx2bGsA4cjjuyDPg@mail.gmail.com>
References: <1504115332-26651-1-git-send-email-rajmohan.mani@intel.com>
 <20170830212819.6tepof4jzdiqtezd@valkosipuli.retiisi.org.uk> <CAAFQd5BWExq1mqAhg6z-=rRvwLh_HMdVdqPx2bGsA4cjjuyDPg@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 2 Nov 2017 13:06:34 +0900
Message-ID: <CAAFQd5ASF=ZWNLMhcTLxXQ4j3pauN8Ygh77dGK19LJ=t++q2iw@mail.gmail.com>
Subject: Re: [PATCH] [media] dw9714: Set the v4l2 focus ctrl step as 1
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Rajmohan Mani <rajmohan.mani@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 2, 2017 at 1:00 PM, Tomasz Figa <tfiga@chromium.org> wrote:
> Hi Sakari,
>
> On Thu, Aug 31, 2017 at 6:28 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> Hi Rajmohan,
>>
>> On Wed, Aug 30, 2017 at 10:48:52AM -0700, Rajmohan Mani wrote:
>>> Current v4l2 focus ctrl step value of 16, limits
>>> the minimum granularity of focus positions to 16.
>>> Setting this value as 1, enables more accurate
>>> focus positions.
>>
>> Thanks for the patch.
>>
>> The recommended limit for line length is 75, not 50 (or 25 or whatever) as
>> it might be in certain Gerrit installations. :-) Please make good use of
>> lines in the future, I've rewrapped the text this time. Thanks.
>
> Has this patch been applied to your tree? I can't find it on
> linux-next or https://git.linuxtv.org/sailus/media_tree.git/ . Just
> want to make sure it doesn't get lost in action.

Okay, my bad. I didn't notice that linux-next is stuck on Oct 18 and
so doesn't include latest media tree.

I confirmed that the patch is indeed present in Mauro's master branch.
Sorry for the noise.

Best regards,
Tomasz
