Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:42997 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752713AbcHONbU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 09:31:20 -0400
Subject: Re: [PATCH v3 09/14] media: platform: pxa_camera: add buffer
 sequencing
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
 <1470684652-16295-10-git-send-email-robert.jarzmik@free.fr>
 <87mvkeqi1q.fsf@belgarion.home>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9883272f-cffd-e550-f784-32977bace0c0@xs4all.nl>
Date: Mon, 15 Aug 2016 15:31:14 +0200
MIME-Version: 1.0
In-Reply-To: <87mvkeqi1q.fsf@belgarion.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/15/2016 03:26 PM, Robert Jarzmik wrote:
> Robert Jarzmik <robert.jarzmik@free.fr> writes:
> 
>> Add sequence numbers to completed buffers.
>>
>> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
>> ---
>>  drivers/media/platform/soc_camera/pxa_camera.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
>> index d66443ac1f4d..8a65f126d091 100644
>> --- a/drivers/media/platform/soc_camera/pxa_camera.c
>> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
>> @@ -401,6 +402,7 @@ static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
>>  	unsigned long cicr0;
>>  
>>  	dev_dbg(pcdev_to_dev(pcdev), "%s\n", __func__);
>> +	pcdev->buf_sequence = 0;
> 
> I'm not so sure this is the right place to reset the buffer sequence.
> 
> I've seen no documentation on the rules applicable to this sequence number:
>  - should it be reset if a "start streaming" operation occurs ?

start_streaming is the recommended place for setting the counter to 0. It's what
v4l2-compliance expects.

It is not documented since 1) not every driver does this and 2) there may
be cases where this behavior is not desired.

That said, I have yet to see a driver where zeroing this in start_streaming
is not appropriate.

Regards,

	Hans

>  - should it be reset if a streams stops by lack of video buffers queued ?
>  - should it be reset in queue_setup() like in other drivers ?
> 
> Or should it _never_ be reset and only be a monotonic raising number ?
> 
> Cheers.
> 
> --
> Robert
> 
