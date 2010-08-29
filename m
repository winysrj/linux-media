Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:43728 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753792Ab0H2SfB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Aug 2010 14:35:01 -0400
Date: Sun, 29 Aug 2010 20:35:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Philipp Wiesner <p.wiesner@phytec.de>
Subject: Re: [PATCH v2 11/11] mt9m111: make use of testpattern
In-Reply-To: <8762ytmk57.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.1008291954470.2987@axis700.grange>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280833069-26993-12-git-send-email-m.grzeschik@pengutronix.de>
 <8762ytmk57.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Sun, 29 Aug 2010, Robert Jarzmik wrote:

> Michael Grzeschik <m.grzeschik@pengutronix.de> writes:
> 
> > Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> I would require a small change here.
> 
> I am using the testpattern for non regression tests. This change implies that
> the test pattern can only be set up by module parameters, and blocks the usage
> through V4L2 debug, registers, see below:
>         memset(&set_reg, 0, sizeof(set_reg));
>         set_reg.match.type = V4L2_CHIP_MATCH_I2C_ADDR;
>         set_reg.match.addr = 0x5d;
>         set_reg.reg = 0x148;
>         set_reg.val = test_pattern;
>         set_reg.size = 1;
>         if (test_pattern != -1)
>                 if (-1 == xioctl (fd, VIDIOC_DBG_S_REGISTER, &set_reg)) {
>                         fprintf (stderr, "%s could set test pattern %x\n",
>                                  dev_name, test_pattern);
>                         exit (EXIT_FAILURE);
>                 }
> 
> But, the idea is not bad. Therefore, I'd like you to change:
> > +	dev_dbg(&client->dev, "%s: using testpattern %d\n", __func__,
> > +			testpattern);
> > +
> > +	if (!ret)
> > +		ret = mt9m111_reg_set(client,
> > +				MT9M111_TEST_PATTERN_GEN, pattern);
> into
> > +	dev_dbg(&client->dev, "%s: using testpattern %d\n", __func__,
> > +			testpattern);
> > +
> > +	if (!ret && pattern)
> > +		ret = mt9m111_reg_set(client,
> > +				MT9M111_TEST_PATTERN_GEN, pattern);
> > +
> 
> This way, the V4L2 debug registers usage is still allowed, and your module
> parameter works too.

Yes, but this has another disadvantage - if you do not use s_register / 
g_register, maybe you just have CONFIG_VIDEO_ADV_DEBUG off, then, once you 
load the module with the testpattern parameter, you cannot switch using 
testpatterns off again (without a reboot or a power cycle). With the 
original version you can load the driver with the parameter set, then 
unload it, load it without the parameter and testpattern would be cleared. 
In general, I think, using direct register access is discouraged, 
especially if there's a way to set the same functionality using driver's 
supported interfaces. Hm, if I'm not mistaken, it has once been mentioned, 
that these test-patterns can be nicely implemented using the S_INPUT 
ioctl(). Am I right? How about that? But we'd need a confirmation for 
that, I'm not 100% sure.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
