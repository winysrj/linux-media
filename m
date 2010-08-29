Return-path: <mchehab@pedra>
Received: from smtp6-g21.free.fr ([212.27.42.6]:35508 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab0H2Q5v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Aug 2010 12:57:51 -0400
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	Philipp Wiesner <p.wiesner@phytec.de>
Subject: Re: [PATCH v2 11/11] mt9m111: make use of testpattern
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
	<1280833069-26993-12-git-send-email-m.grzeschik@pengutronix.de>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 29 Aug 2010 18:57:40 +0200
In-Reply-To: <1280833069-26993-12-git-send-email-m.grzeschik@pengutronix.de> (Michael Grzeschik's message of "Tue\,  3 Aug 2010 12\:57\:49 +0200")
Message-ID: <8762ytmk57.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Michael Grzeschik <m.grzeschik@pengutronix.de> writes:

> Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

I would require a small change here.

I am using the testpattern for non regression tests. This change implies that
the test pattern can only be set up by module parameters, and blocks the usage
through V4L2 debug, registers, see below:
        memset(&set_reg, 0, sizeof(set_reg));
        set_reg.match.type = V4L2_CHIP_MATCH_I2C_ADDR;
        set_reg.match.addr = 0x5d;
        set_reg.reg = 0x148;
        set_reg.val = test_pattern;
        set_reg.size = 1;
        if (test_pattern != -1)
                if (-1 == xioctl (fd, VIDIOC_DBG_S_REGISTER, &set_reg)) {
                        fprintf (stderr, "%s could set test pattern %x\n",
                                 dev_name, test_pattern);
                        exit (EXIT_FAILURE);
                }

But, the idea is not bad. Therefore, I'd like you to change:
> +	dev_dbg(&client->dev, "%s: using testpattern %d\n", __func__,
> +			testpattern);
> +
> +	if (!ret)
> +		ret = mt9m111_reg_set(client,
> +				MT9M111_TEST_PATTERN_GEN, pattern);
into
> +	dev_dbg(&client->dev, "%s: using testpattern %d\n", __func__,
> +			testpattern);
> +
> +	if (!ret && pattern)
> +		ret = mt9m111_reg_set(client,
> +				MT9M111_TEST_PATTERN_GEN, pattern);
> +

This way, the V4L2 debug registers usage is still allowed, and your module
parameter works too.

Cheers.

--
Robert
