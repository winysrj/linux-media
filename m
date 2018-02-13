Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42354 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935117AbeBMNJ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 08:09:27 -0500
Subject: Re: [PATCH v2 5/5] drm: adv7511: Add support for
 i2c_new_secondary_device
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        David Airlie <airlied@linux.ie>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Inki Dae <inki.dae@samsung.com>
References: <1518459117-16733-1-git-send-email-kbingham@kernel.org>
 <1518459117-16733-6-git-send-email-kbingham@kernel.org>
 <20180213072302.wlrqf5zgr7q26rsr@mwanda>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <320a656e-23eb-7aaa-bb8a-b7e542e60c9e@ideasonboard.com>
Date: Tue, 13 Feb 2018 13:09:22 +0000
MIME-Version: 1.0
In-Reply-To: <20180213072302.wlrqf5zgr7q26rsr@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan

Thank you for the review,

On 13/02/18 07:23, Dan Carpenter wrote:
> On Mon, Feb 12, 2018 at 06:11:57PM +0000, Kieran Bingham wrote:
>> +	adv7511->i2c_packet = i2c_new_secondary_device(i2c, "packet",
>> +					ADV7511_PACKET_I2C_ADDR_DEFAULT);
>> +	if (!adv7511->i2c_packet) {
>> +		ret = -EINVAL;
>> +		goto err_unregister_cec;
>> +	}
>> +
>> +	regmap_write(adv7511->regmap, ADV7511_REG_PACKET_I2C_ADDR,
>> +		     adv7511->i2c_packet->addr << 1);
>> +
>>  	INIT_WORK(&adv7511->hpd_work, adv7511_hpd_work);
>>  
>>  	if (i2c->irq) {
>> @@ -1181,7 +1190,7 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
>>  						IRQF_ONESHOT, dev_name(dev),
>>  						adv7511);
>>  		if (ret)
>> -			goto err_unregister_cec;
>> +			goto err_unregister_packet;
>>  	}
>>  
>>  	adv7511_power_off(adv7511);
> 
> There is another goto which needs to be updated if adv7511_cec_init()
> fails.

Aha - thanks - I'll look into this now.


> 
>> @@ -1203,6 +1212,8 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
>>  	adv7511_audio_init(dev, adv7511);
>>  	return 0;
>>  
>> +err_unregister_packet:
>> +	i2c_unregister_device(adv7511->i2c_packet);
>>  err_unregister_cec:
>>  	i2c_unregister_device(adv7511->i2c_cec);
>>  	if (adv7511->cec_clk)
> 
> 
> regards,
> dan carpenter
> 
