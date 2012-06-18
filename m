Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab2FRMDm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 08:03:42 -0400
Message-ID: <4FDF1902.8060808@redhat.com>
Date: Mon, 18 Jun 2012 09:03:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 18/32] v4l2-ioctl.c: finalize table conversion.
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <10390224.oHYD7VJvJs@avalon> <4FDF07FB.1080802@redhat.com> <201206181349.56977.hverkuil@xs4all.nl>
In-Reply-To: <201206181349.56977.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-06-2012 08:49, Hans Verkuil escreveu:
> On Mon June 18 2012 12:50:35 Mauro Carvalho Chehab wrote:
>> Em 18-06-2012 06:46, Laurent Pinchart escreveu:
>>> Hi Hans,
>>>
>>> Thanks for the patch.
>>>
>>> On Sunday 10 June 2012 12:25:40 Hans Verkuil wrote:
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>>    drivers/media/video/v4l2-ioctl.c |   35 +++++++++++++----------------------
>>>> 1 file changed, 13 insertions(+), 22 deletions(-)
>>>>
>>>> diff --git a/drivers/media/video/v4l2-ioctl.c
>>>> b/drivers/media/video/v4l2-ioctl.c index 0de31c4..6c91674 100644
>>>> --- a/drivers/media/video/v4l2-ioctl.c
>>>> +++ b/drivers/media/video/v4l2-ioctl.c
>>>> @@ -870,6 +870,11 @@ static void v4l_print_newline(const void *arg)
>>>>    	pr_cont("\n");
>>>>    }
>>>>
>>>> +static void v4l_print_default(const void *arg)
>>>> +{
>>>> +	pr_cont("non-standard ioctl\n");
>>>
>>> I'd say "driver-specific ioctl" instead. "non-standard" may sound like an
>>> error to users.
>>
>> This message is useless as-is, as it provides no glue about what ioctl was
>> called. You should either remove it or print the ioctl number, in hexa.
> 
> That ioctl number is already printed in front of this message.

Hmm... should we print it when the ioctl is known? IMHO, the behavior should be to
either print the ioctl name or its number, as those debug messages are generally big.
So, better to not pollute it with duplicated information.
> 
> Regards,
> 
> 	Hans
> 


