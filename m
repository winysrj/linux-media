Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34343 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750811AbdE3IkE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 04:40:04 -0400
Subject: Re: [ANN] HDMI CEC Status Update
To: Neil Armstrong <narmstrong@baylibre.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Maling list - DRI developers
        <dri-devel@lists.freedesktop.org>,
        Archit Taneja <architt@codeaurora.org>
References: <8e277103-8bc5-34b2-411d-e396665df249@xs4all.nl>
 <cddc746c-16a2-21b8-f76d-82773cd1941b@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2ea7cdb1-88c0-8e5f-df74-9cb3350eb7f5@xs4all.nl>
Date: Tue, 30 May 2017 10:39:55 +0200
MIME-Version: 1.0
In-Reply-To: <cddc746c-16a2-21b8-f76d-82773cd1941b@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/30/17 09:21, Neil Armstrong wrote:
> Hi Hans,
> 
> On 05/30/2017 08:53 AM, Hans Verkuil wrote:
>> For those who are interested in HDMI CEC support I made a little status
>> document that I intend to keep up to date:
>>
>> https://hverkuil.home.xs4all.nl/cec-status.txt
>>
>> My goal is to get CEC supported for any mainlined HDMI driver where the hardware
>> supports CEC.
>>
>> If anyone is working on a CEC driver that I don't know already about, just drop
>> me an email so I can update the status.
>>
>> I also started maintaining a list of DisplayPort to HDMI adapters that support
>> CEC. If you have one that works and is not on the list, then please let me know.
>> Seeing /dev/cecX is not enough, some adapters do not connect the CEC pin, so they
>> won't be able to detect any other CEC devices. See the test instructions in the
>> cec-status.txt file on how to make sure the adapter has a working CEC pin. I
>> plan to do some more testing this week, so hopefully the list will expand.
>>
>> Thanks!
>>
>>     Hans
> 
> Following our discussion on IRC,
> I'm working on a CEC driver for the standalone Amlogic CEC Controller that is able
> to wake up the device from Suspend or Power Off mode by passing infos to the FW.

FYI: the Pulse Eight linux driver has similar support. It has to be enabled via a
module option (persistent_config=1).

I have no public API for this, mostly because I would first like to get more information
about how these things are typically implemented in hardware.

Regards,

	Hans

> I initially planned to use the DW-HDMI CEC controller but I recently found out that
> on the Amlogic Meson GX SoCs, the CEC line can be pinmuxed to either an Amlogic custom
> controller or either to a Synopsys IP.
> 
> But it's connected to the Synopsys HDMI-RX controller... so my plan to use Russell's code
> is now dead.
> 
> Anyway, I'll still need to have the CEC notifier suport for DW-HDMI, so I made a rebase/cleanup
> of Russell's driver on 4.12-rc3 :
> https://github.com/superna9999/linux/commits/amlogic/v4.12/rmk-dw-hdmi-cec
> The rebase is aligned on dw-hdmi-i2s to use the bridge read/write ops.
> 
> Neil
> 
