Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60006 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbZIAL5s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2009 07:57:48 -0400
Date: Tue, 1 Sep 2009 12:57:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "mchehab@infradead.org" <mchehab@infradead.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	'Kevin Hilman' <khilman@deeprootsystems.com>
Subject: Re: [PATCH v4] ARM: DaVinci: DM646x Video: Platform and board
	specific setup
Message-ID: <20090901115727.GE19719@n2100.arm.linux.org.uk>
References: <1249483662-9589-1-git-send-email-chaithrika@ti.com> <008c01ca158e$9ffbf770$dff3e650$@com> <A69FA2915331DC488A831521EAE36FE401548C213E@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401548C213E@dlee06.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 18, 2009 at 04:58:48PM -0500, Karicheri, Muralidharan wrote:
> Could you please ack this patch from Chaithrika if you agree with these
> changes?

I can only see half the patch here - no idea what the calling convention
is for the set_clock method for example.

> I have another set of patches waiting to be submitted and is dependent
> on this patch. So you response will be helpful to speed up the process.

As published a month before, I've been away.

> >> +static struct i2c_client *cpld_client;
> >> +
> >> +static int cpld_video_probe(struct i2c_client *client,
> >> +			const struct i2c_device_id *id)
> >> +{
> >> +	cpld_client = client;
> >> +	return 0;
> >> +}
> >> +
> >> +static int __devexit cpld_video_remove(struct i2c_client *client)
> >> +{
> >> +	cpld_client = NULL;
> >> +	return 0;
> >> +}

What stops cpld_client being set to NULL while set_vpif_clock() is
trying to use this variable?

I think there should be some locking here, and set_vpif_clock() should
be using the i2c_use_client() / i2c_release_client() interfaces to
ensure safety.

> >> +static int set_vpif_clock(int mux_mode, int hd)
> >> +{
> >> +	int val = 0;
> >> +	int err = 0;
> >> +	unsigned int value;
> >> +	void __iomem *base = IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
> >> +
> >> +	if (!cpld_client)
> >> +		return -ENXIO;

So here should be:

	struct i2c_client *cl;

	mutex_lock(&cpld_lock);
	cl = i2c_use_client(cpld_client);
	mutex_unlock(&cpld_lock);
	if (!cl)
		return -ENXIO;

and all future references to cpld_client should be made using the local
'cl'.

> >> +
> >> +	/* disable the clock */
> >> +	value = __raw_readl(base + VSCLKDIS_OFFSET);
> >> +	value |= (VIDCH3CLK | VIDCH2CLK);
> >> +	__raw_writel(value, base + VSCLKDIS_OFFSET);
> >> +
> >> +	val = i2c_smbus_read_byte(cpld_client);
> >> +	if (val < 0)
> >> +		return val;
> >> +
> >> +	if (mux_mode == 1)
> >> +		val &= ~0x40;
> >> +	else
> >> +		val |= 0x40;
> >> +
> >> +	err = i2c_smbus_write_byte(cpld_client, val);
> >> +	if (err)
> >> +		return err;
> >> +
> >> +	value = __raw_readl(base + VIDCLKCTL_OFFSET);
> >> +	value &= ~(VCH2CLK_MASK);
> >> +	value &= ~(VCH3CLK_MASK);
> >> +
> >> +	if (hd >= 1)
> >> +		value |= (VCH2CLK_SYSCLK8 | VCH3CLK_SYSCLK8);
> >> +	else
> >> +		value |= (VCH2CLK_AUXCLK | VCH3CLK_AUXCLK);
> >> +
> >> +	__raw_writel(value, base + VIDCLKCTL_OFFSET);
> >> +
> >> +	/* enable the clock */
> >> +	value = __raw_readl(base + VSCLKDIS_OFFSET);
> >> +	value &= ~(VIDCH3CLK | VIDCH2CLK);
> >> +	__raw_writel(value, base + VSCLKDIS_OFFSET);

and:

	i2c_release_client(cl);

> >> +
> >> +	return 0;
> >> +}
