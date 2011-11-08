Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45288 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345Ab1KHWkM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 17:40:12 -0500
Received: by faan17 with SMTP id n17so1033350faa.19
        for <linux-media@vger.kernel.org>; Tue, 08 Nov 2011 14:40:11 -0800 (PST)
Message-ID: <4EB9AFC7.6000803@gmail.com>
Date: Tue, 08 Nov 2011 23:40:07 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 00/13] Remaining coding style clean up of AS102 driver
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com> <4EB9304C.5020305@redhat.com>
In-Reply-To: <4EB9304C.5020305@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/08/2011 02:36 PM, Mauro Carvalho Chehab wrote:
> I got a few warnings here, after applying the patch series:
> 
> drivers/staging/media/as102/as102_drv.c: In function ‘as102_dvb_register’:
> drivers/staging/media/as102/as102_drv.c:223:3: warning: passing argument 1 of ‘dev_err’ from incompatible pointer type [enabled by default]
> include/linux/device.h:812:12: note: expected ‘const struct device *’ but argument is of type ‘char *’
> drivers/staging/media/as102/as102_drv.c:223:3: warning: too many arguments for format [-Wformat-extra-args]
> 
> please check.

Yes, there was an error in patch 06/13, this has been pointed out yesterday.
I intended to resend the patch, but since you have already pulled the whole series.. :),
I'll post an additional patch to fix the problem.  

-- 
Cheers,
Sylwester
