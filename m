Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42239 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802Ab2B0K7x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 05:59:53 -0500
Received: by lahj13 with SMTP id j13so707044lah.19
        for <linux-media@vger.kernel.org>; Mon, 27 Feb 2012 02:59:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1202270945210.32434@axis700.grange>
References: <1329908374-19769-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1202270945210.32434@axis700.grange>
Date: Mon, 27 Feb 2012 11:59:51 +0100
Message-ID: <CACKLOr0QeXLw73pMZcWLT8hRAkejkrQGq0f6n3=UKxmXHKkPUg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] media: i.MX27 camera: Use list_first_entry()
 whenever possible.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de,
	mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27 February 2012 09:49, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Hi Javier
>
> On Wed, 22 Feb 2012, Javier Martin wrote:
>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  Changes since v1:
>>  - Adapt to [PATCH v4 4/4] media i.MX27 camera: handle overflows properly.
>>
>> ---
>>  drivers/media/video/mx2_camera.c |   26 ++++++++++++--------------
>>  1 files changed, 12 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
>> index 0ade14e..7793264 100644
>> --- a/drivers/media/video/mx2_camera.c
>> +++ b/drivers/media/video/mx2_camera.c
>
> [snip]
>
>> @@ -1314,7 +1312,7 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
>>                      pcdev->base_emma + PRP_CNTL);
>>               writel(cntl, pcdev->base_emma + PRP_CNTL);
>>
>> -             buf = list_entry(pcdev->active_bufs.next,
>> +             buf = list_first_entry(pcdev->active_bufs.next,
>
> This is the only hunk, that you've changed. I'll fix this to be
>
> +               buf = list_first_entry(&pcdev->active_bufs,
>
>>                       struct mx2_buffer, queue);
>>               mx27_camera_frame_done_emma(pcdev,
>>                                       buf->bufnum, true);
>

Looks OK.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
