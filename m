Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33743 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451Ab2BMOlS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Feb 2012 09:41:18 -0500
Received: by lagu2 with SMTP id u2so3945531lag.19
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2012 06:41:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1202131508080.8277@axis700.grange>
References: <1329141115-23133-1-git-send-email-javier.martin@vista-silicon.com>
	<1329141115-23133-6-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1202131508080.8277@axis700.grange>
Date: Mon, 13 Feb 2012 15:41:15 +0100
Message-ID: <CACKLOr3KeCTpee40LMyRnQ9BpSC0v2QxJS6R74YZnENN9a6HLw@mail.gmail.com>
Subject: Re: [PATCH 5/6] media: i.MX27 camera: fix compilation warning.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13 February 2012 15:10, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Hi Javier
>
> On Mon, 13 Feb 2012, Javier Martin wrote:
>
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  drivers/media/video/mx2_camera.c |   16 ++++++++--------
>>  1 files changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
>> index d9028f1..8ccdb4a 100644
>> --- a/drivers/media/video/mx2_camera.c
>> +++ b/drivers/media/video/mx2_camera.c
>> @@ -1210,7 +1210,9 @@ static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
>>  static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>>               int bufnum, bool err)
>>  {
>> +#ifdef DEBUG
>>       struct mx2_fmt_cfg *prp = pcdev->emma_prp;
>> +#endif
>>       struct mx2_buffer *buf;
>>       struct vb2_buffer *vb;
>>       unsigned long phys;
>> @@ -1232,18 +1234,16 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>>               if (prp->cfg.channel == 1) {
>>                       if (readl(pcdev->base_emma + PRP_DEST_RGB1_PTR +
>>                               4 * bufnum) != phys) {
>> -                             dev_err(pcdev->dev, "%p != %p\n", phys,
>> -                                             readl(pcdev->base_emma +
>> -                                                     PRP_DEST_RGB1_PTR +
>> -                                                     4 * bufnum));
>> +                             dev_err(pcdev->dev, "%p != %p\n", (void *)phys,
>> +                                     (void *)readl(pcdev->base_emma +
>> +                                     PRP_DEST_RGB1_PTR + 4 * bufnum));
>>                       }
>>               } else {
>>                       if (readl(pcdev->base_emma + PRP_DEST_Y_PTR -
>>                               0x14 * bufnum) != phys) {
>> -                             dev_err(pcdev->dev, "%p != %p\n", phys,
>> -                                             readl(pcdev->base_emma +
>> -                                                     PRP_DEST_Y_PTR -
>> -                                                     0x14 * bufnum));
>> +                             dev_err(pcdev->dev, "%p != %p\n", (void *)phys,
>> +                                     (void *)readl(pcdev->base_emma +
>> +                                     PRP_DEST_Y_PTR - 0x14 * bufnum));
>
> I think, just using %lx would be better.

Fixed.
Please, see v2.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
