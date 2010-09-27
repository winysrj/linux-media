Return-path: <mchehab@pedra>
Received: from isilmar-3.linta.de ([188.40.101.200]:51946 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755201Ab0I0Hp7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 03:45:59 -0400
Date: Mon, 27 Sep 2010 09:45:49 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-i2c@vger.kernel.org, linux-media@vger.kernel.org
Subject: wnv_cs.c: i2c question
Message-ID: <20100927074549.GA32061@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hey,

as I recently obtained such a PCMCIA card, I try to revive the wnv_cs driver
for Winnov Videum Traveler video cards. First (non-working, but compiling
and able to access the EEPROM and to detect the decoder) results may be
found at

http://git.kernel.org/?p=linux/kernel/git/brodo/pcmcia-2.6.git;a=shortlog;h=refs/heads/wnv

Now, I got a bit stuck at the i2c level -- do the following access functions
look familiar to one of the i2c experts? If so, which algo driver is to be
used? Is this an i2c_smbus_, or some very custom interface not worth
converting to use the i2c subsystem? Many thanks!

Best,
	Dominik

PS: The i2c addresses used in this driver are > 0x7f (e.g. 0xa0, 0x8e, 0x48,
	0x4a, 0x34, 0xa8, 0x68)


/*
 *	  2
 *	I   C   B U S   I N T E R F A C E
 *
 */

static __u16
in_ctl(struct videum_device *dev)
{	return wavi_readreg(dev, WAVI_CTL);
}
static void
out_ctl(struct videum_device *dev)
{	wavi_writereg(dev, WAVI_CTL, dev->ctl);
}
static void
i2c_delay(void)
{	udelay(2);
}
static void
i2c_clock(struct videum_device *dev, int c)
{	int	t = 1000;
	if (c) dev->ctl |= WAVI_I2CBIT; else dev->ctl &= ~WAVI_I2CBIT;
	out_ctl(dev);
	if (!c) while (--t && (in_ctl(dev) & WAVI_I2CBIT));
}
static void
i2c_data(struct videum_device *dev, int d)
{	if (d) dev->ctl |= WAVI_IMDBIT; else dev->ctl &= ~WAVI_IMDBIT;
	out_ctl(dev);
}
/* BUG: I2C bit read routines, polarity */

static void
i2c_start(struct videum_device *dev)
{	dev->ctl &= ~(WAVI_I2CBIT | WAVI_IMDBIT);
	out_ctl(dev);		i2c_delay();
	i2c_data(dev, 1);	i2c_delay();
	i2c_clock(dev, 0);	i2c_delay();
}

static int
i2c_get_ack(struct videum_device *dev)
{
	i2c_clock(dev, 1);	i2c_delay();
	i2c_data(dev, 0);	i2c_delay();
	i2c_clock(dev, 0);	i2c_delay();
	i2c_delay();
	return in_ctl(dev) & WAVI_IMDBIT;
}

static void
i2c_send_ack(struct videum_device *dev)
{
	i2c_clock(dev, 1);	i2c_delay();
	i2c_data(dev, 1);	i2c_delay();
	i2c_clock(dev, 0);	i2c_delay();
}

static void
i2c_send_nak(struct videum_device *dev)
{
	i2c_clock(dev, 1);	i2c_delay();
	i2c_data(dev, 0);	i2c_delay();
	i2c_clock(dev, 0);	i2c_delay();
}

static void
i2c_end(struct videum_device *dev)
{
	i2c_clock(dev, 1);	i2c_delay();
	i2c_data(dev, 1);	i2c_delay();
	i2c_clock(dev, 0);	i2c_delay();
	i2c_data(dev, 0);	i2c_delay();
}

static void
i2c_vpxrestart(struct videum_device *dev)
{
	i2c_clock(dev, 1);	i2c_delay();
	i2c_data(dev, 0);	i2c_delay();
	i2c_clock(dev, 0);	i2c_delay();
}

static void
i2c_out8(struct videum_device *dev,
	 int	ndata)
{
	int	i;
	
	ndata = ~ndata;
	for (i = 0; i < 8; ++i)
	{
		i2c_clock(dev, 1);		i2c_delay();
		i2c_data(dev, ndata & 128);	i2c_delay();
		i2c_clock(dev, 0);		i2c_delay();
		ndata <<= 1;
	}
}

static int
i2c_in8(struct videum_device *dev)
{
	int	i;
	int	ndata = ~0;

	dev->ctl &= ~WAVI_IMDBIT;// Don't write to h/w now
	for (i = 0; i < 8; ++i)
	{
		i2c_clock(dev, 1);	i2c_delay();
		i2c_clock(dev, 0);	i2c_delay();
		ndata = (in_ctl(dev) & 1) | (ndata << 1);
	}
	return ~ndata;
}

static void
i2c_get_ready(struct videum_device *dev)
{/*	Prepare I2C bus for operation	*/
	dev->ctl = in_ctl(dev);	/* initialize the CTL register shadow */
	i2c_end(dev);	/* idle the I2C bus */
}

static int
i2c_error(struct videum_device *dev)
{
	i2c_end(dev);
	return -1;
}

// Returns -1 on error.
static int i2c_read_reg_byte(struct videum_device *dev, int addr, int reg)
{	int	ndata;

	i2c_start(dev);
	i2c_out8(dev, addr);
	if (!i2c_get_ack(dev))
		return i2c_error(dev);/* no ACK from device */
	i2c_out8(dev, reg);
	i2c_get_ack(dev); /* assume it succeeds if the first one succeeded */
	if (addr == 0x86 || addr == 0x8E)/* ITT VPX is a little different  */
		i2c_vpxrestart(dev);
	else
		i2c_end(dev);
	i2c_start(dev);
	i2c_out8(dev, addr | 1);
	if (!i2c_get_ack(dev))
		return i2c_error(dev);
	ndata = i2c_in8(dev);
	if (addr == 0x86 || addr == 0x8E)/* ITT VPX is a little different  */
		i2c_send_nak(dev);
	i2c_end(dev);
	return ndata;
}

static int /* -1 on error */
i2c_write_reg_byte(struct videum_device *dev, 
		   int addr, int reg, int ndata)
{
	i2c_start(dev);
	i2c_out8(dev, addr);
	if (!i2c_get_ack(dev))
		return i2c_error(dev);/* no ACK from device */
	i2c_out8(dev, reg);
	i2c_get_ack(dev);
	i2c_out8(dev, ndata);
	i2c_get_ack(dev);
	i2c_end(dev);
	return 0;
}

static int /* -1 on error */
i2c_read_reg_word(struct videum_device *dev, 
		  int addr, int reg)
{
	int	ndata;
	
	i2c_start(dev);
	i2c_out8(dev, addr);
	if (!i2c_get_ack(dev))
		return i2c_error(dev);/* no ACK from device */
	i2c_out8(dev, reg);
	i2c_get_ack(dev); /* assume it succeeds if the first one succeeded */
	if (addr == 0x86 || addr == 0x8E)/* ITT VPX is a little different  */
		i2c_vpxrestart(dev);
	else
		i2c_end(dev);
	i2c_start(dev);
	i2c_out8(dev, addr | 1);
	if (!i2c_get_ack(dev))
		return i2c_error(dev);
	ndata = i2c_in8(dev) << 8;
	i2c_send_ack(dev);
	ndata |= i2c_in8(dev);
	i2c_send_nak(dev);
	i2c_end(dev);
	return ndata;
}

static int /* -1 on error */
i2c_write_reg_word(struct videum_device *dev, 
		   int addr, int reg, int ndata)
{
	i2c_start(dev);
	i2c_out8(dev, addr);
	if (!i2c_get_ack(dev))
		return i2c_error(dev);/* no ACK from device */
	i2c_out8(dev, reg);
	i2c_get_ack(dev);
	i2c_out8(dev, ndata >> 8);
	i2c_get_ack(dev);
	i2c_out8(dev, ndata & 0xFF);
	i2c_get_ack(dev);
	i2c_end(dev);
	return 0;
}

