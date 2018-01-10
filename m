Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:20858 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933428AbeAJPv2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 10:51:28 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Yong Deng <yong.deng@magewell.com>
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
Date: Wed, 10 Jan 2018 15:51:07 +0000
Message-ID: <2089de18-1f7f-6d6e-7aee-9dc424bca335@st.com>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
 <20180108153811.5xrvbaekm6nxtoa6@flea>
 <3010811e-ed37-4489-6a9f-6cc835f41575@st.com>
 <20180110153724.l77zpdgxfbzkznuf@flea>
In-Reply-To: <20180110153724.l77zpdgxfbzkznuf@flea>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <52CC4E299894CD4FB392125D785121AE@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Good news Maxime !

Have you seen that you can adapt the polarities through devicetree ?

+                       /* Parallel bus endpoint */
+                       ov5640_to_parallel: endpoint {
[...]
+                               hsync-active = <0>;
+                               vsync-active = <0>;
+                               pclk-sample = <1>;
+                       };

Doing so you can adapt to your SoC/board setup easily.

If you don't put those lines in devicetree, the ov5640 default init 
sequence is used which set the polarity as defined in below comment:
ov5640_set_stream_dvp()
[...]
+        * Control lines polarity can be configured through
+        * devicetree endpoint control lines properties.
+        * If no endpoint control lines properties are set,
+        * polarity will be as below:
+        * - VSYNC:     active high
+        * - HREF:      active low
+        * - PCLK:      active low
+        */
[...]


Best regards,
Hugues.

On 01/10/2018 04:37 PM, Maxime Ripard wrote:
> Hi Hugues,
> 
> On Mon, Jan 08, 2018 at 05:13:39PM +0000, Hugues FRUCHET wrote:
>> I'm using a ST board with OV5640 wired in parallel bus output in order
>> to interface to my STM32 DCMI parallel interface.
>> Perhaps could you describe your setup so I could help on understanding
>> the problem on your side. From my past experience with this sensor
>> module, you can first check hsync/vsync polarities, the datasheet is
>> buggy on VSYNC polarity as documented in patch 4/5.
> 
> It turns out that it was indeed a polarity issue.
> 
> It looks like that in order to operate properly, I need to setup the
> opposite polarity on HSYNC and VSYNC on the interface. I looked at the
> signals under a scope, and VSYNC is obviously inversed as you
> described. HSYNC, I'm not so sure since the HBLANK period seems very
> long, almost a line.
> 
> Since VSYNC at least looks correct, I'd be inclined to think that the
> polarity is inversed on at least the SoC I'm using it on.
> 
> Yong, did you test the V3S CSI driver with a parallel interface? With
> what sensor driver? Have you found some polarities issues like this?
> 
> Thanks!
> Maxime
> 
