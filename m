Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32053 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab3H2JrR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 05:47:17 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MSA00IWCDT5F7A0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Aug 2013 10:47:15 +0100 (BST)
Message-id: <521F18A1.2000805@samsung.com>
Date: Thu, 29 Aug 2013 11:47:13 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, mturquette@linaro.org,
	laurent.pinchart@ideasonboard.com, arun.kk@samsung.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, a.hajda@samsung.com,
	kyungmin.park@samsung.com, t.figa@samsung.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/7] V4L: s5k6a3: Add support for asynchronous subdev
 registration
References: <1377705360-12197-1-git-send-email-s.nawrocki@samsung.com>
 <1377705360-12197-5-git-send-email-s.nawrocki@samsung.com>
 <Pine.LNX.4.64.1308281819520.22743@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1308281819520.22743@axis700.grange>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/28/2013 06:21 PM, Guennadi Liakhovetski wrote:
> Hi Sylwester,
> 
> Just one doubt below
> 
> On Wed, 28 Aug 2013, Sylwester Nawrocki wrote:
> 
>> > This patch converts the driver to use v4l2 asynchronous subdev
>> > registration API an the clock API to control the external master
>> > clock directly.
>> > 
>> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> > ---
>> >  drivers/media/i2c/s5k6a3.c |   36 ++++++++++++++++++++++++++----------
>> >  1 file changed, 26 insertions(+), 10 deletions(-)
>> > 
>> > diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
>> > index ba86e24..f65a4f8 100644
>> > --- a/drivers/media/i2c/s5k6a3.c
>> > +++ b/drivers/media/i2c/s5k6a3.c
> [snip]
> 
>> > @@ -282,7 +297,7 @@ static int s5k6a3_probe(struct i2c_client *client,
>> >  	pm_runtime_no_callbacks(dev);
>> >  	pm_runtime_enable(dev);
>> >  
>> > -	return 0;
>> > +	return v4l2_async_register_subdev(sd);
>
> If the above fails - don't you have to do any clean up? E.g. below you do 
> disable runtime PM and clean up the media entity.

You're right, the clean up steps are missing. Thanks for pointing out,
I've corrected this for the next iteration.

Thanks,
Sylwester
