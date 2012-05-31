Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59723 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2EaHIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 May 2012 03:08:01 -0400
Received: by bkcji2 with SMTP id ji2so515864bkc.19
        for <linux-media@vger.kernel.org>; Thu, 31 May 2012 00:08:00 -0700 (PDT)
Message-ID: <4FC718CD.8020503@googlemail.com>
Date: Thu, 31 May 2012 09:07:57 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [v4l-utils] Add configure option to allow qv4l2 disable
References: <1338385364-2308-1-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1338385364-2308-1-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 5/30/12 3:42 PM, Ezequiel Garcia wrote:
> This patch could ease the job of a few people,
> by providing an option they actually need.
> OpenWRT [1] and Openembedded [2] are already disabling
> qv4l2 by applying ugly patches.
>
> [1] https://dev.openwrt.org/browser/packages/libs/libv4l/patches/004-disable-qv4l2.patch
> [2] http://patches.openembedded.org/patch/21469/

What's the purpose of this patch? As far as I can see it saves compile 
time if Qt4 development stuff is installed. Otherwise building qv4l 
should be skipped.

But it also does not hurt to make building qv4l2 optional.

Thanks,
Gregor
