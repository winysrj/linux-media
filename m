Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:36352 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725997AbeJEEfZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 00:35:25 -0400
Subject: Re: [PATCH 1/2] media: add SECO cec driver
To: ektor5 <ek5.chimenti@gmail.com>
Cc: jacopo mondi <jacopo@jmondi.org>, luca.pisani@udoo.org,
        jose.abreu@synopsys.com, sean@mess.org,
        sakari.ailus@linux.intel.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
References: <cover.1538474121.git.ek5.chimenti@gmail.com>
 <c212cb1142a412f980176b9c86fa7f6c96092cb1.1538474121.git.ek5.chimenti@gmail.com>
 <20181003093532.GF20786@w540>
 <c2bfdb30-e8ed-7a4e-422d-ca852db988e9@xs4all.nl>
 <20181004213150.rdqhwpmtza3ez57p@Ettosoft-T55>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bc3fae06-80fb-06a2-339d-cd8c23a30906@xs4all.nl>
Date: Thu, 4 Oct 2018 23:39:58 +0200
MIME-Version: 1.0
In-Reply-To: <20181004213150.rdqhwpmtza3ez57p@Ettosoft-T55>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/04/2018 11:31 PM, ektor5 wrote:
> Hi Hans,
> 
>>>> +static int secocec_cec_get_notifier(struct cec_notifier **notify)
>>
>> If you compare this driver with cros-ec-cec.c, then you'll see that
>> there this function is under "#if IS_ENABLED(CONFIG_PCI) && IS_ENABLED(CONFIG_DMI)".
>>
>> I think you should do the same and (just like cros-ec-cec.c) add a dummy function
>> in the #else part.
> 
> I'm not sure about this. Doing so, compiling without CONFIG_PCI or
> CONFIG_DMI, it will fail later when no notifier is found (now it will
> probably fail at compile time). Should I select them in the Kconfig or
> it is better to eventually disable the notifier and go on adding
> CEC_CAP_PHYS_ADDR to device capabilities?

After thinking about this some more, you can just add:

depends on PCI && DMI

in the Kconfig.

Much easier, really.

Regards,

	Hans
