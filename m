Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:48459 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753973AbeGCJdQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Jul 2018 05:33:16 -0400
Subject: Re: [PATCHv15 01/35] uapi/linux/media.h: add request API
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
 <20180604114648.26159-2-hverkuil@xs4all.nl>
 <20180703062131.46cb4179@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6009b87f-4eae-0ea3-9e72-e5bd4bb85d59@xs4all.nl>
Date: Tue, 3 Jul 2018 11:33:13 +0200
MIME-Version: 1.0
In-Reply-To: <20180703062131.46cb4179@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/07/18 11:21, Mauro Carvalho Chehab wrote:
> Em Mon,  4 Jun 2018 13:46:14 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Define the public request API.
>>
>> This adds the new MEDIA_IOC_REQUEST_ALLOC ioctl to allocate a request
>> and two ioctls that operate on a request in order to queue the
>> contents of the request to the driver and to re-initialize the
>> request.
> 
> It would be better if you had added the documentation stuff here...
> I can't review this patch without first reviewing the documentation
> for the new ioctls...

I moved patch 29 to the front for the next version.

Regards,

	Hans
