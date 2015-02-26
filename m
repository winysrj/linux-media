Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-194.synserver.de ([212.40.185.194]:1051 "EHLO
	smtp-out-194.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbbBZSZx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 13:25:53 -0500
Message-ID: <54EF652E.1020509@metafoo.de>
Date: Thu, 26 Feb 2015 19:25:50 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: i2c: adv7180: unregister the subdev in remove
 callback
References: <1424974769-27095-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424974769-27095-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/26/2015 07:19 PM, Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>
> this patch makes sure we unregister the subdev by calling
> v4l2_device_unregister_subdev() on remove callback.

This was just removed a while ago, see commit 632f2b0db9da ("[media] 
adv7180: Remove duplicate unregister call")[1].

- Lars

[1] 
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=632f2b0db9dabbaa5835b50a75a3a1639d6f6f38
