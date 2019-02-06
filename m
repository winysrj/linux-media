Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B31C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 14:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95129217F9
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 14:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cr9dWVGq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbfBFObp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 09:31:45 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36547 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbfBFObp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 09:31:45 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so7810715wrv.3
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 06:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=kArwQFJjNIMBENhOO0kaMZPn1wYRsewcgN4xmbBwaes=;
        b=cr9dWVGqNHy7g4pzXlM8Z3w3Cf4ic2bIs1IOdLR2Nv8InGftM5Ql/faEFabt+xBaaK
         qqFCYvtXoagOAs2I9ax9A6cuKcIUfZtAbasyuSur6h9y8/yzFBB02xlQeMLGwXI+kVgj
         fQM/JciTLdg3Jf66Dz3zVsPZeNZjeUzBQY3xX0lowH6CwGZov3QPN7haT6gGmbFxIagt
         GUNsjcn7kZebJs0sfy8JBZZ508W7h9Fs1VxuePRfdEIkGatPQVH/Q5jcKzIn9HM8dDGV
         /j3TwazW/AAAD4+bGeVd8Y8C6OoVNu77kF2yykhpBF4tDpWQiSKK4mM9zgOCNh3E3QC9
         TxOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=kArwQFJjNIMBENhOO0kaMZPn1wYRsewcgN4xmbBwaes=;
        b=uYzygpJpsh77CwVG0Sznrhm5Tad6AdwfvYHLsDgWWQP9MNmjD3uRzzmEt5Y4qIXTKu
         AXt/XEZbYxS0JWqUQp1sOhiIA29cw9fOA3GwOBxvy0F3GbH4LWXMQlosVoFwfPL4cwbf
         KnXaEMd0ysuXaBswOMhMzF2jcuZLwnKza8MYwm1pLRgmE2+VYsfv3v+dEoEARSfzawMg
         xJeHAaLKgZwOlKKwYeWhTBFC82Ix/EHNhxTq1ZpCgRXslP98v6pTEI4WZtCbYYEb3V6G
         XVGaHbaSMI1gg+j0kVCVzzyxZr43sLCbA24I6Qk4QiMidvfeYa+hQq3K61ret0eW1ccJ
         PsAw==
X-Gm-Message-State: AHQUAuZ2HE4Hx2QVwHNVJS1D2JwRwlbXBf/hxRwPQhKCNRR8K2O2BRmS
        Nd6lzgpyjdxVHgBMJblRfUOKHg==
X-Google-Smtp-Source: AHgI3IYAFeyt60plP8mbNZjLp1oBTrckBNFLF7wx2xuSXSGyLbVLkiAHsnLip19531yBX+7JDIjsqQ==
X-Received: by 2002:a5d:4dd0:: with SMTP id f16mr5842549wru.127.1549463502944;
        Wed, 06 Feb 2019 06:31:42 -0800 (PST)
Received: from arch-late (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id r22sm17902371wmh.2.2019.02.06.06.31.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Feb 2019 06:31:42 -0800 (PST)
References: <20190206102522.29212-1-rui.silva@linaro.org> <20190206102522.29212-11-rui.silva@linaro.org> <20a5f044-9ce6-1ead-9bc4-3e6008706928@xs4all.nl>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v13 10/13] media: imx7.rst: add documentation for i.MX7 media driver
In-reply-to: <20a5f044-9ce6-1ead-9bc4-3e6008706928@xs4all.nl>
Date:   Wed, 06 Feb 2019 14:31:40 +0000
Message-ID: <m3pns57zub.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,
On Wed 06 Feb 2019 at 10:54, Hans Verkuil wrote:
> On 2/6/19 11:25 AM, Rui Miguel Silva wrote:
>> Add rst document to describe the i.MX7 media driver and also a 
>> working
>> example from the Warp7 board usage with a OV2680 sensor.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> Checkpatch gives me:
>
> Applying: media: imx7.rst: add documentation for i.MX7 media 
> driver
> WARNING: added, moved or deleted file(s), does MAINTAINERS need 
> updating?
> #2:
> new file mode 100644
>
> WARNING: Missing or malformed SPDX-License-Identifier tag in 
> line 1
> #7: FILE: Documentation/media/v4l-drivers/imx7.rst:1:
> +i.MX7 Video Capture Driver
>
> total: 0 errors, 2 warnings, 164 lines checked

Yeah, I missed checkpatch in the rst file.

