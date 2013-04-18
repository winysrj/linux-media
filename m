Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:22490 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab3DRW0c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 18:26:32 -0400
Date: Fri, 19 Apr 2013 00:26:25 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: mchehab@redhat.com, hverkuil@xs4all.nl,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] v4l2: Add a V4L2 driver for SI476X MFD
Message-ID: <20130418222625.GZ8798@zurbaran>
References: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
 <1366304318-29620-10-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366304318-29620-10-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

On Thu, Apr 18, 2013 at 09:58:35AM -0700, Andrey Smirnov wrote:
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index ead9928..170460d 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -18,6 +18,23 @@ config RADIO_SI470X
>  
>  source "drivers/media/radio/si470x/Kconfig"
>  
> +config RADIO_SI476X
> +	tristate "Silicon Laboratories Si476x I2C FM Radio"
> +	depends on I2C && VIDEO_V4L2
> +	select MFD_CORE
> +	select MFD_SI476X_CORE
This is wrong. You want depends on MFD_SI476X_CORE, you should not select a
symbol that has other dependencies. It also would allow us to carry the
v4l2/media parts of your patchset independently from the MFD ones as the radio
driver will not be buildable on a tree where the MFD part is not present.
We'll try to figure something out with Mauro.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
