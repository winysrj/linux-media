Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53542 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab2LPQDG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 11:03:06 -0500
Date: Sun, 16 Dec 2012 09:03:05 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 03/15] [media] marvell-ccic: add clock tree support
 for marvell-ccic driver
Message-ID: <20121216090305.13e6bca1@hpe.lwn.net>
In-Reply-To: <1355565484-15791-4-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-4-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012 17:57:52 +0800
Albert Wang <twang13@marvell.com> wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch adds the clock tree support for marvell-ccic.
> 
> Each board may require different clk enabling sequence.
> Developer need add the clk_name in correct sequence in board driver
> to use this feature.
> 
> +static void mcam_clk_set(struct mcam_camera *mcam, int on)
> +{
> +	unsigned int i;
> +
> +	if (on) {
> +		for (i = 0; i < mcam->clk_num; i++) {
> +			if (mcam->clk[i])
> +				clk_enable(mcam->clk[i]);
> +		}
> +	} else {
> +		for (i = mcam->clk_num; i > 0; i--) {
> +			if (mcam->clk[i - 1])
> +				clk_disable(mcam->clk[i - 1]);
> +		}
> +	}
> +}

A couple of minor comments:

 - This function is always called with a constant value for "on".  It would
   be easier to read (and less prone to unfortunate brace errors) if it
   were just two functions: mcam_clk_enable() and mcam_clk_disable().

 - I'd write the second for loop as:

	for (i = mcal->clk_num - 1; i >= 0; i==) {

   just to match the values used in the other direction and avoid the
   subscript arithmetic.

> +static void mcam_init_clk(struct mcam_camera *mcam,
> +			struct mmp_camera_platform_data *pdata, int init)

So why does an "init" function have an "init" parameter?  Again, I think
this would be far better split into two functions.  Among other things,
that would help to reduce the deep nesting below.

> +{
> +	unsigned int i;
> +
> +	if (NR_MCAM_CLK < pdata->clk_num) {
> +		dev_err(mcam->dev, "Too many mcam clocks defined\n");
> +		mcam->clk_num = 0;
> +		return;
> +	}
> +
> +	if (init) {
> +		for (i = 0; i < pdata->clk_num; i++) {
> +			if (pdata->clk_name[i] != NULL) {
> +				mcam->clk[i] = devm_clk_get(mcam->dev,
> +						pdata->clk_name[i]);
> +				if (IS_ERR(mcam->clk[i])) {
> +					dev_err(mcam->dev,
> +						"Could not get clk: %s\n",
> +						pdata->clk_name[i]);
> +					mcam->clk_num = 0;
> +					return;
> +				}
> +			}
> +		}
> +		mcam->clk_num = pdata->clk_num;
> +	} else
> +		mcam->clk_num = 0;
> +}

Again, minor comments, but I do think the code would be improved by
splitting those functions.  Meanwhile:

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
