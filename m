Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.southpole.se ([193.12.106.18]:45547 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1G1Mcu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 08:32:50 -0400
Message-ID: <4E31526F.3060608@southpole.se>
Date: Thu, 28 Jul 2011 14:13:35 +0200
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>, linux-media@vger.kernel.org
Subject: Re: Trying to support for HAUPPAUGE HVR-930C
References: <CAKdnbx5DQe+c1+ZD6tEJqgSfv6CRV18s2YGv=Z3cOT=wEOyF7g@mail.gmail.com>
In-Reply-To: <CAKdnbx5DQe+c1+ZD6tEJqgSfv6CRV18s2YGv=Z3cOT=wEOyF7g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 07/28/2011 10:53 AM, Eddi De Pieri wrote:
> Hi,
> 
> I'd like to share my work to get hvr 930c.
> 
> 
> Actually the device don't work yet.
> 
> Please someone can review my work?
> 

[ ...]

> +	struct {
> +		unsigned char r[4];
> +		int len;
> +	} regs[] = {
> +		{{ 0x06, 0x02, 0x00, 0x31 }, 4},
> +		{{ 0x01, 0x02 }, 2},
> +		{{ 0x01, 0x02, 0x00, 0xc6 }, 4},
> +		{{ 0x01, 0x00 }, 2},
> +		{{ 0x01, 0x00, 0xff, 0xaf }, 4},
> +		{{ 0x01, 0x00, 0x03, 0xa0 }, 4},
> +		{{ 0x01, 0x00 }, 2},
> +		{{ 0x01, 0x00, 0x73, 0xaf }, 4},
> +		{{ 0x04, 0x00 }, 2},
> +		{{ 0x00, 0x04 }, 2},
> +		{{ 0x00, 0x04, 0x00, 0x0a }, 4},
> +		{{ 0x04, 0x14 }, 2},
> +		{{ 0x04, 0x14, 0x00, 0x00 }, 4},
> +	};
> +
> +	em28xx_gpio_set(dev, hauppauge_hvr930c_init);
> +	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
> +	msleep(10);
> +	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
> +	msleep(10);
> +
> +	dev->i2c_client.addr = 0x82 >> 1;
> +	for (i = 0; i < ARRAY_SIZE(regs); i++)
> +		i2c_master_send(&dev->i2c_client, regs[i].r, regs[i].len);
> +	em28xx_gpio_set(dev, hauppauge_hvr930c_end);

0x82 is the address of the chip handling the analog signals(?) Micronas
AVF 4910BA1 maybe. So change the names so it is clear that this part
sends commands to that chip.

I'm not sure I understand the I2C addressing but my tuner is at 0xc2 and
the demod at 0x52.

MvH
Benjamin Larsson

