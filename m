Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:53982 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750746AbeEKVnr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 17:43:47 -0400
Subject: Re: [PATCH 7/7] Add config-compat.h override config-mycompat.h
To: Brad Love <brad@nextdimension.cc>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
 <1524763162-4865-8-git-send-email-brad@nextdimension.cc>
 <c20ac1dd-153c-5d43-f0fd-ade27c548f86@xs4all.nl>
 <777ec77a-1a1c-138b-b5ca-33201649acc7@nextdimension.cc>
 <3a039830-6ae8-406b-ede6-77553d7f45dd@anw.at>
 <412dd3a2-b48e-3068-4181-37c66d664891@nextdimension.cc>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <2e78051f-d025-6a50-e745-20baf20325b6@anw.at>
Date: Fri, 11 May 2018 23:43:41 +0200
MIME-Version: 1.0
In-Reply-To: <412dd3a2-b48e-3068-4181-37c66d664891@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Brad!

THX for this clarification!

So you tried already to fix the config_compat script and I agree with you that
it is difficult for you because of the various Kernels and distributions you
have to maintain.

Then your workaround is indeed a possibility to use media-build to build your
modules out of tree for all the combinations you have. Maybe in the future
other people may use this also.

BR,
   Jasmin
