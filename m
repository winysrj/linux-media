Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:45283 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754148AbeEHXYL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 19:24:11 -0400
Received: by mail-pg0-f67.google.com with SMTP id w3-v6so1287995pgv.12
        for <linux-media@vger.kernel.org>; Tue, 08 May 2018 16:24:10 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] media: imx: add capture support for RGB565_2X8 on
 parallel bus
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Jan Luebbe <jlu@pengutronix.de>, linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
References: <20180508141411.26620-1-jlu@pengutronix.de>
 <1525789504.18091.9.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <cd25aeec-571a-a8c7-e228-1253f9ebdd31@gmail.com>
Date: Tue, 8 May 2018 16:24:05 -0700
MIME-Version: 1.0
In-Reply-To: <1525789504.18091.9.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp, Jan,


On 05/08/2018 07:25 AM, Philipp Zabel wrote:
> On Tue, 2018-05-08 at 16:14 +0200, Jan Luebbe wrote:
>> The IPU can only capture RGB565 with two 8-bit cycles in bayer/generic
>> mode on the parallel bus, compared to a specific mode on MIPI CSI-2.
>> To handle this, we extend imx_media_pixfmt with a cycles per pixel
>> field, which is used for generic formats on the parallel bus.
>>
>> Before actually adding RGB565_2X8 support for the parallel bus, this
>> series simplifies handing of the the different configurations for RGB565
>> between parallel and MIPI CSI-2 in imx-media-capture. This avoids having
>> to explicitly pass on the format in the second patch.
>>
>> Changes since v1:
>>    - fixed problems reported the kbuild test robot
>>    - added helper functions as suggested by Steve Longerbeam
>>      (is_parallel_bus and requires_passthrough)
>>    - removed passthough format check in csi_link_validate() (suggested by
>>      Philipp Zabel during internal review)
> The theory is that IC only supports AYUV8_1X32 and RGB888_1X24 input,
> and any passthrough format on the CSI sink will differ from those.
> Mismatching formats are already caught by v4l2_subdev_link_validate
> called on the ipu?_vdic or ipu?_ic_prp entities' sink pads.

Right, the CSI will pass parallel-bus RGB565_2X8 through to the source
pad. If the CSI is then linked to ->IC_PRP or ->VDIC, 
v4l2_subdev_link_validate
will catch the mbus format mismatch. So the check in csi_link_validate
is not really necessary, thanks for catching.

Steve
