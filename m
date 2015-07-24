Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:45631 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573AbbGXOHV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 10:07:21 -0400
Message-ID: <55B24650.5090401@xs4all.nl>
Date: Fri, 24 Jul 2015 16:06:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 04/14] tw9910: init priv->scale and update standard
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl> <1434368021-7467-5-git-send-email-hverkuil@xs4all.nl> <Pine.LNX.4.64.1506211855010.7745@axis700.grange> <5587B39A.4050805@xs4all.nl> <Pine.LNX.4.64.1506220920280.13683@axis700.grange> <5587B93C.1030106@xs4all.nl>
In-Reply-To: <5587B93C.1030106@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,

I want to make a pull request for this patch series. This patch is the only
outstanding one. Or do you have to review more patches? I only got Acks for
patches 1 and 2.

Regards,

	Hans

On 06/22/2015 09:29 AM, Hans Verkuil wrote:
> On 06/22/2015 09:21 AM, Guennadi Liakhovetski wrote:
>> Hi Hans,
>>
>> On Mon, 22 Jun 2015, Hans Verkuil wrote:
>>
>>> On 06/21/2015 07:23 PM, Guennadi Liakhovetski wrote:
>>>> On Mon, 15 Jun 2015, Hans Verkuil wrote:
>>>>
>>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>
>>>>> When the standard changes the VACTIVE and VDELAY values need to be updated.
>>>>>
>>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>>> ---
>>>>>  drivers/media/i2c/soc_camera/tw9910.c | 29 ++++++++++++++++++++++++++++-
>>>>>  1 file changed, 28 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
>>>>> index df66417..e939c24 100644
>>>>> --- a/drivers/media/i2c/soc_camera/tw9910.c
>>>>> +++ b/drivers/media/i2c/soc_camera/tw9910.c
>>>>> @@ -820,6 +846,7 @@ static int tw9910_video_probe(struct i2c_client *client)
>>>>>  		 "tw9910 Product ID %0x:%0x\n", id, priv->revision);
>>>>>  
>>>>>  	priv->norm = V4L2_STD_NTSC;
>>>>> +	priv->scale = &tw9910_ntsc_scales[0];
>>>>
>>>> Why do you need this? So far everywhere in the code priv->scale is either 
>>>> checked or set before use. Don't see why an additional initialisation is 
>>>> needed.
>>>
>>> If you just start streaming without explicitly setting up formats (which is
>>> allowed), then priv->scale is still NULL.
>>
>> Yes, it can well be NULL, but it is also unused. Before it is used it will 
>> be set, while it is unused it is allowed to stay NULL.
> 
> No. If you start streaming without the set_fmt op having been called, then
> s_stream will return an error since priv->scale is NULL. This is wrong. Since
> this driver defaults to NTSC the initial setup should be for NTSC and it should
> be ready for streaming.
> 
> So priv->scale *is* used: in s_stream. And it is not necessarily set before use.
> E.g. if you load the driver and run 'v4l2-ctl --stream-out-mmap' you will hit this
> case. It's how I found this bug.
> 
> It's a trivial one liner to ensure a valid priv->scale pointer.
> 
> Regards,
> 
> 	Hans
> 
>>
>> Thanks
>> Guennadi
>>
>>> V4L2 always assumes that there is some initial format configured, and this line
>>> enables that for this driver (NTSC).
>>>
>>> Regards,
>>>
>>> 	Hans

