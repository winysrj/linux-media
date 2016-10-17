Return-path: <linux-media-owner@vger.kernel.org>
Received: from eumx.net ([91.82.101.43]:39868 "EHLO owm.eumx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753136AbcJQLjg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 07:39:36 -0400
Subject: Re: [PATCH v2 08/21] [media] imx: Add i.MX IPUv3 capture driver
To: Marek Vasut <marex@denx.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
 <1476466481-24030-9-git-send-email-p.zabel@pengutronix.de>
 <a5a06050-f6e7-2031-4b14-312f085c5644@embed.me.uk>
 <e4b47417-781d-7553-b14d-e76d18b0c707@denx.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
From: Jack Mitchell <ml@embed.me.uk>
Message-ID: <35d1af0b-c768-48bb-afc1-7da1d365e998@embed.me.uk>
Date: Mon, 17 Oct 2016 12:40:18 +0100
MIME-Version: 1.0
In-Reply-To: <e4b47417-781d-7553-b14d-e76d18b0c707@denx.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 17/10/16 12:35, Marek Vasut wrote:
> On 10/17/2016 01:32 PM, Jack Mitchell wrote:
>> Hi Philipp,
>
> Hi,
>
>> I'm looking at how I would enable a parallel greyscale camera using this
>> set of drivers and am a little bit confused. Do you have an example
>> somewhere of a devicetree with an input node. I also have a further note
>> below:
>
> Which sensor do you use ?
>
> [...]
>

One which has a driver yet to be written :)

Initial prototype board has an onsemi ar0135 on the parallel interface.