>
> Both warnings are valid, so can you make a v13.1 for this patch 
> only?
> Just include the MAINTAINERS change in this patch.

I will send a complete v14 since I screw up the first patch also.
Thanks any way.

---
Cheers,
	Rui

>
> Regards,
>
> 	Hans
>
>> ---
>>  Documentation/media/v4l-drivers/imx7.rst  | 157 
>>  ++++++++++++++++++++++
>>  Documentation/media/v4l-drivers/index.rst |   1 +
>>  2 files changed, 158 insertions(+)
>>  create mode 100644 Documentation/media/v4l-drivers/imx7.rst
>> 
>> diff --git a/Documentation/media/v4l-drivers/imx7.rst 
>> b/Documentation/media/v4l-drivers/imx7.rst
>> new file mode 100644
>> index 000000000000..cd1195d391c5
>> --- /dev/null
>> +++ b/Documentation/media/v4l-drivers/imx7.rst
>> @@ -0,0 +1,157 @@
>> +i.MX7 Video Capture Driver
>> +==========================
>> +
>> +Introduction
>> +------------
>> +
>> +The i.MX7 contrary to the i.MX5/6 family does not contain an 
>> Image Processing
>> +Unit (IPU); because of that the capabilities to perform 
>> operations or
>> +manipulation of the capture frames are less feature rich.
>> +
>> +For image capture the i.MX7 has three units:
>> +- CMOS Sensor Interface (CSI)
>> +- Video Multiplexer
>> +- MIPI CSI-2 Receiver
>> +
>> +::
>> +                                           |\
>> +   MIPI Camera Input ---> MIPI CSI-2 --- > | \
>> +                                           |  \
>> +                                           | M |
>> +                                           | U | ------>  CSI 
>> ---> Capture
>> +                                           | X |
>> +                                           |  /
>> +   Parallel Camera Input ----------------> | /
>> +                                           |/
>> +
>> +For additional information, please refer to the latest 
>> versions of the i.MX7
>> +reference manual [#f1]_.
>> +
>> +Entities
>> +--------
>> +
>> +imx7-mipi-csi2
>> +--------------
>> +
>> +This is the MIPI CSI-2 receiver entity. It has one sink pad to 
>> receive the pixel
>> +data from MIPI CSI-2 camera sensor. It has one source pad, 
>> corresponding to the
>> +virtual channel 0. This module is compliant to previous 
>> version of Samsung
>> +D-phy, and supports two D-PHY Rx Data lanes.
>> +
>> +csi_mux
>> +-------
>> +
>> +This is the video multiplexer. It has two sink pads to select 
>> from either camera
>> +sensor with a parallel interface or from MIPI CSI-2 virtual 
>> channel 0.  It has
>> +a single source pad that routes to the CSI.
>> +
>> +csi
>> +---
>> +
>> +The CSI enables the chip to connect directly to external CMOS 
>> image sensor. CSI
>> +can interface directly with Parallel and MIPI CSI-2 buses. It 
>> has 256 x 64 FIFO
>> +to store received image pixel data and embedded DMA 
>> controllers to transfer data
>> +from the FIFO through AHB bus.
>> +
>> +This entity has one sink pad that receives from the csi_mux 
>> entity and a single
>> +source pad that routes video frames directly to memory 
>> buffers. This pad is
>> +routed to a capture device node.
>> +
>> +Usage Notes
>> +-----------
>> +
>> +To aid in configuration and for backward compatibility with 
>> V4L2 applications
>> +that access controls only from video device nodes, the capture 
>> device interfaces
>> +inherit controls from the active entities in the current 
>> pipeline, so controls
>> +can be accessed either directly from the subdev or from the 
>> active capture
>> +device interface. For example, the sensor controls are 
>> available either from the
>> +sensor subdevs or from the active capture device.
>> +
>> +Warp7 with OV2680
>> +-----------------
>> +
>> +On this platform an OV2680 MIPI CSI-2 module is connected to 
>> the internal MIPI
>> +CSI-2 receiver. The following example configures a video 
>> capture pipeline with
>> +an output of 800x600, and BGGR 10 bit bayer format:
>> +
>> +.. code-block:: none
>> +   # Setup links
>> +   media-ctl -l "'ov2680 1-0036':0 -> 'imx7-mipi-csis.0':0[1]"
>> +   media-ctl -l "'imx7-mipi-csis.0':1 -> 'csi_mux':1[1]"
>> +   media-ctl -l "'csi_mux':2 -> 'csi':0[1]"
>> +   media-ctl -l "'csi':1 -> 'csi capture':0[1]"
>> +
>> +   # Configure pads for pipeline
>> +   media-ctl -V "'ov2680 1-0036':0 [fmt:SBGGR10_1X10/800x600 
>> field:none]"
>> +   media-ctl -V "'csi_mux':1 [fmt:SBGGR10_1X10/800x600 
>> field:none]"
>> +   media-ctl -V "'csi_mux':2 [fmt:SBGGR10_1X10/800x600 
>> field:none]"
>> +   media-ctl -V "'imx7-mipi-csis.0':0 
>> [fmt:SBGGR10_1X10/800x600 field:none]"
>> +   media-ctl -V "'csi':0 [fmt:SBGGR10_1X10/800x600 
>> field:none]"
>> +
>> +After this streaming can start. The v4l2-ctl tool can be used 
>> to select any of
>> +the resolutions supported by the sensor.
>> +
>> +.. code-block:: none
>> +    root@imx7s-warp:~# media-ctl -p
>> +    Media controller API version 4.17.0
>> +
>> +    Media device information
>> +    ------------------------
>> +    driver          imx-media
>> +    model           imx-media
>> +    serial
>> +    bus info
>> +    hw revision     0x0
>> +    driver version  4.17.0
>> +
>> +    Device topology
>> +    - entity 1: csi (2 pads, 2 links)
>> +		type V4L2 subdev subtype Unknown flags 0
>> +		device node name /dev/v4l-subdev0
>> +	    pad0: Sink
>> +		    [fmt:SBGGR10_1X10/800x600 field:none]
>> +		    <- "csi_mux":2 [ENABLED]
>> +	    pad1: Source
>> +		    [fmt:SBGGR10_1X10/800x600 field:none]
>> +		    -> "csi capture":0 [ENABLED]
>> +
>> +    - entity 4: csi capture (1 pad, 1 link)
>> +		type Node subtype V4L flags 0
>> +		device node name /dev/video0
>> +	    pad0: Sink
>> +		    <- "csi":1 [ENABLED]
>> +
>> +    - entity 10: csi_mux (3 pads, 2 links)
>> +		type V4L2 subdev subtype Unknown flags 0
>> +		device node name /dev/v4l-subdev1
>> +	    pad0: Sink
>> +		    [fmt:unknown/0x0]
>> +	    pad1: Sink
>> +		    [fmt:unknown/800x600 field:none]
>> +		    <- "imx7-mipi-csis.0":1 [ENABLED]
>> +	    pad2: Source
>> +		    [fmt:unknown/800x600 field:none]
>> +		    -> "csi":0 [ENABLED]
>> +
>> +    - entity 14: imx7-mipi-csis.0 (2 pads, 2 links)
>> +		type V4L2 subdev subtype Unknown flags 0
>> +		device node name /dev/v4l-subdev2
>> +	    pad0: Sink
>> +		    [fmt:SBGGR10_1X10/800x600 field:none]
>> +		    <- "ov2680 1-0036":0 [ENABLED]
>> +	    pad1: Source
>> +		    [fmt:SBGGR10_1X10/800x600 field:none]
>> +		    -> "csi_mux":1 [ENABLED]
>> +
>> +    - entity 17: ov2680 1-0036 (1 pad, 1 link)
>> +		type V4L2 subdev subtype Sensor flags 0
>> +		device node name /dev/v4l-subdev3
>> +	    pad0: Source
>> +		    [fmt:SBGGR10_1X10/800x600 field:none]
>> +		    -> "imx7-mipi-csis.0":0 [ENABLED]
>> +
>> +
>> +References
>> +----------
>> +
>> +.. [#f1] 
>> https://www.nxp.com/docs/en/reference-manual/IMX7SRM.pdf
>> diff --git a/Documentation/media/v4l-drivers/index.rst 
>> b/Documentation/media/v4l-drivers/index.rst
>> index f28570ec9e42..dfd4b205937c 100644
>> --- a/Documentation/media/v4l-drivers/index.rst
>> +++ b/Documentation/media/v4l-drivers/index.rst
>> @@ -44,6 +44,7 @@ For more details see the file COPYING in the 
>> source distribution of Linux.
>>  	davinci-vpbe
>>  	fimc
>>  	imx
>> +	imx7
>>  	ipu3
>>  	ivtv
>>  	max2175
>> 

