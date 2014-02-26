Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59580 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751175AbaBZMeI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 07:34:08 -0500
Date: Wed, 26 Feb 2014 14:33:34 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Landley <rob@landley.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC v6,2/3] controls.xml : add addtional Flash fault bits
Message-ID: <20140226123334.GI15635@valkosipuli.retiisi.org.uk>
References: <1393398251-5383-1-git-send-email-gshark.jeong@gmail.com>
 <1393398251-5383-3-git-send-email-gshark.jeong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393398251-5383-3-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

Thanks for the update. Just one comment below.

On Wed, Feb 26, 2014 at 04:04:10PM +0900, Daniel Jeong wrote:
> Descriptions for flash faluts.
>  V4L2_FLASH_FAULT_UNDER_VOLTAGE,
>  V4L2_FLASH_FAULT_INPUT_VOLTAGE,
>  and V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE
> 
> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index a5a3188..16f8af3 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -4370,6 +4370,24 @@ interface and may change in the future.</para>
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
> +    		  <entry>The flash current can't reach to the target current
> +    		  because the input voltage is dropped below lower limit. 
> +    		  and Flash controller have adjusted the flash current
> +    		  not to occur under voltage event.</entry>

How about this:

"The input voltage of the flash controller is below the limit under which
strobing the flash at full current will not be possible. The condition
persists until this flag is no longer set."

> +    		</row>
> +    		<row>
> +    		  <entry><constant>V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE</constant></entry>
> +    		  <entry>The temperature of the LED has exceeded its
> +    		  allowed upper limit.</entry>
> +    		</row>
>      	      </tbody>
>      	    </entrytbl>
>      	  </row>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
