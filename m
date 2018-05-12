Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:41393 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750756AbeELJb1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 05:31:27 -0400
Subject: Re: [PATCH 2/7] Disable additional drivers requiring gpio/consumer.h
To: Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
 <1524763162-4865-3-git-send-email-brad@nextdimension.cc>
From: "Jasmin J." <jasmin@anw.at>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e8d69388-3e47-eeaf-840d-5464fc6c8dc5@anw.at>
Date: Sat, 12 May 2018 11:31:23 +0200
MIME-Version: 1.0
In-Reply-To: <1524763162-4865-3-git-send-email-brad@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Brad!

Tonight build broke due to patch 95ee4c285022!
You enabled VIDEO_OV2685 for 3.13., which doesn't
compile for Kernels older than 3.17. When you look
to the Kernel 3.17 section a lot of the drivers you
enabled for 3.13 with your patch should be enabled
for 3.17 only.

So please test this and provide a follow up patch.
I will not revert 95ee4c285022 now, except you can't
fix it in a reasonable time frame.

If you like and you have time you can improve
scripts/make_kconfig.pl to detect such an issue to
avoid future problems like this. I also had such a
situation with enabling a driver twice in the past.

BR,
   Jasmin
