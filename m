Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:23132 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbdIUJ7a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 05:59:30 -0400
Subject: Re: [RESEND RFC PATCH 0/7] sun8i H3 HDMI glue driver for DW HDMI
To: Jose Abreu <Jose.Abreu@synopsys.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        maxime.ripard@free-electrons.com, wens@csie.org
Cc: Laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
        narmstrong@baylibre.com, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        icenowy@aosc.io, linux-sunxi@googlegroups.com,
        linux-media@vger.kernel.org
References: <20170920200124.20457-1-jernej.skrabec@siol.net>
 <5172c185-c6b5-49c3-cf0a-c3e073459346@synopsys.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <68fa56f8-9878-12d0-1696-4393abe45db5@cisco.com>
Date: Thu, 21 Sep 2017 11:59:27 +0200
MIME-Version: 1.0
In-Reply-To: <5172c185-c6b5-49c3-cf0a-c3e073459346@synopsys.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/21/17 11:39, Jose Abreu wrote:
> Hi Jernej,
> 
> On 20-09-2017 21:01, Jernej Skrabec wrote:
>> [added media mailing list due to CEC question]
>>
>> This patch series adds a HDMI glue driver for Allwinner H3 SoC. For now, only
>> video and CEC functionality is supported. Audio needs more tweaks.
>>
>> Series is based on the H3 DE2 patch series available on mailing list:
>> https://urldefense.proofpoint.com/v2/url?u=http-3A__lists.infradead.org_pipermail_linux-2Darm-2Dkernel_2017-2DAugust_522697.html&d=DwIBAg&c=DPL6_X_6JkXFx7AXWqB0tg&r=WHDsc6kcWAl4i96Vm5hJ_19IJiuxx_p_Rzo2g-uHDKw&m=coyfcQKSr2asrHcaCeWFmAP_9nkFkRK8s7Uw5bmVei4&s=JCFaMXK1MmZ3jE745_YcqZhZkaqtc6UapGfSSapcz_s&e= 
>> (ignore patches marked with [NOT FOR REVIEW NOW] tag)
>>
>> Patch 1 adds support for polling plug detection since custom PHY used here
>> doesn't support HPD interrupt.
>>
>> Patch 2 enables overflow workaround for v1.32a. This HDMI controller exhibits
>> same issues as HDMI controller used in iMX6 SoCs.
>>
>> Patch 3 adds CLK_SET_RATE_PARENT to hdmi clock.
>>
>> Patch 4 adds dt bindings documentation.
>>
>> Patch 5 adds actual H3 HDMI glue driver.
>>
>> Patch 6 and 7 add HDMI node to DT and enable it where needed.
>>
>> Allwinner used DW HDMI controller in a non standard way:
>> - register offsets obfuscation layer, which can fortunately be turned off
>> - register read lock, which has to be disabled by magic number
>> - custom PHY, which have to be initialized before DW HDMI controller
>> - non standard clocks
>> - no HPD interrupt
>>
>> Because of that, I have two questions:
>> - Since HPD have to be polled, is it enough just to enable poll mode? I'm
>>   mainly concerned about invalidating CEC address here.
> 
> You mean you get no interrupt when HPD status changes? Hans can
> answer this better but then you will need to invalidate the cec
> physical address yourself because right now its invalidated in
> the dw-hdmi irq handler (see dw_hdmi_irq()).

That's correct. When the HPD goes low you need to call cec_notifier_phys_addr_invalidate()
to invalidate the physical address. This is not terribly time sensitive, i.e.
checking this once a second would be quick enough.

Regards,

	Hans
