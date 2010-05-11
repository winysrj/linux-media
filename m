Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:58829 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0EKJdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 05:33:32 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 11 May 2010 15:03:28 +0530
Subject: RE: [PATCH 2/6] [RFC] tvp514x: make std_list const
Message-ID: <19F8576C6E063C45BE387C64729E7394044E404BD6@dbde02.ent.ti.com>
References: <cover.1273413060.git.hverkuil@xs4all.nl>
 <d64f7ef97d6dea1b87619f32c60da7cf8cdaf557.1273413060.git.hverkuil@xs4all.nl>
In-Reply-To: <d64f7ef97d6dea1b87619f32c60da7cf8cdaf557.1273413060.git.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Sunday, May 09, 2010 7:27 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav
> Subject: [PATCH 2/6] [RFC] tvp514x: make std_list const
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/tvp514x.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
> index 1ca1247..9d8d5c8 100644
> --- a/drivers/media/video/tvp514x.c
> +++ b/drivers/media/video/tvp514x.c
> @@ -110,7 +110,7 @@ struct tvp514x_decoder {
> 
>  	enum tvp514x_std current_std;
>  	int num_stds;
> -	struct tvp514x_std_info *std_list;
> +	const struct tvp514x_std_info *std_list;
>  	/* Input and Output Routing parameters */
>  	u32 input;
>  	u32 output;
> @@ -222,7 +222,7 @@ static const struct v4l2_fmtdesc tvp514x_fmt_list[] = {
>   * Currently supports two standards only, need to add support for rest of
> the
>   * modes, like SECAM, etc...
>   */
> -static struct tvp514x_std_info tvp514x_std_list[] = {
> +static const struct tvp514x_std_info tvp514x_std_list[] = {
>  	/* Standard: STD_NTSC_MJ */
>  	[STD_NTSC_MJ] = {
>  	 .width = NTSC_NUM_ACTIVE_PIXELS,
[Hiremath, Vaibhav] 

Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
Tested-by: Vaibhav Hiremath <hvaibhav@ti.com>
Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>



Thanks,
Vaibhav

> --
> 1.6.4.2

