Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:52118 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754327Ab3HPLIf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Aug 2013 07:08:35 -0400
Message-ID: <520E04BC.10908@st.com>
Date: Fri, 16 Aug 2013 11:53:48 +0100
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
Subject: Re: [PATCH] media: st-rc: Add ST remote control driver
References: <1376501221-22416-1-git-send-email-srinivas.kandagatla@st.com> <20130816083853.GA6844@pequod.mess.org>
In-Reply-To: <20130816083853.GA6844@pequod.mess.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Sean for the comments.
On 16/08/13 09:38, Sean Young wrote:
> On Wed, Aug 14, 2013 at 06:27:01PM +0100, Srinivas KANDAGATLA wrote:
[...]
>>
>>  Documentation/devicetree/bindings/media/st-rc.txt |   18 +
>>  drivers/media/rc/Kconfig                          |   10 +
>>  drivers/media/rc/Makefile                         |    1 +
>>  drivers/media/rc/st_rc.c                          |  371 +++++++++++++++++++++
>>  4 files changed, 400 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/media/st-rc.txt
>>  create mode 100644 drivers/media/rc/st_rc.c
>>
>> diff --git a/Documentation/devicetree/bindings/media/st-rc.txt b/Documentation/devicetree/bindings/media/st-rc.txt
>> new file mode 100644
>> index 0000000..57f9ee8
>> --- /dev/null
>> diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
[...]
>> +static irqreturn_t st_rc_rx_interrupt(int irq, void *data)
>> +{
>> +	unsigned int symbol, mark = 0;
>> +	struct st_rc_device *dev = data;
>> +	int last_symbol = 0;
>> +	u32 status;
>> +	DEFINE_IR_RAW_EVENT(ev);
>> +
>> +	if (dev->irq_wake)
>> +		pm_wakeup_event(dev->dev, 0);
>> +
>> +	status  = readl(dev->rx_base + IRB_RX_STATUS);
>> +
>> +	while (status & (IRB_FIFO_NOT_EMPTY | IRB_OVERFLOW)) {
>> +		u32 int_status = readl(dev->rx_base + IRB_RX_INT_STATUS);
>> +		if (unlikely(int_status & IRB_RX_OVERRUN_INT)) {
> 
> You should call ir_raw_event_reset() so that the in-kernel decoders 
> realise that the IR stream is not contiguous.
Yep... It makes sense..  I will add this.
> 
>> +			/* discard the entire collection in case of errors!  */
>> +			dev_info(dev->dev, "IR RX overrun\n");
>> +			writel(IRB_RX_OVERRUN_INT,
>> +					dev->rx_base + IRB_RX_INT_CLEAR);
>> +			continue;
>> +		}
>> +
>> +		symbol = readl(dev->rx_base + IRB_RX_SYS);
>> +		mark = readl(dev->rx_base + IRB_RX_ON);
>> +
>> +		if (symbol == IRB_TIMEOUT)
>> +			last_symbol = 1;
>> +
>> +		 /* Ignore any noise */
>> +		if ((mark > 2) && (symbol > 1)) {
>> +			symbol -= mark;
>> +			if (dev->overclocking) { /* adjustments to timings */
>> +				symbol *= dev->sample_mult;
>> +				symbol /= dev->sample_div;
>> +				mark *= dev->sample_mult;
>> +				mark /= dev->sample_div;
>> +			}
>> +
>> +			ev.duration = US_TO_NS(mark);
>> +			ev.pulse = true;
>> +			ir_raw_event_store(dev->rdev, &ev);
>> +
>> +			if (!last_symbol) {
>> +				ev.duration = US_TO_NS(symbol);
>> +				ev.pulse = false;
>> +				ir_raw_event_store(dev->rdev, &ev);
> 
> Make sure you call ir_raw_event_handle() once a while (maybe every time
> the interrupt handler is called?) to prevent the ir kfifo from 
> overflowing in case of very long IR. ir_raw_event_store() just adds
> new edges to the kfifo() but does not flush them to the decoders or
> lirc.
I agree, but Am not sure it will really help in this case because, we
are going to stay in this interrupt handler till we get a
last_symbol(full key press/release event).. So calling
ir_raw_event_store mulitple times might not help because the
ir_raw_event kthread(which is clearing kfifo) which is only scheduled
after returning from this interrupt.

Correct me if Am wrong.

> 
>> +			} else  {
>> +				st_rc_send_lirc_timeout(dev->rdev);
>> +				ir_raw_event_handle(dev->rdev);
>> +			}
>> +		}
>> +		last_symbol = 0;
>> +		status  = readl(dev->rx_base + IRB_RX_STATUS);
>> +	}
>> +
>> +	writel(IRB_RX_INTS, dev->rx_base + IRB_RX_INT_CLEAR);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
[...]
>> +static int st_rc_probe(struct platform_device *pdev)
>> +{
>> +	int ret = -EINVAL;
>> +	struct rc_dev *rdev;
>> +	struct device *dev = &pdev->dev;
>> +	struct resource *res;
>> +	struct st_rc_device *rc_dev;
>> +	struct device_node *np = pdev->dev.of_node;
>> +
>> +	rc_dev = devm_kzalloc(dev, sizeof(struct st_rc_device), GFP_KERNEL);
>> +	rdev = rc_allocate_device();
>> +
>> +	if (!rc_dev || !rdev)
>> +		return -ENOMEM;
>> +
>> +	if (np)
>> +		rc_dev->rxuhfmode = of_property_read_bool(np, "st,uhfmode");
>> +
>> +	rc_dev->sys_clock = devm_clk_get(dev, NULL);
>> +	if (IS_ERR(rc_dev->sys_clock)) {
>> +		dev_err(dev, "System clock not found\n");
>> +		ret = PTR_ERR(rc_dev->sys_clock);
>> +		goto err;
>> +	}
>> +
>> +	rc_dev->irq = platform_get_irq(pdev, 0);
>> +	if (rc_dev->irq < 0) {
>> +		ret = rc_dev->irq;
>> +		goto clkerr;
>> +	}
>> +
>> +	ret = -ENODEV;
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res)
>> +		goto clkerr;
>> +
>> +	rc_dev->base = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(rc_dev->base))
>> +		goto clkerr;
>> +
>> +	if (rc_dev->rxuhfmode)
>> +		rc_dev->rx_base = rc_dev->base + 0x40;
>> +	else
>> +		rc_dev->rx_base = rc_dev->base;
>> +
>> +	rc_dev->dev = dev;
>> +	platform_set_drvdata(pdev, rc_dev);
>> +	st_rc_hardware_init(rc_dev);
>> +
>> +	rdev->driver_type = RC_DRIVER_IR_RAW;
>> +	rdev->allowed_protos = RC_TYPE_LIRC;
> 
> allowed_protos is a bit field, so you need one of the RC_BIT_ types;
> you should use RC_BIT_ALL so that in-kernel IR decoders can be used
> for decoding if desired.

Ok, I miss interpreted the TYPE .. I will fix this in v2.
> 
>> +	rdev->priv = rc_dev;
>> +	rdev->open = st_rc_open;
>> +	rdev->close = st_rc_close;
>> +	rdev->driver_name = IR_ST_NAME;
>> +	rdev->map_name = RC_MAP_LIRC;
>> +	rdev->input_name = "ST Remote Control Receiver";
> 
> Please also set the timeout and rx_resolution according to the hardware.
Ok, I will add this info as well.

Thanks,
srini
> 

