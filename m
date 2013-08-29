Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:57398 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618Ab3H2LqL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 07:46:11 -0400
Message-ID: <521F307C.9040807@st.com>
Date: Thu, 29 Aug 2013 12:29:00 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Rob Landley <rob@landley.net>,
	Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2] media: st-rc: Add ST remote control driver
References: <1377704030-3763-1-git-send-email-srinivas.kandagatla@st.com> <20130829091155.GA6162@pequod.mess.org>
In-Reply-To: <20130829091155.GA6162@pequod.mess.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/08/13 10:11, Sean Young wrote:
> On Wed, Aug 28, 2013 at 04:33:50PM +0100, Srinivas KANDAGATLA wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>
>> This patch adds support to ST RC driver, which is basically a IR/UHF
>> receiver and transmitter. This IP (IRB) is common across all the ST
>> parts for settop box platforms. IRB is embedded in ST COMMS IP block.
>> It supports both Rx & Tx functionality.
>>
>> In this driver adds only Rx functionality via LIRC codec.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>> ---
>> Hi Chehab,
>>
>> This is a very simple rc driver for IRB controller found in STi ARM CA9 SOCs.
>> STi ARM SOC support went in 3.11 recently.
>> This driver is a raw driver which feeds data to lirc codec for the user lircd
>> to decode the keys.
>>
>> This patch is based on git://linuxtv.org/media_tree.git master branch.
>>
>> Changes since v1:
>> 	- Device tree bindings cleaned up as suggested by Mark and Pawel
>> 	- use ir_raw_event_reset under overflow conditions as suggested by Sean.
>> 	- call ir_raw_event_handle in interrupt handler as suggested by Sean.
>> 	- correct allowed_protos flag with RC_BIT_ types as suggested by Sean.
>> 	- timeout and rx resolution added as suggested by Sean.
> 
> Acked-by: Sean Young <sean@mess.org>

Thankyou Sean for the Ack.
> 
> Note minor nitpicks below.
>>
>> Thanks,
>> srini
>>
>>  Documentation/devicetree/bindings/media/st-rc.txt |   24 ++
>>  drivers/media/rc/Kconfig                          |   10 +
>>  drivers/media/rc/Makefile                         |    1 +
>>  drivers/media/rc/st_rc.c                          |  392 +++++++++++++++++++++
>>  4 files changed, 427 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/media/st-rc.txt
>>  create mode 100644 drivers/media/rc/st_rc.c
>>

>> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
>> index 11e84bc..bf301ed 100644
>> --- a/drivers/media/rc/Kconfig
>> +++ b/drivers/media/rc/Kconfig
>> @@ -322,4 +322,14 @@ config IR_GPIO_CIR
>>  	   To compile this driver as a module, choose M here: the module will
>>  	   be called gpio-ir-recv.
>>  
>> +config RC_ST
>> +	tristate "ST remote control receiver"
>> +	depends on ARCH_STI && LIRC && OF
> 
> Minor nitpick, this should not depend on LIRC, it depends on RC_CORE.
Yes, I will make it depend on RC_CORE, remove OF as suggested by Mauro
CC and select LIRC to something like.

depends on ARCH_STI && RC_CORE
select LIRC

>> +static int st_rc_probe(struct platform_device *pdev)
>> +{
>> +	int ret = -EINVAL;
>> +	struct rc_dev *rdev;
>> +	struct device *dev = &pdev->dev;
>> +	struct resource *res;
>> +	struct st_rc_device *rc_dev;
>> +	struct device_node *np = pdev->dev.of_node;
>> +	const char *rx_mode;
>> +
>> +	rc_dev = devm_kzalloc(dev, sizeof(struct st_rc_device), GFP_KERNEL);
>> +	rdev = rc_allocate_device();
>> +
>> +	if (!rc_dev || !rdev)
>> +		return -ENOMEM;
> 
> If one fails and the other succeeds you have a leak.

Yes... I will fix it in v3.
> 
>> +
>> +	if (np && !of_property_read_string(np, "rx-mode", &rx_mode)) {
>> +

[...]

>> +static SIMPLE_DEV_PM_OPS(st_rc_pm_ops, st_rc_suspend, st_rc_resume);
>> +#endif
>> +
>> +#ifdef CONFIG_OF
> 
> Since this depends on OF it will always be defined.
Removed OF dependency in Kconfig.
>> +module_platform_driver(st_rc_driver);
>> +
>> +MODULE_DESCRIPTION("RC Transceiver driver for STMicroelectronics platforms");
>> +MODULE_AUTHOR("STMicroelectronics (R&D) Ltd");
>> +MODULE_LICENSE("GPL");
>> -- 
>> 1.7.6.5
> 

