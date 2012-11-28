Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:45901 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575Ab2K1H1o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 02:27:44 -0500
From: Libin Yang <lbyang@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Albert Wang <twang13@marvell.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 27 Nov 2012 23:24:41 -0800
Subject: RE: [PATCH 02/15] [media] marvell-ccic: add MIPI support for
 marvell-ccic driver
Message-ID: <A63A0DC671D719488CD1A6CD8BDC16CF230A8D7A04@SC-VEXCH4.marvell.com>
References: <1353677587-23998-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271117270.22273@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D1367C8D1@SC-VEXCH1.marvell.com>
 <A63A0DC671D719488CD1A6CD8BDC16CF230A8D79E9@SC-VEXCH4.marvell.com>
 <Pine.LNX.4.64.1211280812060.32652@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1211280812060.32652@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Wednesday, November 28, 2012 3:14 PM
>To: Libin Yang
>Cc: Albert Wang; corbet@lwn.net; linux-media@vger.kernel.org
>Subject: RE: [PATCH 02/15] [media] marvell-ccic: add MIPI support for marvell-ccic driver
>
>On Tue, 27 Nov 2012, Libin Yang wrote:
>
>> Hello Guennadi,
>>
>> Please see my comments below.
>>
>> Best Regards,
>> Libin
>>
>> >-----Original Message-----
>> >From: Albert Wang
>> >Sent: Tuesday, November 27, 2012 7:21 PM
>> >To: Guennadi Liakhovetski
>> >Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>> >Subject: RE: [PATCH 02/15] [media] marvell-ccic: add MIPI support for marvell-ccic
>driver
>> >
>> >Hi, Guennadi
>> >
>> >We will update the patch by following your good suggestion! :)
>> >
>>
>> [snip]
>>
>> >>> +	pll1 = clk_get(dev, "pll1");
>> >>> +	if (IS_ERR(pll1)) {
>> >>> +		dev_err(dev, "Could not get pll1 clock\n");
>> >>> +		return;
>> >>> +	}
>> >>> +
>> >>> +	tx_clk_esc = clk_get_rate(pll1) / 1000000 / 12;
>> >>> +	clk_put(pll1);
>> >>
>> >>Once you release your clock per "clk_put()" its rate can be changed by some other user,
>> >>so, your tx_clk_esc becomes useless. Better keep the reference to the clock until clean
>up.
>> >>Maybe you can also use
>> >>devm_clk_get() to simplify the clean up.
>> >>
>> >That's a good suggestion.
>> >
>> [Libin] In our code design, the pll1 will never be changed after the system boots up.
>Camera and other components can only get the clk without modifying it.
>
>This doesn't matter. We have a standard API and we have to abide to its
>rules. Your driver can be reused or its code can be copied by others. I
>don't think it should be too difficult to just issue devm_clk_get() once
>and then just forget about it.

[Libin] Yes, you are right. We should consider the driver may be reused. I didn't realize it. Another question is: If we use devm_clk_get(), what I understand, the clk will be put when the device is being released. It means the driver will hold the clk all the time the driver is in the kernel. What do you think if we get the clk when opening the camera, and put it in the close?

>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

Best Regard,
Libin
