Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:24643 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaAJNJ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 08:09:27 -0500
Message-ID: <52CFF06B.9000302@cisco.com>
Date: Fri, 10 Jan 2014 14:06:51 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Ethan Zhao <ethan.kernel@gmail.com>
CC: hans.verkuil@cisco.com, m.chehab@samsung.com,
	gregkh@linuxfoundation.org,
	linux-media <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: Re: [PATCH] [media] cx18: introduce a helper function to avoid array
 overrun
References: <1389020826-807-1-git-send-email-ethan.kernel@gmail.com>
In-Reply-To: <1389020826-807-1-git-send-email-ethan.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also CC to linux-media and Andy Walls who maintains this driver.

Regards,

	Hans

On 01/06/14 16:07, Ethan Zhao wrote:
> cx18_i2c_register() is called in cx18_init_subdevs() with index
> greater than length of hw_bus array, that will cause array overrun,
> introduce a helper cx18_get_max_bus_num() to avoid it.
> 
> V2: fix a typo and use ARRAY_SIZE macro
> 
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> ---
>  drivers/media/pci/cx18/cx18-driver.c | 2 +-
>  drivers/media/pci/cx18/cx18-i2c.c    | 5 +++++
>  drivers/media/pci/cx18/cx18-i2c.h    | 1 +
>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
> index 6386ced..dadcd4a 100644
> --- a/drivers/media/pci/cx18/cx18-driver.c
> +++ b/drivers/media/pci/cx18/cx18-driver.c
> @@ -856,7 +856,7 @@ static void cx18_init_subdevs(struct cx18 *cx)
>  	u32 device;
>  	int i;
>  
> -	for (i = 0, device = 1; i < 32; i++, device <<= 1) {
> +	for (i = 0, device = 1; i < cx18_get_max_bus_num(); i++, device <<= 1) {
>  
>  		if (!(device & hw))
>  			continue;
> diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
> index 4af8cd6..1a7b49b 100644
> --- a/drivers/media/pci/cx18/cx18-i2c.c
> +++ b/drivers/media/pci/cx18/cx18-i2c.c
> @@ -108,6 +108,11 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
>  	       -1 : 0;
>  }
>  
> +int cx18_get_max_bus_num(void)
> +{
> +	return ARRAY_SIZE(hw_bus);
> +}
> +
>  int cx18_i2c_register(struct cx18 *cx, unsigned idx)
>  {
>  	struct v4l2_subdev *sd;
> diff --git a/drivers/media/pci/cx18/cx18-i2c.h b/drivers/media/pci/cx18/cx18-i2c.h
> index 1180fdc..6f2ceb5 100644
> --- a/drivers/media/pci/cx18/cx18-i2c.h
> +++ b/drivers/media/pci/cx18/cx18-i2c.h
> @@ -21,6 +21,7 @@
>   *  02111-1307  USA
>   */
>  
> +int cx18_get_max_bus_num(void);
>  int cx18_i2c_register(struct cx18 *cx, unsigned idx);
>  struct v4l2_subdev *cx18_find_hw(struct cx18 *cx, u32 hw);
>  
> 
