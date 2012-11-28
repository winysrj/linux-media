Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:50149 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751368Ab2K1H5a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 02:57:30 -0500
From: Libin Yang <lbyang@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Albert Wang <twang13@marvell.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 27 Nov 2012 23:56:16 -0800
Subject: RE: [PATCH 02/15] [media] marvell-ccic: add MIPI support for
 marvell-ccic driver
Message-ID: <A63A0DC671D719488CD1A6CD8BDC16CF230A8D7A32@SC-VEXCH4.marvell.com>
References: <1353677587-23998-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271117270.22273@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D1367C8D1@SC-VEXCH1.marvell.com>
 <A63A0DC671D719488CD1A6CD8BDC16CF230A8D79E9@SC-VEXCH4.marvell.com>
 <Pine.LNX.4.64.1211280812060.32652@axis700.grange>
 <A63A0DC671D719488CD1A6CD8BDC16CF230A8D7A04@SC-VEXCH4.marvell.com>
 <Pine.LNX.4.64.1211280841390.32652@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1211280841390.32652@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

[snip]

>> [Libin] Yes, you are right. We should consider the driver may be reused.
>> I didn't realize it. Another question is: If we use devm_clk_get(), what
>> I understand, the clk will be put when the device is being released. It
>> means the driver will hold the clk all the time the driver is in the
>> kernel. What do you think if we get the clk when opening the camera, and
>> put it in the close?
>
>Sure, that's fine too.

OK, I see. Thanks.

Regards,
Libin 

