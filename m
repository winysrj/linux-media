Return-path: <mchehab@gaivota>
Received: from newsmtp5.atmel.com ([204.2.163.5]:13685 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab1EME5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 00:57:53 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)support
Date: Fri, 13 May 2011 12:57:20 +0800
Message-ID: <4C79549CB6F772498162A641D92D532801B188BF@penmb01.corp.atmel.com>
In-Reply-To: <20110512093433.GD1356@n2100.arm.linux.org.uk>
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com> <20110512093433.GD1356@n2100.arm.linux.org.uk>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: <mchehab@redhat.com>, <linux-media@vger.kernel.org>,
	"Haring, Lars" <Lars.Haring@atmel.com>,
	<linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <g.liakhovetski@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thursday, May 12, 2011 5:35 PM, Russell King wrote:

> A few more points...

>> +static int __init atmel_isi_probe(struct platform_device *pdev)

> Should be __devinit otherwise you'll have section errors.
Ok, will be fixed in V2 patch.
>> +{
>> +	unsigned int irq;
>> +	struct atmel_isi *isi;
>> +	struct clk *pclk;
>> +	struct resource *regs;
>> +	int ret;
>> +	struct device *dev = &pdev->dev;
>> +	struct isi_platform_data *pdata;
>> +	struct soc_camera_host *soc_host;
>> +
>> +	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!regs)
>> +		return -ENXIO;
>> +
>> +	pclk = clk_get(&pdev->dev, "isi_clk");
>> +	if (IS_ERR(pclk))
>> +		return PTR_ERR(pclk);
>> +
>> +	clk_enable(pclk);

> Return value of clk_enable() should be checked.
Yes. I will add code to check the return value in V2 patch. 
>> +
>> +	isi = kzalloc(sizeof(struct atmel_isi), GFP_KERNEL);
>> +	if (!isi) {
>> +		ret = -ENOMEM;
>> [...]
>> +	isi_writel(isi, V2_CTRL, ISI_BIT(V2_DIS));
>> +	/* Check if module disable */
>> +	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_DIS))
>> +		cpu_relax();
>> +
>> +	irq = platform_get_irq(pdev, 0);

> This should also be checked.
Ditto, thank you.
