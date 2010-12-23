Return-path: <mchehab@gaivota>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55865 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0LWGes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 01:34:48 -0500
Received: by wwi17 with SMTP id 17so5845482wwi.1
        for <linux-media@vger.kernel.org>; Wed, 22 Dec 2010 22:34:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012222138.43382.hverkuil@xs4all.nl>
References: <201012221601.37554.hverkuil@xs4all.nl> <1293037826-13420-1-git-send-email-pawel@osciak.com>
 <201012222138.43382.hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Wed, 22 Dec 2010 22:34:26 -0800
Message-ID: <AANLkTinr9oH0UfL82ZW8pgZBhww_xdcuHKuTdB6e1ehq@mail.gmail.com>
Subject: Re: [PATCH 02/13] v4l: Add multi-planar ioctl handling code
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: m.szyprowski@samsung.com, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	andrzej.p@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, Dec 22, 2010 at 12:38, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Wednesday, December 22, 2010 18:10:26 Pawel Osciak wrote:
>> From: Pawel Osciak <p.osciak@samsung.com>
>>
>> Add multi-planar API core ioctl handling and conversion functions.
>>
>> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>  drivers/media/video/v4l2-ioctl.c |  453 ++++++++++++++++++++++++++++++++++----
>>  include/media/v4l2-ioctl.h       |   16 ++
>>  2 files changed, 425 insertions(+), 44 deletions(-)
>>
>> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
>> index 8516669..e2f6abb 100644
>> --- a/drivers/media/video/v4l2-ioctl.c
>> +++ b/drivers/media/video/v4l2-ioctl.c
>
> <snip>
>
> OK, looks good.
>
> Marek, this patch + the other patches from your v8 patch series are good to
> go as far as I am concerned. So you can add my tag to the whole series:
>
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
>
> The only note I want to make is that the V4L2 DocBook spec needs to be updated
> for the multiplanar API. But in my opinion that patch can be done in January.

Thanks.
Yes, I have the DocBook update on my todo list, will take care of it
as soon as possible.

-- 
Best regards,
Pawel Osciak
