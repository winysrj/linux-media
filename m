Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1808 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbaCKMuk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 08:50:40 -0400
Message-ID: <531F066B.5080704@xs4all.nl>
Date: Tue, 11 Mar 2014 13:49:47 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <a0393947@ti.com>
CC: k.debski@samsung.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 07/14] v4l: ti-vpe: Add selection API in VPE driver
References: <1393922965-15967-1-git-send-email-archit@ti.com> <1394526833-24805-1-git-send-email-archit@ti.com> <1394526833-24805-8-git-send-email-archit@ti.com> <531EFFC5.6040007@xs4all.nl> <531F05BD.70500@ti.com>
In-Reply-To: <531F05BD.70500@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/14 13:46, Archit Taneja wrote:
> On Tuesday 11 March 2014 05:51 PM, Hans Verkuil wrote:
>> Hi Archit,
>>
>> A few small comments below...
>>
>> On 03/11/14 09:33, Archit Taneja wrote:
>>> Add selection ioctl ops. For VPE, cropping makes sense only for the input to
>>> VPE(or V4L2_BUF_TYPE_VIDEO_OUTPUT/MPLANE buffers) and composing makes sense
>>> only for the output of VPE(or V4L2_BUF_TYPE_VIDEO_CAPTURE/MPLANE buffers).
>>>
>>> For the CAPTURE type, V4L2_SEL_TGT_COMPOSE results in VPE writing the output
>>> in a rectangle within the capture buffer. For the OUTPUT type, V4L2_SEL_TGT_CROP
>>> results in selecting a rectangle region within the source buffer.
>>>
>>> Setting the crop/compose rectangles should successfully result in
>>> re-configuration of registers which are affected when either source or
>>> destination dimensions change, set_srcdst_params() is called for this purpose.
>>>
>>> Signed-off-by: Archit Taneja <archit@ti.com>
>>> ---
>>>   drivers/media/platform/ti-vpe/vpe.c | 141 ++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 141 insertions(+)
>>>
>>> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
>>> index ece9b96..4abb85c 100644
>>> --- a/drivers/media/platform/ti-vpe/vpe.c
>>> +++ b/drivers/media/platform/ti-vpe/vpe.c
>>> @@ -410,8 +410,10 @@ static struct vpe_q_data *get_q_data(struct vpe_ctx *ctx,
>>>   {
>>>       switch (type) {
>>>       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>>> +    case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>>>           return &ctx->q_data[Q_DATA_SRC];
>>>       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>>> +    case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>>>           return &ctx->q_data[Q_DATA_DST];
>>>       default:
>>>           BUG();
>>> @@ -1587,6 +1589,142 @@ static int vpe_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
>>>       return set_srcdst_params(ctx);
>>>   }
>>>
>>> +static int __vpe_try_selection(struct vpe_ctx *ctx, struct v4l2_selection *s)
>>> +{
>>> +    struct vpe_q_data *q_data;
>>> +
>>> +    if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>>> +        (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT))
>>> +        return -EINVAL;
>>> +
>>> +    q_data = get_q_data(ctx, s->type);
>>> +    if (!q_data)
>>> +        return -EINVAL;
>>> +
>>> +    switch (s->target) {
>>> +    case V4L2_SEL_TGT_COMPOSE:
>>> +        /*
>>> +         * COMPOSE target is only valid for capture buffer type, for
>>> +         * output buffer type, assign existing crop parameters to the
>>> +         * selection rectangle
>>> +         */
>>> +        if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>> +            break;
>>
>> Shouldn't this return -EINVAL?
> 
> compose only makes sense for CAPTURE. So, it breaks and performs the calculations after the switch statement.

It's so easy to get confused here.

> 
>>
>>> +
>>> +        s->r = q_data->c_rect;
>>> +        return 0;
> 
> The above 2 lines are called for if we try to set compose for OUTPUT. I don't return an error here, just keep the size as the original rect size, and return 0.
> 
> I'll replace these 2 lines with 'return -EINVAL;'

Yes, that makes more sense.

> 
>>> +
>>> +    case V4L2_SEL_TGT_CROP:
>>> +        /*
>>> +         * CROP target is only valid for output buffer type, for capture
>>> +         * buffer type, assign existing compose parameters to the
>>> +         * selection rectangle
>>> +         */
>>> +        if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
>>> +            break;
>>
>> Ditto.
>>
>>> +
>>> +        s->r = q_data->c_rect;
>>> +        return 0;
>>> +
>>> +    /*
>>> +     * bound and default crop/compose targets are invalid targets to
>>> +     * try/set
>>> +     */
>>> +    default:
>>> +        return -EINVAL;
>>> +    }
>>> +
>>> +    if (s->r.top < 0 || s->r.left < 0) {
>>> +        vpe_err(ctx->dev, "negative values for top and left\n");
>>> +        s->r.top = s->r.left = 0;
>>> +    }
>>> +
>>> +    v4l_bound_align_image(&s->r.width, MIN_W, q_data->width, 1,
>>> +        &s->r.height, MIN_H, q_data->height, H_ALIGN, S_ALIGN);
>>> +
>>> +    /* adjust left/top if cropping rectangle is out of bounds */
>>> +    if (s->r.left + s->r.width > q_data->width)
>>> +        s->r.left = q_data->width - s->r.width;
>>> +    if (s->r.top + s->r.height > q_data->height)
>>> +        s->r.top = q_data->height - s->r.height;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int vpe_g_selection(struct file *file, void *fh,
>>> +        struct v4l2_selection *s)
>>> +{
>>> +    struct vpe_ctx *ctx = file2ctx(file);
>>> +    struct vpe_q_data *q_data;
>>> +
>>> +    if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>>> +        (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT))
>>> +        return -EINVAL;
>>> +
>>> +    q_data = get_q_data(ctx, s->type);
>>> +    if (!q_data)
>>> +        return -EINVAL;
>>> +
>>> +    switch (s->target) {
>>> +    /* return width and height from S_FMT of the respective buffer type */
>>> +    case V4L2_SEL_TGT_COMPOSE_DEFAULT:
>>> +    case V4L2_SEL_TGT_COMPOSE_BOUNDS:
>>> +    case V4L2_SEL_TGT_CROP_BOUNDS:
>>> +    case V4L2_SEL_TGT_CROP_DEFAULT:
>>> +        s->r.left = 0;
>>> +        s->r.top = 0;
>>> +        s->r.width = q_data->width;
>>> +        s->r.height = q_data->height;
>>
>> The crop targets only make sense for type OUTPUT and the compose only for
>> type CAPTURE. Add some checks for that.
> 
> I return the image size for G_FMT irrespective of what combination of
> crop/compose CAPTURE/OUTPUT it is. I suppose it is better to return
> an error if the user tries to configure a wrong combination.

Yes. If for no other reason that I plan on adding crop/compose/scaling support
to v4l2-compliance soon, and this will probably be one of the tests.

> 
> Thanks,
> Archit
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

