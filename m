Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:58462 "EHLO
	nasmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbcDSKDA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2016 06:03:00 -0400
Subject: Re: [PATCH 1/2] [media] atmel-isc: add the Image Sensor Controller
 code
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1460533460-32336-1-git-send-email-songjun.wu@atmel.com>
 <1460533460-32336-2-git-send-email-songjun.wu@atmel.com>
 <81160604.beJHM8QlLS@avalon>
CC: <g.liakhovetski@gmx.de>, <nicolas.ferre@atmel.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	"Benoit Parrot" <bparrot@ti.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	=?UTF-8?Q?Richard_R=c3=b6jfors?= <richard@puffinpack.se>,
	<linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
From: "Wu, Songjun" <songjun.wu@atmel.com>
Message-ID: <57160246.2060804@atmel.com>
Date: Tue, 19 Apr 2016 18:02:46 +0800
MIME-Version: 1.0
In-Reply-To: <81160604.beJHM8QlLS@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 4/15/2016 00:21, Laurent Pinchart wrote:
>> >+		return -EINVAL;
>> >+
>> >+	parent_names = kcalloc(num_parents, sizeof(char *), GFP_KERNEL);
>> >+	if (!parent_names)
>> >+		return -ENOMEM;
>> >+
>> >+	of_clk_parent_fill(np, parent_names, num_parents);
>> >+
>> >+	init.parent_names	= parent_names;
>> >+	init.num_parents	= num_parents;
>> >+	init.name		= clk_name;
>> >+	init.ops		= &isc_clk_ops;
>> >+	init.flags		= CLK_SET_RATE_GATE | CLK_SET_PARENT_GATE;
>> >+
>> >+	isc_clk = &isc->isc_clks[id];
>> >+	isc_clk->hw.init	= &init;
>> >+	isc_clk->regmap		= regmap;
>> >+	isc_clk->lock		= lock;
>> >+	isc_clk->id		= id;
>> >+
>> >+	isc_clk->clk = clk_register(NULL, &isc_clk->hw);
>> >+	if (!IS_ERR(isc_clk->clk))
>> >+		of_clk_add_provider(np, of_clk_src_simple_get, isc_clk->clk);
>> >+	else {
>> >+		dev_err(isc->dev, "%s: clock register fail\n", clk_name);
>> >+		ret = PTR_ERR(isc_clk->clk);
>> >+		goto free_parent_names;
>> >+	}
>> >+
>> >+free_parent_names:
>> >+	kfree(parent_names);
>> >+	return ret;
>> >+}
>> >+
>> >+static int isc_clk_init(struct isc_device *isc)
>> >+{
>> >+	struct device_node *np = of_get_child_by_name(isc->dev->of_node,
>> >+						      "clk_in_isc");
> Do you really need the clk_in_isc DT node ? I would have assumed that the
> clock topology inside the ISC is fixed, and that it would be enough to just
> specify the three parent clocks in the ISC DT node and create the two internal
> clocks in the driver without needing a DT description.
>
Hi Laurent,

I think more, and the clk_in_isc DT node should be needed. The clock 
topology inside the ISC is fixed, but isc will provide the clock to 
sensor, we need create the corresponding clock node int DT file, then 
the sensor will get this clock and set the clock rate in DT file.

