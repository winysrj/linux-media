Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54254 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab2KVVvt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 16:51:49 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3107447eek.19
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 13:51:48 -0800 (PST)
Message-ID: <50AE9E72.5010903@gmail.com>
Date: Thu, 22 Nov 2012 22:51:46 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	kgene.kim@samsung.com
Subject: Re: [PATCH v2] [media] exynos-gsc: propagate timestamps from src
 to dst buffers
References: <1353561906-7869-1-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1353561906-7869-1-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

On 11/22/2012 06:25 AM, Shaik Ameer Basha wrote:
> Make gsc-m2m propagate the timestamp field from source to destination
> buffers
>
> Signed-off-by: John Sheu<sheu@google.com>
> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>

I've applied this patch to my tree for v3.8.

Thanks,
Sylwester
