Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:62693 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1LGKNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 05:13:20 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] [media] V4L: atmel-isi: add code to enable/disableISI_MCK clock
Date: Wed, 7 Dec 2011 18:12:52 +0800
Message-ID: <4C79549CB6F772498162A641D92D5328039E9C15@penmb01.corp.atmel.com>
In-Reply-To: <20111207084958.GA14542@n2100.arm.linux.org.uk>
References: <1322647604-30662-1-git-send-email-josh.wu@atmel.com> <20111207084958.GA14542@n2100.arm.linux.org.uk>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: <g.liakhovetski@gmx.de>, <linux-media@vger.kernel.org>,
	"Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
	<linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Russell King

On Wed, Dec 07, 2011 at 4:50 PM, Russell King wrote:

> On Wed, Nov 30, 2011 at 06:06:43PM +0800, Josh Wu wrote:
>> +	/* Get ISI_MCK, provided by programmable clock or external clock
*/
>> +	isi->mck = clk_get(dev, "isi_mck");
>> +	if (IS_ERR_OR_NULL(isi->mck)) {

> This should be IS_ERR()

So it means the clk_get() will never return NULL even when clk structure
is NULL in clk lookup entry. Right?

>> +		dev_err(dev, "Failed to get isi_mck\n");
>> +		ret = isi->mck ? PTR_ERR(isi->mck) : -EINVAL;

>		ret = PTR_ERR(isi->mck);

Best Regards,
Josh Wu
