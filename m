Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46765 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbeKGTeQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 14:34:16 -0500
Received: by mail-wr1-f68.google.com with SMTP id 74-v6so16689451wrb.13
        for <linux-media@vger.kernel.org>; Wed, 07 Nov 2018 02:04:37 -0800 (PST)
References: <20180810142045.27657-1-rui.silva@linaro.org> <f20a9702-632e-8248-2538-af14d4a84cdc@xs4all.nl>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v7 00/12] media: staging/imx7: add i.MX7 media driver
In-reply-to: <f20a9702-632e-8248-2538-af14d4a84cdc@xs4all.nl>
Date: Wed, 07 Nov 2018 10:04:33 +0000
Message-ID: <m3lg65td8u.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
On Wed 07 Nov 2018 at 09:58, Hans Verkuil wrote:
> Hi Rui,
>
> On 08/10/18 16:20, Rui Miguel Silva wrote:
>> Hi,
>> This series introduces the Media driver to work with the i.MX7 
>> SoC. it uses the
>> already existing imx media core drivers but since the i.MX7, 
>> contrary to
>> i.MX5/6, do not have an IPU and because of that some changes in 
>> the imx media
>> core are made along this series to make it support that case.
>> 
>> This patches adds CSI and MIPI-CSI2 drivers for i.MX7, along 
>> with several
>> configurations changes for this to work as a capture subsystem. 
>> Some bugs are
>> also fixed along the line. And necessary documentation.
>> 
>> For a more detailed view of the capture paths, pads links in 
>> the i.MX7 please
>> take a look at the documentation in PATCH 14.
>> 
>> The system used to test and develop this was the Warp7 board 
>> with an OV2680
>> sensor, which output format is 10-bit bayer. So, only MIPI 
>> interface was
>> tested, a scenario with an parallel input would nice to have.
>> 
>> 
>> Bellow goes an example of the output of the pads and links and 
>> the output of
>> v4l2-compliance testing.
>> 
>> The v4l-utils version used is:
>> v4l2-compliance SHA   : 
>> 90905c2e4b17d7595256f3824e2d30d19b0df1a1 from Aug 6th
>> 
>> The Media Driver fail some tests but this failures are coming 
>> from code out of
>> scope of this series (imx-capture), and some from the sensor 
>> OV2680
>> but that I think not related with the sensor driver but with 
>> the testing and
>> core.
>> 
>> The csi and mipi-csi entities pass all compliance tests.
>
> Can you rebase and repost? Please re-run v4l2-compliance as well 
> with the latest
> compliance code.

Yup, I may take one week or so, other things in hand, but will try 
to
send it sooner than later.

>
> We should be able to merge this for 4.21 (finally!).

Yeah!! Thanks.

---
Cheers,
	Rui
