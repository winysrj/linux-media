Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:53267 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752005AbdGYNqD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 09:46:03 -0400
Subject: Re: [PATCH v2 1/2] platform: Add Amlogic Meson AO CEC Controller
 driver
To: Neil Armstrong <narmstrong@baylibre.com>, mchehab@kernel.org,
        hans.verkuil@cisco.com
References: <1499673696-21372-1-git-send-email-narmstrong@baylibre.com>
 <1499673696-21372-2-git-send-email-narmstrong@baylibre.com>
 <b5cb7021-4c9e-98b2-5fd1-11effda3fd30@xs4all.nl>
 <f6e40d38-fe18-49e6-0ee1-a4467666777c@baylibre.com>
Cc: linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6f93edd0-098e-6cbc-9eea-99dd68ab3420@xs4all.nl>
Date: Tue, 25 Jul 2017 15:45:51 +0200
MIME-Version: 1.0
In-Reply-To: <f6e40d38-fe18-49e6-0ee1-a4467666777c@baylibre.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/25/17 14:34, Neil Armstrong wrote:
> Hi Hans,

>>> +static int meson_ao_cec_probe(struct platform_device *pdev)
>>> +{
>>> +	struct meson_ao_cec_device *ao_cec;
>>> +	struct platform_device *hdmi_dev;
>>> +	struct device_node *np;
>>> +	struct resource *res;
>>> +	int ret, irq;
>>> +
>>> +	np = of_parse_phandle(pdev->dev.of_node, "hdmi-phandle", 0);
>>> +	if (!np) {
>>> +		dev_err(&pdev->dev, "Failed to find hdmi node\n");
>>> +		return -ENODEV;
>>> +	}
>>> +
>>> +	hdmi_dev = of_find_device_by_node(np);
>>> +	if (hdmi_dev == NULL)
>>> +		return -EPROBE_DEFER;
>>> +
>>> +	ao_cec = devm_kzalloc(&pdev->dev, sizeof(*ao_cec), GFP_KERNEL);
>>> +	if (!ao_cec)
>>> +		return -ENOMEM;
>>> +
>>> +	spin_lock_init(&ao_cec->cec_reg_lock);
>>> +
>>> +	ao_cec->notify = cec_notifier_get(&hdmi_dev->dev);
>>> +	if (!ao_cec->notify)
>>> +		return -ENOMEM;
>>> +
>>> +	ao_cec->adap = cec_allocate_adapter(&meson_ao_cec_ops, ao_cec,
>>> +					    "meson_ao_cec",
>>> +					    CEC_CAP_LOG_ADDRS |
>>> +					    CEC_CAP_TRANSMIT |
>>> +					    CEC_CAP_RC |
>>> +					    CEC_CAP_PASSTHROUGH,
>>> +					    1); /* Use 1 for now */
>>
>> I recommend that you add support for 2 logical addresses. More isn't allowed
>> by the CEC 2.0 spec anyway (no such restriction for CEC 1.4, but more than
>> two really isn't needed).
> 
> I know, but in the "communication" register with the suspend/poweroff firmware
> that  handles the wake up, only a single logical address is supported...
> 
> What should I do in this case ? Which logical adress should I pass to the firmware when implementing ir ?

Ah, OK. Interesting.

>From cec-adap.c:

                if (log_addrs->num_log_addrs == 2) {
                        if (!(type_mask & ((1 << CEC_LOG_ADDR_TYPE_AUDIOSYSTEM) |
                                           (1 << CEC_LOG_ADDR_TYPE_TV)))) {
                                dprintk(1, "two LAs is only allowed for audiosystem and TV\n");
                                return -EINVAL;
                        }
                        if (!(type_mask & ((1 << CEC_LOG_ADDR_TYPE_PLAYBACK) |
                                           (1 << CEC_LOG_ADDR_TYPE_RECORD)))) {
                                dprintk(1, "an audiosystem/TV can only be combined with record or playback\n");
                                return -EINVAL;
                        }
                }

So you would store the TV or AUDIOSYSTEM logical address in the firmware, since those
describe the system best.

I.e. it is a TV/Audiosystem with recording/playback capabilities.

The problem is that for CEC 1.4 no such restriction is imposed (the test above is
specific to CEC 2.0). But I think it makes sense to just check if TV/Audiosystem
is selected and pick that as the LA to store in the firmware, and otherwise just
pick the first LA (log_addr[0]).

Regards,

	Hans
