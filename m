Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:48544 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbZG3B3O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 21:29:14 -0400
Subject: Re: [PATCH] cx18: Read buffer overflow
From: Andy Walls <awalls@radix.net>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4A705028.80008@gmail.com>
References: <4A705028.80008@gmail.com>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 21:31:23 -0400
Message-Id: <1248917483.20265.6.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-07-29 at 15:35 +0200, Roel Kluin wrote:
> The guard mistakenly tests against sizeof(freqs) instead of ARRAY_SIZE(freqs).
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Andy Walls wrote:
> 
> > The cx18 driver suffers from the exact same defect in cx18-controls.c.
> 
> Thanks, if not already applied, here is it.

Thanks.  They've already made it to the main v4l-dvb repository
 
http://linuxtv.org/hg/v4l-dvb/rev/83131c18cb5f
http://linuxtv.org/hg/v4l-dvb/rev/f8c53e25ce11


Regards,
Andy

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
> 

