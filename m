Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34097 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384Ab3AGAP5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jan 2013 19:15:57 -0500
Message-ID: <1357516360.1851.12.camel@palomino.walls.org>
Subject: Re: [PATCH] media: cx18, ivtv: do not dereference array before
 index check
From: Andy Walls <awalls@md.metrocast.net>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Date: Sun, 06 Jan 2013 18:52:40 -0500
In-Reply-To: <1357413116-41872-1-git-send-email-nickolai@csail.mit.edu>
References: <1357413116-41872-1-git-send-email-nickolai@csail.mit.edu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2013-01-05 at 14:11 -0500, Nickolai Zeldovich wrote:
> Move dereferencing of hw_devicenames[], hw_bus[] arrays until after
> checking that idx is within range.
> 
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>

Hi Nickolai,

My comments are in line below.

> ---
>  drivers/media/pci/cx18/cx18-i2c.c |   10 +++++++---
>  drivers/media/pci/ivtv/ivtv-i2c.c |    5 ++++-
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
> index 4908eb7..d164239 100644
> --- a/drivers/media/pci/cx18/cx18-i2c.c
> +++ b/drivers/media/pci/cx18/cx18-i2c.c
> @@ -111,14 +111,18 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
>  int cx18_i2c_register(struct cx18 *cx, unsigned idx)
>  {
>  	struct v4l2_subdev *sd;
> -	int bus = hw_bus[idx];
> -	struct i2c_adapter *adap = &cx->i2c_adap[bus];
> -	const char *type = hw_devicenames[idx];
> +	int bus;
> +	struct i2c_adapter *adap;
> +	const char *type;
>  	u32 hw = 1 << idx;
>  
>  	if (idx >= ARRAY_SIZE(hw_addrs))
>  		return -1;
>
> +	bus = hw_bus[idx];
> +	adap = &cx->i2c_adap[bus];
> +	type = hw_devicenames[idx];
> +

It would be better to simply remove the "if (idx >= ARRAY_SIZE(...))"
check.  That change would result in fewer lines of code instead of more
lines of code.  It is statically provable that cx18_i2c_register() is
never called with a bad idx value.


>  	if (hw == CX18_HW_TUNER) {
>  		/* special tuner group handling */
>  		sd = v4l2_i2c_new_subdev(&cx->v4l2_dev,
> diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
> index 46e262b..c6af94c 100644
> --- a/drivers/media/pci/ivtv/ivtv-i2c.c
> +++ b/drivers/media/pci/ivtv/ivtv-i2c.c
> @@ -264,11 +264,14 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
>  {
>  	struct v4l2_subdev *sd;
>  	struct i2c_adapter *adap = &itv->i2c_adap;
> -	const char *type = hw_devicenames[idx];
> +	const char *type;
>  	u32 hw = 1 << idx;
>  
>  	if (idx >= ARRAY_SIZE(hw_addrs))
>  		return -1;
> +
> +	type = hw_devicenames[idx];
> +

It would be better to simply remove the "if (idx >= ARRAY_SIZE(...))"
check.  That change would result in fewer lines of code instead of more
lines of code.  It is statically provable that ivtv_i2c_register() is
never called with a bad idx value.

Regards,
Andy

>  	if (hw == IVTV_HW_TUNER) {
>  		/* special tuner handling */
>  		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev, adap, type, 0,


