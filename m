Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:45406 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbcGGGjI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jul 2016 02:39:08 -0400
Subject: Re: [PATCH v5 4/4] rcar-vin: implement EDID control ioctls
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
References: <1467819576-17743-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1467819576-17743-5-git-send-email-ulrich.hecht+renesas@gmail.com>
 <20160707001658.GL20356@bigcity.dyn.berto.se>
Cc: hans.verkuil@cisco.com, linux-media@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, william.towle@codethink.co.uk
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ac9d2b07-ccbc-0e4d-b3fc-081fd1ef25bf@xs4all.nl>
Date: Thu, 7 Jul 2016 08:39:02 +0200
MIME-Version: 1.0
In-Reply-To: <20160707001658.GL20356@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/2016 02:16 AM, Niklas Söderlund wrote:
> Hi Ulrich,
> 
> Thanks for your patch.
> 
> On 2016-07-06 17:39:36 +0200, Ulrich Hecht wrote:
>> Adds G_EDID and S_EDID.
>>
>> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
>> ---
>>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
>> index 396eabc..bd8f14c 100644
>> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
>> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
>> @@ -661,6 +661,20 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
>>  	return ret;
>>  }
>>  
>> +static int rvin_g_edid(struct file *file, void *fh, struct v4l2_edid *edid)
>> +{
>> +	struct rvin_dev *vin = video_drvdata(file);
>> +
>> +	return rvin_subdev_call(vin, pad, get_edid, edid);
> 
> You need to add a translation from the rcar-vin drivers view of it's 
> current input to the subdevices view of how it's pads are arranged. I 
> think something like this would work:
> 
>     struct rvin_dev *vin = video_drvdata(file);
>     unsigned int input;
>     int ret;
> 
>     input = edid->pad;
> 
>     edid->pad = vin->inputs[input].sink_idx;
> 
>     ret = vin_subdev_call(vin, pad, get_edid, edid);
> 
>     edid->pad = input;
> 
>     return ret;
> 
> I know it's not obvious you need this and I can't figure out a better 
> way to solve runtime switching of subdevices. Any ideas on how to 
> improve the situation are more then welcome :-)

I agree it is ugly, but it isn't used often enough to warrant the extra
work. I am thinking that the pad should be an extra argument in the subdev
op instead of using edid->pad. That should simplify the code.

Regards,

	Hans
