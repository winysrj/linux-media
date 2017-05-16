Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:39846 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751181AbdEPUr7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 16:47:59 -0400
Subject: Re: [PATCH] staging: media: cxd2099: Fix checkpatch issues
To: eddi1983 <eddi1983@gmx.net>, mchehab@kernel.org
References: <20170516200740.27692-1-eddi1983@gmx.net>
Cc: gregkh@linuxfoundation.org, diaconitatamara@gmail.com,
        daniel.baluta@gmail.com, eraretuya@gmail.com,
        elise.lennion@gmail.com, linux-media@vger.kernel.org,
        0devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <82946e90-46a5-de5a-40db-adeaa4839976@anw.at>
Date: Tue, 16 May 2017 22:47:48 +0200
MIME-Version: 1.0
In-Reply-To: <20170516200740.27692-1-eddi1983@gmx.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Christoph!

The current cxd2099 driver is an old version. DD provides a newer variant.
Please see my patch series
   http://www.mail-archive.com/linux-media@vger.kernel.org/msg112410.html
Especially this patch
   http://www.mail-archive.com/linux-media@vger.kernel.org/msg112409.html
where I remove this useless printing already.

I kept the "slot_shutdown" print in my series, because it is useful and called
only if someone removes the CAM, but I removed all the other useless ones.

So I can agree with your first hunk.

It would be better to wait with this change after my series is approved!

BR,
    Jasmin
