Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab1J1Ifj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Oct 2011 04:35:39 -0400
Message-ID: <4EAA696A.1090301@redhat.com>
Date: Fri, 28 Oct 2011 10:35:54 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 4/6] v4l2-event: Don't set sev->fh to NULL on unsubcribe
References: <1319714283-3991-1-git-send-email-hdegoede@redhat.com> <1319714283-3991-5-git-send-email-hdegoede@redhat.com> <201110271420.04488.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201110271420.04488.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the reviews!

On 10/27/2011 02:20 PM, Laurent Pinchart wrote:
> Hi Hans,
>
> On Thursday 27 October 2011 13:18:01 Hans de Goede wrote:
>> 1: There is no reason for this after v4l2_event_unsubscribe releases the
>> spinlock nothing is holding a reference to the sev anymore except for the
>> local reference in the v4l2_event_unsubscribe function.
>>
>> 2: Setting sev->fh to NULL causes problems for the del op added in the next
>> patch of this series, since this op needs a way to get to its own data
>> structures, and typically this will be done by using container_of on an
>> embedded v4l2_fh struct.
>>
>> Signed-off-by: Hans de Goede<hdegoede@redhat.com>
>
> Acked-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
>
> While reviewing the patch I noticed that v4l2_event_unsubscribe_all() calls
> v4l2_event_unsubscribe(), which performs control lookup again. Is there a
> reason for that, instead of handling event unsubscription directly in
> v4l2_event_unsubscribe_all() ?

I didn't write that part, so I'll let Hans V. answer this question.

Regards,

Hans
