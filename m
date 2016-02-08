Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36090 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbcBHHkM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 02:40:12 -0500
Received: by mail-ig0-f172.google.com with SMTP id xg9so50138160igb.1
        for <linux-media@vger.kernel.org>; Sun, 07 Feb 2016 23:40:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1672061.k75230d3Eh@avalon>
References: <CAJfOKByVva72g_1kJyMKGFHr2Jz+Yo6BgZPp_EENj9m4vXOHBA@mail.gmail.com>
	<1672061.k75230d3Eh@avalon>
Date: Mon, 8 Feb 2016 08:40:11 +0100
Message-ID: <CAJfOKBymfpRHx5XXLPP1+zAJ+N_C7bzW-pJTvj8S8uGWixNw0w@mail.gmail.com>
Subject: Re: Use xilinx video drivers in PCIe device
From: Franck Jullien <franck.jullien@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Chris Kohn <christian.kohn@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-02-04 10:45 GMT+01:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Frank,
>
> On Tuesday 02 February 2016 17:05:06 Franck Jullien wrote:
>> Hi,
>>
>> I need to use a Xilinx video infrastructure on a PCIe board.
>> As far as I understand it, all Xilinx video drivers make use of the
>> device-tree for configuration.
>
> Correct. Those drivers target the Xilinx SoC FPGAs, no standalone FPGAs
> connected to an external CPU.
>
>> However, my idea is to create a MFD device to bind video drivers. That
>> would require Xilinx video drivers to check platform_data and continue
>> with device tree configuration if it is null or use platform data if
>> available.
>>
>> Do you think such a change in Xilinx drivers can be considered
>> upstream ? Is this the way to go ?
>
> Your use case is certainly valid, so I'm certainly open to supporting it in
> the drivers.
>
> I'm wondering whether your MFD decide driver could create a DT fragment to
> describe the IP cores topology. That way we could reuse the existing DT
> support in individual drivers.
>

I'm working on such a solution (DT framgent, or more precisely
devitree dynamic feature).
I'll keep you informed whenever I get something usable.

Franck.
