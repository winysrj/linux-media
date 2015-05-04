Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59487 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbbEDHzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2015 03:55:03 -0400
Date: Mon, 4 May 2015 09:54:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hansverk@cisco.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 9/9] mt9t112: initialize left and top
In-Reply-To: <55472333.7000204@cisco.com>
Message-ID: <Pine.LNX.4.64.1505040949450.9253@axis700.grange>
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
 <1430646876-19594-10-git-send-email-hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1505032250430.6055@axis700.grange> <55472049.7010408@xs4all.nl>
 <Pine.LNX.4.64.1505040937020.9253@axis700.grange> <55472333.7000204@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 4 May 2015, Hans Verkuil wrote:

> On 05/04/2015 09:40 AM, Guennadi Liakhovetski wrote:
> > On Mon, 4 May 2015, Hans Verkuil wrote:
> > 
> >> On 05/03/2015 11:02 PM, Guennadi Liakhovetski wrote:
> >>> Hi Hans,
> >>>
> >>> On Sun, 3 May 2015, Hans Verkuil wrote:
> >>>
> >>>> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>>>
> >>>> The left and top variables were uninitialized, leading to unexpected
> >>>> results.
> >>>>
> >>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>>> ---
> >>>>  drivers/media/i2c/soc_camera/mt9t112.c | 3 ++-
> >>>>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
> >>>> index de10a76..02190d6 100644
> >>>> --- a/drivers/media/i2c/soc_camera/mt9t112.c
> >>>> +++ b/drivers/media/i2c/soc_camera/mt9t112.c
> >>>> @@ -952,7 +952,8 @@ static int mt9t112_set_fmt(struct v4l2_subdev *sd,
> >>>>  	struct v4l2_mbus_framefmt *mf = &format->format;
> >>>>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >>>>  	struct mt9t112_priv *priv = to_mt9t112(client);
> >>>> -	unsigned int top, left;
> >>>> +	unsigned int top = priv->frame.top;
> >>>> +	unsigned int left = priv->frame.left;
> >>>
> >>> I don't think this is needed. We don't care about left and top in 
> >>> mt9t112_set_fmt().
> >>
> >> On further analysis you are correct, it will work with random left/top
> >> values. But I think it is 1) very unexpected and 2) bad form to leave it
> >> with random values.
> >>
> >> I prefer to keep this patch, unless you disagree.
> > 
> > Sorry, but I do. Assigning those specific values to left and top makes the 
> > code even more confusing, it makes it look like that makes any sense, 
> > whereas it doesn't. If anything we can add a comment there. Or we can pass 
> > NULL and make sure to catch it somewhere down the line.
> > 
> 
> What about this:
> 
> 	unsigned int top = 0; /* don't care */
> 	unsigned int left = 0; /* don't care */

This would be my third preference. My first preference is just a comment. 
My second preference is adding

	if (!start)
		return;

in the middle of soc_camera_limit_side() and using NULL in 
mt9t112_set_fmt(). I really dislike meaningless operations, also when they 
fix compiler warnings, but here even the compiler is happy:)

Thanks
Guennadi

> >>>>  	int i;
> >>>>  
> >>>>  	if (format->pad)
> >>>> -- 
> >>>> 2.1.4
> >>>>
> >>
> 
