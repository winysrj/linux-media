Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:54326 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751838AbdEIRU6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 13:20:58 -0400
Subject: Re: [PATCH] staging: media: cxd2099: Use __func__ macro in messages
To: Alexandre Ghiti <alex@ghiti.fr>, gregkh@linuxfoundation.org
References: <1494332833-6918-1-git-send-email-alex@ghiti.fr>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, "'Jasmin J.'" <jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <19b63d73-be08-ff3e-ef32-a88be932f858@anw.at>
Date: Tue, 9 May 2017 19:20:41 +0200
MIME-Version: 1.0
In-Reply-To: <1494332833-6918-1-git-send-email-alex@ghiti.fr>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexandre!

The current cxd2099 driver is an old version. DD provides a newer variant.
Please see my patch series
   http://www.mail-archive.com/linux-media@vger.kernel.org/msg112410.html
Especially this patch
   http://www.mail-archive.com/linux-media@vger.kernel.org/msg112409.html
where I remove this useless printing already.

I kept the "slot_shutdown" print in my series, because it is useful and called
only if someone removes the CAM.

So I can agree with your first hunk.

BR,
    Jasmin
