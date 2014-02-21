Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55259 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaBUHxf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Feb 2014 02:53:35 -0500
Message-ID: <1392969210.19349.6.camel@smile.fi.intel.com>
Subject: Re: [RFC v5, 1/3] v4l2-controls.h: add addtional Flash fault bits
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Date: Fri, 21 Feb 2014 09:53:30 +0200
In-Reply-To: <1392958114-4542-1-git-send-email-gshark.jeong@gmail.com>
References: <1392958114-4542-1-git-send-email-gshark.jeong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2014-02-21 at 13:48 +0900, Daniel Jeong wrote:
> Same with v3 and v4.

It seems you wrote changelog between v4 and v5 into commit messages.
More over when you prepare patch series you forgot to use --thread for
git format-patch command.

Thus, I suggest you to write better commit messages and put changelog
into cover letter (--cover-letter option to git format-patch, and then
vi 0000-cover-letter).

> 
> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
> ---
>  include/uapi/linux/v4l2-controls.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 2cbe605..1d662f6 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -812,6 +812,9 @@ enum v4l2_flash_strobe_source {
>  #define V4L2_FLASH_FAULT_SHORT_CIRCUIT		(1 << 3)
>  #define V4L2_FLASH_FAULT_OVER_CURRENT		(1 << 4)
>  #define V4L2_FLASH_FAULT_INDICATOR		(1 << 5)
> +#define V4L2_FLASH_FAULT_UNDER_VOLTAGE		(1 << 6)
> +#define V4L2_FLASH_FAULT_INPUT_VOLTAGE		(1 << 7)
> +#define V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE	(1 << 8)
>  
>  #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
>  #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

