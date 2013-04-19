Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1596 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab3DSKCn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 06:02:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: gennarone@gmail.com
Subject: Re: cron job: media_tree daily build: ERRORS
Date: Fri, 19 Apr 2013 12:02:24 +0200
Cc: linux-media@vger.kernel.org
References: <20130418174018.16E0111E014C@alastor.dyndns.org> <201304191036.29749.hverkuil@xs4all.nl> <51711173.2020909@gmail.com>
In-Reply-To: <51711173.2020909@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304191202.24881.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri April 19 2013 11:42:11 Gianluca Gennari wrote:
> Il 19/04/2013 10:36, Hans Verkuil ha scritto:
> > Sorry for the ongoing breakage. I expect to have time this weekend to fix it.
> > 
> > Regards,
> > 
> > 	Hans
> > --
> 
> 
> Hi Hans,
> this should fix the current media_build breakage.
> Tested on Ubuntu 10.04 with kernel 2.6.32.

Applied, thanks.

Regards,

	Hans

> 
> Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
> ---
>  backports/v3.1_no_pm_qos.patch | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/backports/v3.1_no_pm_qos.patch b/backports/v3.1_no_pm_qos.patch
> index 8dbbd41..63f3ec6 100644
> --- a/backports/v3.1_no_pm_qos.patch
> +++ b/backports/v3.1_no_pm_qos.patch
> @@ -42,9 +42,9 @@ index 0a3feaa..c24b651 100644
>   #include <asm/io.h>
> 
>  @@ -470,7 +469,6 @@ struct saa7134_fh {
> - 	enum v4l2_buf_type         type;
> - 	unsigned int               resources;
> - 	enum v4l2_priority	   prio;
> +	unsigned int               radio;
> +	enum v4l2_buf_type         type;
> +	unsigned int               resources;
>  -	struct pm_qos_request	   qos_request;
> 
>   	/* video overlay */
> 
