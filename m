Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:53016 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdIPAIL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 20:08:11 -0400
Received: by mail-pf0-f178.google.com with SMTP id p87so2202269pfj.9
        for <linux-media@vger.kernel.org>; Fri, 15 Sep 2017 17:08:11 -0700 (PDT)
Subject: Re: IMX6 ADV7180 no /dev/media
To: Fabio Estevam <festevam@gmail.com>
Cc: Tim Harvey <tharvey@gateworks.com>,
        linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Stephan Bauroth <der_steffi@gmx.de>
References: <CAJ+vNU3DPFEc6YnEfcYAv1=beJ96W5PSt=eBfoxCXqKnbNqfMg@mail.gmail.com>
 <67ab090e-955d-9399-e182-cca049a66f1a@gmail.com>
 <CAJ+vNU3srz1u4x2wku4JKAOWGH8Gc8Wh0eo5aTEhACqoNeE1ow@mail.gmail.com>
 <421dbf8f-6574-7d3b-8842-ffe4c0c6da78@gmail.com>
 <CAOMZO5CJ3=Yd=-=Bvj9pwW62D7eCDAf-uXe6Ri_X_yM+VYfBYw@mail.gmail.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <612b6ad5-cebe-e0e0-8af4-1d53d637fe1e@gmail.com>
Date: Fri, 15 Sep 2017 17:08:08 -0700
MIME-Version: 1.0
In-Reply-To: <CAOMZO5CJ3=Yd=-=Bvj9pwW62D7eCDAf-uXe6Ri_X_yM+VYfBYw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/15/2017 04:46 PM, Fabio Estevam wrote:
> Hi Steve,
>
> On Fri, Sep 15, 2017 at 8:39 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
>> Agreed, but I notice now that CONFIG_MEDIA_CONTROLLER and
>> CONFIG_VIDEO_V4L2_SUBDEV_API are not enabled there anymore.
> I do see them enabled in mainline with imx_v6_v7_defconfig.

Ah, I was looking at mediatree/master, the commit that
enables MEDIA_CONTROLLER hasn't hit mediatree yet.

Steve

>
> Tim,
>
> Care to send the patch enabling CONFIG_VIDEO_MUX?
>
> Thanks
