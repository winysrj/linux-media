Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:49880 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbbEUMqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 08:46:48 -0400
Message-ID: <555DD3B4.2080308@codethink.co.uk>
Date: Thu, 21 May 2015 13:46:44 +0100
From: Rob Taylor <rob.taylor@codethink.co.uk>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
CC: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH 13/20] media: soc_camera: v4l2-compliance fixes for querycap
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk> <1432139980-12619-14-git-send-email-william.towle@codethink.co.uk> <555D7419.8000303@xs4all.nl>
In-Reply-To: <555D7419.8000303@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/05/15 06:58, Hans Verkuil wrote:
> On 05/20/2015 06:39 PM, William Towle wrote:
>> Fill in bus_info field and zero reserved field.
>>
>> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
>> Reviewed-by: William Towle <william.towle@codethink.co.uk>
>> ---
>>  drivers/media/platform/soc_camera/soc_camera.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
>> index fd7497e..583c5e6 100644
>> --- a/drivers/media/platform/soc_camera/soc_camera.c
>> +++ b/drivers/media/platform/soc_camera/soc_camera.c
>> @@ -954,6 +954,8 @@ static int soc_camera_querycap(struct file *file, void  *priv,
>>  	WARN_ON(priv != file->private_data);
>>  
>>  	strlcpy(cap->driver, ici->drv_name, sizeof(cap->driver));
>> +	strlcpy(cap->bus_info, "platform:soc_camera", sizeof(cap->bus_info));
>> +	memset(cap->reserved, 0, sizeof(cap->reserved));
> 
> Why the memset? That shouldn't be needed.

v4l2-complience complained it wasn't zero (v4l2-compliance.cpp:308 in
v4l-utils v1.6.2 [1])

Thanks,
Rob

[1]
http://git.linuxtv.org/cgit.cgi/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-compliance.cpp?id=v4l-utils-1.6.2#n308
> Regards,
> 
> 	Hans
> 
>>  	return ici->ops->querycap(ici, cap);
>>  }
>>  
>>
> 

