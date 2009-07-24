Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51595 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZGXAiM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 20:38:12 -0400
Subject: Re: [PATCH] ivtv: Read buffer overflow
From: Andy Walls <awalls@radix.net>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: hverkuil@xs4all.nl, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4A68D6A2.1080800@gmail.com>
References: <4A68D6A2.1080800@gmail.com>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 20:36:07 -0400
Message-Id: <1248395767.3176.97.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-07-23 at 23:31 +0200, Roel Kluin wrote:
> This mistakenly tests against sizeof(freqs) instead of the array size. Due to
> the mask the only illegal value possible was 3.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Andy Walls <awalls@radix.net>

The cx18 driver suffers from the exact same defect in cx18-controls.c.

> ---
> diff --git a/drivers/media/video/ivtv/ivtv-controls.c b/drivers/media/video/ivtv/ivtv-controls.c
> index a3b77ed..4a9c8ce 100644
> --- a/drivers/media/video/ivtv/ivtv-controls.c
> +++ b/drivers/media/video/ivtv/ivtv-controls.c
> @@ -17,6 +17,7 @@
>      along with this program; if not, write to the Free Software
>      Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>   */
> +#include <linux/kernel.h>
>  
>  #include "ivtv-driver.h"
>  #include "ivtv-cards.h"
> @@ -281,7 +282,7 @@ int ivtv_s_ext_ctrls(struct file *file, void *fh, struct v4l2_ext_controls *c)
>  		idx = p.audio_properties & 0x03;
>  		/* The audio clock of the digitizer must match the codec sample
>  		   rate otherwise you get some very strange effects. */
> -		if (idx < sizeof(freqs))
> +		if (idx < ARRAY_SIZE(freqs))
>  			ivtv_call_all(itv, audio, s_clock_freq, freqs[idx]);
>  		return err;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

