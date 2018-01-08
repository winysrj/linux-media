Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:8285 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934907AbeAHRNx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 12:13:53 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v5 0/5] Add OV5640 parallel interface and RGB565/YUYV
 support
Date: Mon, 8 Jan 2018 17:13:39 +0000
Message-ID: <3010811e-ed37-4489-6a9f-6cc835f41575@st.com>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
 <20180108153811.5xrvbaekm6nxtoa6@flea>
In-Reply-To: <20180108153811.5xrvbaekm6nxtoa6@flea>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <F28FB6BF15967F4694CBD7C24E092B0F@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

I'm using a ST board with OV5640 wired in parallel bus output in order 
to interface to my STM32 DCMI parallel interface.
Perhaps could you describe your setup so I could help on understanding 
the problem on your side. From my past experience with this sensor 
module, you can first check hsync/vsync polarities, the datasheet is 
buggy on VSYNC polarity as documented in patch 4/5.

Best regards,
Hugues.

On 01/08/2018 04:38 PM, Maxime Ripard wrote:
> Hi Hugues,
> 
> On Wed, Jan 03, 2018 at 10:57:27AM +0100, Hugues Fruchet wrote:
>> Enhance OV5640 CSI driver to support also DVP parallel interface.
>> Add RGB565 (LE & BE) and YUV422 YUYV format in addition to existing
>> YUV422 UYVY format.
>> Some other improvements on chip identifier check and removal
>> of warnings in powering phase around gpio handling.
> 
> I've been trying to use your patches on top of 4.14, but I cannot seem
> to get any signal out of it.
> 
> What is your test setup and which commands are you running?
> 
> Thanks!
> Maxime
> 
