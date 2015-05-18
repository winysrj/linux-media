Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:36696 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbbERKHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 06:07:16 -0400
MIME-Version: 1.0
In-Reply-To: <55599F8A.6030401@xs4all.nl>
References: <1431883124-4937-1-git-send-email-alexinbeijing@gmail.com>
 <20150518065158.GA17391@unicorn.suse.cz> <CA+V-a8uejJk+-hWWH81whaBbkMJQ3EoeRmxKGDB3HJ5v__0qVw@mail.gmail.com>
 <55599F8A.6030401@xs4all.nl>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 18 May 2015 11:06:43 +0100
Message-ID: <CA+V-a8vvt_MmO8=WhnYuYowhQwuJSV8qh+Y3-0cZVmA5DwZ1Gw@mail.gmail.com>
Subject: Re: [PATCH] Clarify expression which uses both multiplication and
 pointer dereference
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Michal Kubecek <mkubecek@suse.cz>,
	Alex Dowad <alexinbeijing@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
	"open list:STAGING SUBSYSTEM <devel@driverdev.osuosl.org>, open list"
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, May 18, 2015 at 9:15 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>
> On 05/18/2015 10:06 AM, Lad, Prabhakar wrote:
>> On Mon, May 18, 2015 at 7:51 AM, Michal Kubecek <mkubecek@suse.cz> wrote:
>>> On Sun, May 17, 2015 at 07:18:42PM +0200, Alex Dowad wrote:
>>>> This fixes a checkpatch style error in vpfe_buffer_queue_setup.
>>>>
>>>> Signed-off-by: Alex Dowad <alexinbeijing@gmail.com>
>>>> ---
>>>>  drivers/staging/media/davinci_vpfe/vpfe_video.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
>>>> index 06d48d5..04a687c 100644
>>>> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
>>>> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
>>>> @@ -1095,7 +1095,7 @@ vpfe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
>>>>       size = video->fmt.fmt.pix.sizeimage;
>>>>
>>>>       if (vpfe_dev->video_limit) {
>>>> -             while (size * *nbuffers > vpfe_dev->video_limit)
>>>> +             while (size * (*nbuffers) > vpfe_dev->video_limit)
>>>>                       (*nbuffers)--;
>>>>       }
>>>>       if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS) {
>>>
>>> Style issue aside, is there a reason not to use
>>>
>>>                 if (size * *nbuffers > vpfe_dev->video_limit)
>>>                         *nbuffers = vpfe_dev->video_limit / size;
>>>
>>> instead?
>>>
>> I would prefer this.
>
> As far as I can see video_limit is never set at all, so this code (and the video_limit
> field) can just be removed.
>
> I think this is a left-over from old code, long since removed.
>
Yes makes sense, I'll fix it up and post a patch for it.

Cheers,
--Prabhakar Lad
