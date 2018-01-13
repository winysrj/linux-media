Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:42480 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754864AbeAMQK6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Jan 2018 11:10:58 -0500
MIME-Version: 1.0
In-Reply-To: <438bc4cb-6486-8013-80aa-9e2253941fb8@samsung.com>
References: <1515344064-23156-1-git-send-email-akinobu.mita@gmail.com>
 <1515344064-23156-3-git-send-email-akinobu.mita@gmail.com>
 <CGME20180112141549epcas2p18e8981052885dbaaf8a0be2ac8410082@epcas2p1.samsung.com>
 <20180108093513.nvr2e7vbt7imai2p@paasikivi.fi.intel.com> <438bc4cb-6486-8013-80aa-9e2253941fb8@samsung.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sun, 14 Jan 2018 01:10:37 +0900
Message-ID: <CAC5umyjhoZkvca+fgm-YfA666MDWh4gSDqdu5oxqYQmt6pHTyA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] media: ov9650: add device tree binding
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        devicetree <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo@jmondi.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-01-12 23:15 GMT+09:00 Sylwester Nawrocki <s.nawrocki@samsung.com>:
> On 01/08/2018 10:35 AM, Sakari Ailus wrote:
>
>> I was going to say you're missing the MAINTAINERS entry for this newly
>> added file but then I noticed that the entire driver is missing an entry.
>> Still this file should have a MAINTAINERS entry added for it independently
>> of that, in the same patch.
>>
>> Cc Sylwester.
>
> I don't the hardware and I can't test the patches so Mita-san if you wish
> so please add yourself as a maintainer of whole driver.

Even if you don't have the hardware, you can help reviwing.  So if you
don't mind, I would like to add the following maintainer entry for this
driver.

OMNIVISION OV9650 SENSOR DRIVER
M:      Sakari Ailus <sakari.ailus@iki.fi>
R:      Akinobu Mita <akinobu.mita@gmail.com>
R:      Sylwester Nawrocki <s.nawrocki@samsung.com>
L:      linux-media@vger.kernel.org
T:      git git://linuxtv.org/media_tree.git
S:      Maintained
F:      drivers/media/i2c/ov9650.c
F:      Documentation/devicetree/bindings/media/i2c/ov9650.txt
