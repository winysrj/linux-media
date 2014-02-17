Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50838 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751045AbaBQJlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 04:41:47 -0500
Date: Mon, 17 Feb 2014 11:41:43 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Daniel Jeong <gshark.jeong@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Landley <rob@landley.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC v3,2/3] controls.xml : add addtional Flash fault bits
Message-ID: <20140217094143.GU15635@valkosipuli.retiisi.org.uk>
References: <1392371151-32644-1-git-send-email-gshark.jeong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392371151-32644-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

Thanks for the update.

Daniel Jeong wrote:
> Add addtional falult bits for FLASH
> V4L2_FLASH_FAULT_UNDER_VOLTAGE	: UVLO
> V4L2_FLASH_FAULT_INPUT_VOLTAGE	: input voltage is adjusted by IVFM
> V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE : NTC Trip point is crossed.
> 
> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index a5a3188..8121f7e 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -4370,6 +4370,22 @@ interface and may change in the future.</para>
>      		  <entry>The flash controller has detected a short or open
>      		  circuit condition on the indicator LED.</entry>
>      		</row>
> +    		<row>
> +    		  <entry><constant>V4L2_FLASH_FAULT_UNDER_VOLTAGE</constant></entry>
> +    		  <entry>Flash controller voltage to the flash LED
> +    		  has been below the minimum limit specific to the flash
> +    		  controller.</entry>
> +    		</row>
> +    		<row>
> +    		  <entry><constant>V4L2_FLASH_FAULT_INPUT_VOLTAGE</constant></entry>
> +    		  <entry>The flash controller has detected adjustment of input
> +    		  voltage by Input Volage Flash Monitor(IVFM).</entry>

Volage -> Voltage; space before "(".

I still feel uncomfortable with the reference to the IVFM. That appears
clearely an implementation specific term.

You previously mentioned the flash current may be adjusted by the flash
controller. It should be mentioned here.

Is it possible to read the adjusted value from the chip?

> +    		</row>
> +    		<row>
> +    		  <entry><constant>V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE</constant></entry>
> +    		  <entry>The flash controller has detected that TEMP input has
> +    		  crossed NTC Trip Voltage.</entry>

Even if the NTC resistor might be the actual implementation, I wouldn't
refer to it here. There could be a real temperature sensor, for instance.

> +    		</row>
>      	      </tbody>
>      	    </entrytbl>
>      	  </row>
> 

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
