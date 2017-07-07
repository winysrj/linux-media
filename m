Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:33279 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751850AbdGGOXa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 10:23:30 -0400
MIME-Version: 1.0
In-Reply-To: <1499434760.9610.7.camel@pengutronix.de>
References: <CAD6G_RQ-7uwTVLr27UTSvA50rLq-yRRTYKMmYQf7K1O8wf6HOA@mail.gmail.com>
 <1499434760.9610.7.camel@pengutronix.de>
From: Jagan Teki <jagannadh.teki@gmail.com>
Date: Fri, 7 Jul 2017 19:53:27 +0530
Message-ID: <CAD6G_RSZhQm8-PZOAMVykiN9s-U3apA_F6tozAGLyvaYpDRVqg@mail.gmail.com>
Subject: Re: coda 2040000.vpu: firmware request failed
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 7, 2017 at 7:09 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Jagan,
>
> On Fri, 2017-07-07 at 18:15 +0530, Jagan Teki wrote:
>> Hi,
>>
>> I'm observing firmware request failure with i.MX6Q board, This is with
>> latest linux-next (4.12) with firmware from, [1] and converted
>> v4l-coda960-imx6q.bin using [2].
>>
>> Log:
>> ------
>> coda 2040000.vpu: Direct firmware load for vpu_fw_imx6q.bin failed with error -2
>> coda 2040000.vpu: Direct firmware load for vpu/vpu_fw_imx6q.bin failed
>> with error -2
>> coda 2040000.vpu: Direct firmware load for v4l-coda960-imx6q.bin
>> failed with error -2
>
> The error code is -ENOENT, so the firmware binary is not found where the
> firmware loader code is looking. That could be caused by the coda driver
> being probed before the file system containing the firmware binary is
> mounted. Have you tried compiling the coda driver as a module
> (CONFIG_VIDEO_CODA=m)?

Yes, true unless it is module firmware files can't get by coda

# modprobe -a coda
[   24.474662] coda 2040000.vpu: Firmware code revision: 36350
[   24.480556] coda 2040000.vpu: Initialized CODA960.
[   24.485415] coda 2040000.vpu: Unsupported firmware version: 2.1.9
[   24.493494] coda 2040000.vpu: codec registered as /dev/video[0-1]

thanks!
-- 
Jagan Teki
Free Software Engineer | www.openedev.com
U-Boot, Linux | Upstream Maintainer
Hyderabad, India.
