Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:48762 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753695AbaKHNgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Nov 2014 08:36:45 -0500
Message-ID: <1415454115.1881.3.camel@palomino.walls.org>
Subject: Re: [PATCH 05/11] cx25840/cx18: Use standard ordering of mask and
 shift
From: Andy Walls <awalls@md.metrocast.net>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Date: Sat, 08 Nov 2014 08:41:55 -0500
In-Reply-To: <0f1e7b544283cd5d8ef1ca6f759af5e208dbc2fd.1414387334.git.joe@perches.com>
References: <cover.1414387334.git.joe@perches.com>
	 <0f1e7b544283cd5d8ef1ca6f759af5e208dbc2fd.1414387334.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2014-10-26 at 22:25 -0700, Joe Perches wrote:
> Precedence of & and >> is not the same and is not left to right.
> shift has higher precedence and should be done after the mask.
> 
> This use has a mask then shift which is not the normal style.
> 
> Move the shift before the mask to match nearly all the other
> uses in kernel.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

The patch is technically correct.

Reviewed-by: Andy Walls <awalls@md.metrocast.net>

> ---
>  drivers/media/i2c/cx25840/cx25840-core.c | 12 ++++++------
>  drivers/media/pci/cx18/cx18-av-core.c    | 16 ++++++++--------
>  2 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
> index e453a3f..0327032 100644
> --- a/drivers/media/i2c/cx25840/cx25840-core.c
> +++ b/drivers/media/i2c/cx25840/cx25840-core.c
> @@ -879,7 +879,7 @@ void cx25840_std_setup(struct i2c_client *client)
>  	/* Sets horizontal blanking delay and active lines */
>  	cx25840_write(client, 0x470, hblank);
>  	cx25840_write(client, 0x471,
> -			0xff & (((hblank >> 8) & 0x3) | (hactive << 4)));
> +		      (((hblank >> 8) & 0x3) | (hactive << 4)) & 0xff);
>  	cx25840_write(client, 0x472, hactive >> 4);
>  
>  	/* Sets burst gate delay */
> @@ -888,13 +888,13 @@ void cx25840_std_setup(struct i2c_client *client)
>  	/* Sets vertical blanking delay and active duration */
>  	cx25840_write(client, 0x474, vblank);
>  	cx25840_write(client, 0x475,
> -			0xff & (((vblank >> 8) & 0x3) | (vactive << 4)));
> +		      (((vblank >> 8) & 0x3) | (vactive << 4)) & 0xff);
>  	cx25840_write(client, 0x476, vactive >> 4);
>  	cx25840_write(client, 0x477, vblank656);
>  
>  	/* Sets src decimation rate */
> -	cx25840_write(client, 0x478, 0xff & src_decimation);
> -	cx25840_write(client, 0x479, 0xff & (src_decimation >> 8));
> +	cx25840_write(client, 0x478, src_decimation & 0xff);
> +	cx25840_write(client, 0x479, (src_decimation >> 8) & 0xff);
>  
>  	/* Sets Luma and UV Low pass filters */
>  	cx25840_write(client, 0x47a, luma_lpf << 6 | ((uv_lpf << 4) & 0x30));
> @@ -904,8 +904,8 @@ void cx25840_std_setup(struct i2c_client *client)
>  
>  	/* Sets SC Step*/
>  	cx25840_write(client, 0x47c, sc);
> -	cx25840_write(client, 0x47d, 0xff & sc >> 8);
> -	cx25840_write(client, 0x47e, 0xff & sc >> 16);
> +	cx25840_write(client, 0x47d, (sc >> 8) & 0xff);
> +	cx25840_write(client, 0x47e, (sc >> 16) & 0xff);
>  
>  	/* Sets VBI parameters */
>  	if (std & V4L2_STD_625_50) {
> diff --git a/drivers/media/pci/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
> index 2d3afe0..45be26c 100644
> --- a/drivers/media/pci/cx18/cx18-av-core.c
> +++ b/drivers/media/pci/cx18/cx18-av-core.c
> @@ -490,8 +490,8 @@ void cx18_av_std_setup(struct cx18 *cx)
>  
>  	/* Sets horizontal blanking delay and active lines */
>  	cx18_av_write(cx, 0x470, hblank);
> -	cx18_av_write(cx, 0x471, 0xff & (((hblank >> 8) & 0x3) |
> -						(hactive << 4)));
> +	cx18_av_write(cx, 0x471,
> +		      (((hblank >> 8) & 0x3) | (hactive << 4)) & 0xff);
>  	cx18_av_write(cx, 0x472, hactive >> 4);
>  
>  	/* Sets burst gate delay */
> @@ -499,14 +499,14 @@ void cx18_av_std_setup(struct cx18 *cx)
>  
>  	/* Sets vertical blanking delay and active duration */
>  	cx18_av_write(cx, 0x474, vblank);
> -	cx18_av_write(cx, 0x475, 0xff & (((vblank >> 8) & 0x3) |
> -						(vactive << 4)));
> +	cx18_av_write(cx, 0x475,
> +		      (((vblank >> 8) & 0x3) | (vactive << 4)) & 0xff);
>  	cx18_av_write(cx, 0x476, vactive >> 4);
>  	cx18_av_write(cx, 0x477, vblank656);
>  
>  	/* Sets src decimation rate */
> -	cx18_av_write(cx, 0x478, 0xff & src_decimation);
> -	cx18_av_write(cx, 0x479, 0xff & (src_decimation >> 8));
> +	cx18_av_write(cx, 0x478, src_decimation & 0xff);
> +	cx18_av_write(cx, 0x479, (src_decimation >> 8) & 0xff);
>  
>  	/* Sets Luma and UV Low pass filters */
>  	cx18_av_write(cx, 0x47a, luma_lpf << 6 | ((uv_lpf << 4) & 0x30));
> @@ -516,8 +516,8 @@ void cx18_av_std_setup(struct cx18 *cx)
>  
>  	/* Sets SC Step*/
>  	cx18_av_write(cx, 0x47c, sc);
> -	cx18_av_write(cx, 0x47d, 0xff & sc >> 8);
> -	cx18_av_write(cx, 0x47e, 0xff & sc >> 16);
> +	cx18_av_write(cx, 0x47d, (sc >> 8) & 0xff);
> +	cx18_av_write(cx, 0x47e, (sc >> 16) & 0xff);
>  
>  	if (std & V4L2_STD_625_50) {
>  		state->slicer_line_delay = 1;


