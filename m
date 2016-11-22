Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:33417 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753695AbcKVAKV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 19:10:21 -0500
Received: by mail-pg0-f45.google.com with SMTP id 3so793579pgd.0
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2016 16:10:21 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        Bartosz =?utf-8?Q?Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>
Subject: Re: [PATCH 2/4] [media] davinci: vpif_capture: don't lock over s_stream
References: <20161119003208.10550-1-khilman@baylibre.com>
        <20161119003208.10550-2-khilman@baylibre.com>
        <f385c65b-1f73-a5b1-b498-43916d5bdfb6@xs4all.nl>
Date: Mon, 21 Nov 2016 16:10:19 -0800
In-Reply-To: <f385c65b-1f73-a5b1-b498-43916d5bdfb6@xs4all.nl> (Hans Verkuil's
        message of "Mon, 21 Nov 2016 15:37:20 +0100")
Message-ID: <m237ik1ij8.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 19/11/16 01:32, Kevin Hilman wrote:
>> Video capture subdevs may be over I2C and may sleep during xfer, so we
>> cannot do IRQ-disabled locking when calling the subdev.
>>
>> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
>> ---
>>  drivers/media/platform/davinci/vpif_capture.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
>> index 79cef74e164f..becc3e63b472 100644
>> --- a/drivers/media/platform/davinci/vpif_capture.c
>> +++ b/drivers/media/platform/davinci/vpif_capture.c
>> @@ -193,12 +193,16 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>>  		}
>>  	}
>>
>> +	spin_unlock_irqrestore(&common->irqlock, flags);
>> +
>>  	ret = v4l2_subdev_call(ch->sd, video, s_stream, 1);
>>  	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
>>  		vpif_dbg(1, debug, "stream on failed in subdev\n");
>>  		goto err;
>>  	}
>>
>> +	spin_lock_irqsave(&common->irqlock, flags);
>
> This needs to be moved to right after the v4l2_subdev_call, otherwise the
> goto err above will not have the spinlock.

Yes indeed.  Will respin.

Kevin
