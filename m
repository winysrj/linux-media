Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:35508 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754181AbdCaJAf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 05:00:35 -0400
Subject: Re: [PATCH 3/3] [media] cobalt: Use v4l2_calc_timeperframe helper
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        <linux-media@vger.kernel.org>
References: <cover.1490095965.git.joabreu@synopsys.com>
 <070c9e71b359c0f6da7410b5ab9207210925549a.1490095965.git.joabreu@synopsys.com>
 <bdd49167-298e-b4e9-5e3c-422524291d26@xs4all.nl>
CC: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        <linux-kernel@vger.kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <eab1bff3-e2bd-947a-6220-59c04376edac@synopsys.com>
Date: Fri, 31 Mar 2017 09:59:57 +0100
MIME-Version: 1.0
In-Reply-To: <bdd49167-298e-b4e9-5e3c-422524291d26@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 30-03-2017 14:42, Hans Verkuil wrote:
> Hi Jose,
>
> On 21/03/17 12:49, Jose Abreu wrote:
>> Currently, cobalt driver always returns 60fps in g_parm.
>> This patch uses the new v4l2_calc_timeperframe helper to
>> calculate the time per frame value.
> I can verify that g_parm works, so:
>
> Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> However, the adv7604 pixelclock detection resolution is only 0.25 MHz, so it
> can't tell the difference between 24 and 23.97 Hz. I can't set the new
> V4L2_DV_FL_CAN_DETECT_REDUCED_FPS flag there.
>
> It might be possible to implement this for the adv7842 receiver, I think that
> that hardware is much more precise.
>
> I would have to try this, but that will have to wait until Friday next week.

Thanks! Yes, maybe its better to test with a different receiver,
if it has more precision then its great. Let me know if you need
any help :)

Best regards,
Jose Miguel Abreu

>
> Regards,
>
> 	Hans
>
>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>> Cc: Carlos Palminha <palminha@synopsys.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: linux-media@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  drivers/media/pci/cobalt/cobalt-v4l2.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
>> index def4a3b..25532ae 100644
>> --- a/drivers/media/pci/cobalt/cobalt-v4l2.c
>> +++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
>> @@ -1076,10 +1076,15 @@ static int cobalt_subscribe_event(struct v4l2_fh *fh,
>>  
>>  static int cobalt_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
>>  {
>> +	struct cobalt_stream *s = video_drvdata(file);
>> +	struct v4l2_fract fps;
>> +
>>  	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>  		return -EINVAL;
>> -	a->parm.capture.timeperframe.numerator = 1;
>> -	a->parm.capture.timeperframe.denominator = 60;
>> +
>> +	fps = v4l2_calc_timeperframe(&s->timings);
>> +	a->parm.capture.timeperframe.numerator = fps.numerator;
>> +	a->parm.capture.timeperframe.denominator = fps.denominator;
>>  	a->parm.capture.readbuffers = 3;
>>  	return 0;
>>  }
>>
