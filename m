Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:55906 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595AbbE2KKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2015 06:10:46 -0400
Message-ID: <55683B18.1020902@xs4all.nl>
Date: Fri, 29 May 2015 12:10:32 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ben Hutchings <ben.hutchings@codethink.co.uk>,
	Rob Taylor <rob.taylor@codethink.co.uk>
CC: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com
Subject: Re: [Linux-kernel] [PATCH 13/20] media: soc_camera: v4l2-compliance
 fixes for querycap
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>	 <1432139980-12619-14-git-send-email-william.towle@codethink.co.uk>	 <555D7419.8000303@xs4all.nl> <555DD3B4.2080308@codethink.co.uk> <1432861681.5061.73.camel@codethink.co.uk>
In-Reply-To: <1432861681.5061.73.camel@codethink.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/29/2015 03:08 AM, Ben Hutchings wrote:
> On Thu, 2015-05-21 at 13:46 +0100, Rob Taylor wrote:
>> On 21/05/15 06:58, Hans Verkuil wrote:
>>> On 05/20/2015 06:39 PM, William Towle wrote:
>>>> Fill in bus_info field and zero reserved field.
>>>>
>>>> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
>>>> Reviewed-by: William Towle <william.towle@codethink.co.uk>
>>>> ---
>>>>  drivers/media/platform/soc_camera/soc_camera.c |    2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
>>>> index fd7497e..583c5e6 100644
>>>> --- a/drivers/media/platform/soc_camera/soc_camera.c
>>>> +++ b/drivers/media/platform/soc_camera/soc_camera.c
>>>> @@ -954,6 +954,8 @@ static int soc_camera_querycap(struct file *file, void  *priv,
>>>>  	WARN_ON(priv != file->private_data);
>>>>  
>>>>  	strlcpy(cap->driver, ici->drv_name, sizeof(cap->driver));
>>>> +	strlcpy(cap->bus_info, "platform:soc_camera", sizeof(cap->bus_info));
>>>> +	memset(cap->reserved, 0, sizeof(cap->reserved));
>>>
>>> Why the memset? That shouldn't be needed.
>>
>> v4l2-complience complained it wasn't zero (v4l2-compliance.cpp:308 in
>> v4l-utils v1.6.2 [1])

William, you should use the latest v4l-utils compiled from the git repo.
Unlikely to be related to this, though.

> 
> I'm puzzled by that.  Isn't this function called by v4l_querycap(),
> which is called by video_usercopy()?  And video_usercopy() zeroes the
> entire structure before doing so, or at least it appears to be intended
> to.

Right. So I don't understand this. Can you dig a bit deeper why this would
be needed here? It should not be necessary at all, so if reserved is non-zero,
then someone is writing data where it shouldn't.

Regards,

	Hans

> 
> Anyway, if we're failing to initialise kernel memory that's copied to
> user-space, that's a (usually minor) security issue and the fix ought to
> be cc'd to stable.
> 
> Ben.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

