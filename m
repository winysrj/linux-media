Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41497 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZDBRuX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 13:50:23 -0400
Received: by fxm2 with SMTP id 2so643343fxm.37
        for <linux-media@vger.kernel.org>; Thu, 02 Apr 2009 10:50:19 -0700 (PDT)
Message-ID: <49D4FAF0.9060305@gmail.com>
Date: Thu, 02 Apr 2009 20:50:40 +0300
From: Darius Augulis <augulis.darius@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	paulius.zaleckas@teltonika.lt,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [RFC PATCH V2] Add camera (CSI) driver for MX1
References: <20090330145310.20826.77060.stgit@localhost.localdomain> <Pine.LNX.4.64.0904010034300.12031@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0904010034300.12031@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>> + * struct mx1_camera_pdata - i.MX1/i.MXL camera platform data
>> + * @init:	Init board resources
>> + * @exit:	Release board resources
>> + * @mclk_10khz:	master clock frequency in 10kHz units
>> + * @flags:	MX1 camera platform flags
>> + */
>> +struct mx1_camera_pdata {
>> +	int (*init)(struct device *);
>> +	int (*exit)(struct device *);
>>     
>
> I thought the agreement was to avoid these .init() and .exit() hooks in 
> new code...
>   

Should I config board statically during system start-up?


>> +static void mx1_videobuf_queue(struct videobuf_queue *vq,
>> +						struct videobuf_buffer *vb)
>> +{
>> +	struct soc_camera_device *icd = vq->priv_data;
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct mx1_camera_dev *pcdev = ici->priv;
>> +	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
>> +
>> +	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
>> +		vb, vb->baddr, vb->bsize);
>> +
>> +	list_add_tail(&vb->queue, &pcdev->capture);
>>     
>
> No, you had a spinlock here and in DMA ISR in the previous version, and it 
> was correct. Without that lock the above list_add races with 
> list_del_init() in mx1_camera_wakeup().
>   

what can save and help for the spinlock on single-core system? mx3 there 
does not have spinlock.

