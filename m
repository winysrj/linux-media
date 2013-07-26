Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39652 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab3GZPyi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 11:54:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH] mt9v032: Use the common clock framework
Date: Fri, 26 Jul 2013 17:55:34 +0200
Message-ID: <1684528.NgmHp9Ak4m@avalon>
In-Reply-To: <51F27B56.9050504@gmail.com>
References: <1373021725-14006-1-git-send-email-laurent.pinchart@ideasonboard.com> <1438897.qqa6gsnOmc@avalon> <51F27B56.9050504@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Friday 26 July 2013 15:36:22 Sylwester Nawrocki wrote:
> On 07/26/2013 03:15 PM, Laurent Pinchart wrote:
> > On Friday 26 July 2013 15:11:08 Sylwester Nawrocki wrote:
> >> On 07/05/2013 12:55 PM, Laurent Pinchart wrote:
> >>> Configure the device external clock using the common clock framework
> >>> instead of a board code callback function.
> >>> 
> >>> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> >>> ---
> >>> 
> >>>    drivers/media/i2c/mt9v032.c | 16 ++++++++++------
> >>>    include/media/mt9v032.h     |  4 ----
> >>>    2 files changed, 10 insertions(+), 10 deletions(-)
> >>> 
> >>> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> >>> index 60c6f67..7b30640 100644
> >>> --- a/drivers/media/i2c/mt9v032.c
> >>> +++ b/drivers/media/i2c/mt9v032.c
> >>> @@ -12,6 +12,7 @@
> >>>     * published by the Free Software Foundation.
> >>>     */
> >>> 
> >>> +#include<linux/clk.h>
> >>>    #include<linux/delay.h>
> >>>    #include<linux/i2c.h>
> >>>    #include<linux/log2.h>
> >>> @@ -135,6 +136,8 @@ struct mt9v032 {
> >>>    	struct mutex power_lock;
> >>>    	int power_count;
> >>> 
> >>> +	struct clk *clk;
> >>> +
> >>>    	struct mt9v032_platform_data *pdata;
> >>>    	
> >>>    	u32 sysclk;
> >>> @@ -219,10 +222,8 @@ static int mt9v032_power_on(struct mt9v032
> >>> *mt9v032)
> >>>    	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
> >>>    	int ret;
> >>> 
> >>> -	if (mt9v032->pdata->set_clock) {
> >>> -		mt9v032->pdata->set_clock(&mt9v032->subdev, mt9v032->sysclk);
> >>> -		udelay(1);
> >>> -	}
> >>> +	clk_prepare_enable(mt9v032->clk);
> >>> +	udelay(1);
> >>> 
> >>>    	/* Reset the chip and stop data read out */
> >>>    	ret = mt9v032_write(client, MT9V032_RESET, 1);
> >>> @@ -238,8 +239,7 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
> >>> 
> >>>    static void mt9v032_power_off(struct mt9v032 *mt9v032)
> >>>    {
> >>> -	if (mt9v032->pdata->set_clock)
> >>> -		mt9v032->pdata->set_clock(&mt9v032->subdev, 0);
> >>> +	clk_disable_unprepare(mt9v032->clk);
> >>>    }
> >>>    
> >>>    static int __mt9v032_set_power(struct mt9v032 *mt9v032, bool on)
> >>> @@ -748,6 +748,10 @@ static int mt9v032_probe(struct i2c_client *client,
> >>>    	if (!mt9v032)
> >>>    		return -ENOMEM;
> >>> 
> >>> +	mt9v032->clk = devm_clk_get(&client->dev, NULL);
> >>> +	if (IS_ERR(mt9v032->clk))
> >>> +		return PTR_ERR(mt9v032->clk);
> >>> +
> >>>    	mutex_init(&mt9v032->power_lock);
> >>>    	mt9v032->pdata = pdata;
> >>> 
> >>> diff --git a/include/media/mt9v032.h b/include/media/mt9v032.h
> >>> index 78fd39e..12175a6 100644
> >>> --- a/include/media/mt9v032.h
> >>> +++ b/include/media/mt9v032.h
> >>> @@ -1,13 +1,9 @@
> >>>    #ifndef _MEDIA_MT9V032_H
> >>>    #define _MEDIA_MT9V032_H
> >>> 
> >>> -struct v4l2_subdev;
> >>> -
> >>>    struct mt9v032_platform_data {
> >>>    	unsigned int clk_pol:1;
> >>> -	void (*set_clock)(struct v4l2_subdev *subdev, unsigned int rate);
> >>> -
> >>>    	const s64 *link_freqs;
> >>>    	s64 link_def_freq;
> >>>    };
> >> 
> >> Is there clk_put() somewhere in this patch ? I would expect it somewhere
> >> around driver remove() callback, but can't see it. :-/
> > 
> > There's *devm_*clk_get() instead :-)
> 
> Ah, I knew I must have been forgetting or overlooking something! ;)
> 
> Do you rely on the fact that __clk_get()/__clk_put() doesn't get reference
> on the clock supplier module (to avoid locking modules in memory) ? I was
> planning on adding module_get()/module_put() inside __clk_get()/__clk_out()
> for the common clock API implementation.

I'm currently relying on that, but I'm aware it's not a good idea. We need to 
find a solution to fix the problem in the context of the v4l2-async framework.

-- 
Regards,

Laurent Pinchart

