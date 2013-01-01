Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:46053 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab3AASV4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 13:21:56 -0500
Received: by mail-ee0-f53.google.com with SMTP id c50so6474726eek.12
        for <linux-media@vger.kernel.org>; Tue, 01 Jan 2013 10:21:55 -0800 (PST)
Message-ID: <50E32940.80903@gmail.com>
Date: Tue, 01 Jan 2013 19:21:52 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, andrzej.p@samsung.com,
	s.nawrocki@samsung.com, patches@linaro.org
Subject: Re: [PATCH 1/2] [media] s5p-jpeg: Use spinlock_t instead of 'struct
 spinlock'
References: <1356690044-8694-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1356690044-8694-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 12/28/2012 11:20 AM, Sachin Kamat wrote:
> Silences the following checkpatch warning:
> WARNING: struct spinlock should be spinlock_t
>
> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
> ---
>   drivers/media/platform/s5p-jpeg/jpeg-core.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
> index 022b9b9..8a4013e 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
> @@ -62,7 +62,7 @@
>    */
>   struct s5p_jpeg {
>   	struct mutex		lock;
> -	struct spinlock		slock;
> +	spinlock_t		slock;

Thank you for these two patches, however there are already similar ones
applied in the media tree:

http://git.linuxtv.org/media_tree.git/commit/a75831f3600c479054fc3f70cd11257ab07886e2
http://git.linuxtv.org/media_tree.git/commit/9d193b758edaad192d05ebcb8dc4cb72711bf618

You were unfortunately a bit too late ;)

Regards,
Sylwester
