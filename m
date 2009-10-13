Return-path: <linux-media-owner@vger.kernel.org>
Received: from ru.mvista.com ([213.79.90.228]:59555 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752505AbZJMP2E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 11:28:04 -0400
Message-ID: <4AD49D13.4030505@ru.mvista.com>
Date: Tue, 13 Oct 2009 19:30:27 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
To: hvaibhav@ti.com
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH 2/6] Davinci VPFE Capture: Take i2c adapter id through
 platform data
References: <hvaibhav@ti.com> <1255446503-16727-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1255446503-16727-1-git-send-email-hvaibhav@ti.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

hvaibhav@ti.com wrote:

> From: Vaibhav Hiremath <hvaibhav@ti.com>

> The I2C adapter ID is actually depends on Board and may vary, Davinci
> uses id=1, but in case of AM3517 id=3.

> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>

[...]

> diff --git a/include/media/davinci/vpfe_capture.h b/include/media/davinci/vpfe_capture.h
> index e8272d1..f610104 100644
> --- a/include/media/davinci/vpfe_capture.h
> +++ b/include/media/davinci/vpfe_capture.h
> @@ -94,6 +94,8 @@ struct vpfe_subdev_info {
>  struct vpfe_config {
>  	/* Number of sub devices connected to vpfe */
>  	int num_subdevs;
> +	/*I2c Bus adapter no*/

    Put spaces after /* and before */, please. Also, it's "I2C", not "I2c"...

WBR, Sergei
