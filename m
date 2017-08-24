Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:37140 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751135AbdHXHnZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 03:43:25 -0400
Subject: Re: [PATCH] [media_build] rc: Fix ktime erros in rc_ir_raw.c
To: linux-media@vger.kernel.org, Sean Young <sean@mess.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, d.scheller@gmx.net
References: <1503531988-15429-1-git-send-email-jasmin@anw.at>
 <9b070969-9422-b809-3611-648d8da0e121@anw.at>
 <93053a66-18f2-9c4f-1987-49687d8f3069@xs4all.nl>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <13836306-3ca4-4e9c-0606-be2e8d377aa5@anw.at>
Date: Thu, 24 Aug 2017 09:43:20 +0200
MIME-Version: 1.0
In-Reply-To: <93053a66-18f2-9c4f-1987-49687d8f3069@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sean!

> I agree with Jasmin here. I noticed the same errors in the daily build and it
> is really caused by not using the correct functions. I just didn't have the
> time to follow up on it.
I started to fix also gpio-ir-tx.c, but stopped that because it was too late.
So I simply deactivated the driver:
   https://www.mail-archive.com/linux-media@vger.kernel.org/msg117607.html

Maybe you can fix gpio-ir-tx.c also by using the right functions to access
ktime_t, so that this driver would be available for older Kernels, too.
But there was another problem beside the ktime_t accessors, which I didn't
analyze (symbol missing).

BR,
   Jasmin
