Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35028 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752968AbeCNIbg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 04:31:36 -0400
Date: Wed, 14 Mar 2018 11:31:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Seiderer <ps.report@gmx.net>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH] media: staging/imx: fill vb2_v4l2_buffer sequence entry
Message-ID: <20180314083115.rftkeucwzajs7qaq@mwanda>
References: <20180313200054.31305-1-ps.report@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313200054.31305-1-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need a changelog.  How does this affect user space?  What bug does
this fix?

On Tue, Mar 13, 2018 at 09:00:54PM +0100, Peter Seiderer wrote:
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> ---
>  drivers/staging/media/imx/imx-media-csi.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 5a195f80a24d..3a6a645b9dce 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -111,6 +111,7 @@ struct csi_priv {
>  	struct v4l2_ctrl_handler ctrl_hdlr;
>  
>  	int stream_count; /* streaming counter */
> +	__u32 frame_sequence; /* frame sequence counter */

Use u32 because this is not a user space header.

>  	bool last_eof;   /* waiting for last EOF at stream off */
>  	bool nfb4eof;    /* NFB4EOF encountered during streaming */
>  	struct completion last_eof_comp;

regards,
dan carpenter
