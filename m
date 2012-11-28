Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:56583 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734Ab2K1HIF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 02:08:05 -0500
From: Libin Yang <lbyang@marvell.com>
To: Albert Wang <twang13@marvell.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 27 Nov 2012 23:07:28 -0800
Subject: RE: [PATCH 02/15] [media] marvell-ccic: add MIPI support for
 marvell-ccic driver
Message-ID: <A63A0DC671D719488CD1A6CD8BDC16CF230A8D79E9@SC-VEXCH4.marvell.com>
References: <1353677587-23998-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271117270.22273@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D1367C8D1@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D1367C8D1@SC-VEXCH1.marvell.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Guennadi,

Please see my comments below.

Best Regards,
Libin 

>-----Original Message-----
>From: Albert Wang
>Sent: Tuesday, November 27, 2012 7:21 PM
>To: Guennadi Liakhovetski
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: RE: [PATCH 02/15] [media] marvell-ccic: add MIPI support for marvell-ccic driver
>
>Hi, Guennadi
>
>We will update the patch by following your good suggestion! :)
>

[snip]

>>> +	pll1 = clk_get(dev, "pll1");
>>> +	if (IS_ERR(pll1)) {
>>> +		dev_err(dev, "Could not get pll1 clock\n");
>>> +		return;
>>> +	}
>>> +
>>> +	tx_clk_esc = clk_get_rate(pll1) / 1000000 / 12;
>>> +	clk_put(pll1);
>>
>>Once you release your clock per "clk_put()" its rate can be changed by some other user,
>>so, your tx_clk_esc becomes useless. Better keep the reference to the clock until clean up.
>>Maybe you can also use
>>devm_clk_get() to simplify the clean up.
>>
>That's a good suggestion.
>
[Libin] In our code design, the pll1 will never be changed after the system boots up. Camera and other components can only get the clk without modifying it.



