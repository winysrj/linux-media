Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:32872 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdG0Onu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 10:43:50 -0400
Received: by mail-wr0-f172.google.com with SMTP id v105so114317090wrb.0
        for <linux-media@vger.kernel.org>; Thu, 27 Jul 2017 07:43:50 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] platform: Add Amlogic Meson AO CEC Controller
 driver
To: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1499673696-21372-1-git-send-email-narmstrong@baylibre.com>
 <1499673696-21372-2-git-send-email-narmstrong@baylibre.com>
 <b5cb7021-4c9e-98b2-5fd1-11effda3fd30@xs4all.nl>
 <f6e40d38-fe18-49e6-0ee1-a4467666777c@baylibre.com>
 <6f93edd0-098e-6cbc-9eea-99dd68ab3420@xs4all.nl>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <9acecab0-7dda-9aa1-fa07-886d40f6c7df@baylibre.com>
Date: Thu, 27 Jul 2017 16:43:46 +0200
MIME-Version: 1.0
In-Reply-To: <6f93edd0-098e-6cbc-9eea-99dd68ab3420@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/25/2017 03:45 PM, Hans Verkuil wrote:
> On 07/25/17 14:34, Neil Armstrong wrote:
>> Hi Hans,
> 
>>>> +static int meson_ao_cec_probe(struct platform_device *pdev)
>>>> +{
>>>> +	struct meson_ao_cec_device *ao_cec;
>>>> +	struct platform_device *hdmi_dev;
>>>> +	struct device_node *np;
>>>> +	struct resource *res;
>>>> +	int ret, irq;
>>>> +
>>>> +	np = of_parse_phandle(pdev->dev.of_node, "hdmi-phandle", 0);
>>>> +	if (!np) {
>>>> +		dev_err(&pdev->dev, "Failed to find hdmi node\n");
>>>> +		return -ENODEV;
>>>> +	}
>>>> +
>>>> +	hdmi_dev = of_find_device_by_node(np);
>>>> +	if (hdmi_dev == NULL)
>>>> +		return -EPROBE_DEFER;
>>>> +
>>>> +	ao_cec = devm_kzalloc(&pdev->dev, sizeof(*ao_cec), GFP_KERNEL);
>>>> +	if (!ao_cec)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	spin_lock_init(&ao_cec->cec_reg_lock);
>>>> +
>>>> +	ao_cec->notify = cec_notifier_get(&hdmi_dev->dev);
>>>> +	if (!ao_cec->notify)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	ao_cec->adap = cec_allocate_adapter(&meson_ao_cec_ops, ao_cec,
>>>> +					    "meson_ao_cec",
>>>> +					    CEC_CAP_LOG_ADDRS |
>>>> +					    CEC_CAP_TRANSMIT |
>>>> +					    CEC_CAP_RC |
>>>> +					    CEC_CAP_PASSTHROUGH,
>>>> +					    1); /* Use 1 for now */
>>>
>>> I recommend that you add support for 2 logical addresses. More isn't allowed
>>> by the CEC 2.0 spec anyway (no such restriction for CEC 1.4, but more than
>>> two really isn't needed).
>>
>> I know, but in the "communication" register with the suspend/poweroff firmware
>> that  handles the wake up, only a single logical address is supported...
>>
>> What should I do in this case ? Which logical adress should I pass to the firmware when implementing ir ?
> 
> Ah, OK. Interesting.
> 
> From cec-adap.c:
> 
>                 if (log_addrs->num_log_addrs == 2) {
>                         if (!(type_mask & ((1 << CEC_LOG_ADDR_TYPE_AUDIOSYSTEM) |
>                                            (1 << CEC_LOG_ADDR_TYPE_TV)))) {
>                                 dprintk(1, "two LAs is only allowed for audiosystem and TV\n");
>                                 return -EINVAL;
>                         }
>                         if (!(type_mask & ((1 << CEC_LOG_ADDR_TYPE_PLAYBACK) |
>                                            (1 << CEC_LOG_ADDR_TYPE_RECORD)))) {
>                                 dprintk(1, "an audiosystem/TV can only be combined with record or playback\n");
>                                 return -EINVAL;
>                         }
>                 }
> 
> So you would store the TV or AUDIOSYSTEM logical address in the firmware, since those
> describe the system best.
> 
> I.e. it is a TV/Audiosystem with recording/playback capabilities.
> 
> The problem is that for CEC 1.4 no such restriction is imposed (the test above is
> specific to CEC 2.0). But I think it makes sense to just check if TV/Audiosystem
> is selected and pick that as the LA to store in the firmware, and otherwise just
> pick the first LA (log_addr[0]).


Ok I'll add support for dual LA, and I'll do this LA selection when I'll add firmware support.

Thanks,
Neil


> Regards,
> 
> 	Hans
> 
