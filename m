Return-path: <mchehab@pedra>
Received: from smtp6-g21.free.fr ([212.27.42.6]:49415 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab0H2TRJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Aug 2010 15:17:09 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Philipp Wiesner <p.wiesner@phytec.de>
Subject: Re: [PATCH v2 10/11] mt9m111: rewrite set_pixfmt
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
	<1280833069-26993-11-git-send-email-m.grzeschik@pengutronix.de>
	<Pine.LNX.4.64.1008271335200.28043@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 29 Aug 2010 21:17:00 +0200
In-Reply-To: <Pine.LNX.4.64.1008271335200.28043@axis700.grange> (Guennadi Liakhovetski's message of "Fri\, 27 Aug 2010 13\:42\:24 +0200 \(CEST\)")
Message-ID: <871v9hmdoz.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Robert, I'll need your ack / tested by on this one too. It actually 
> changes behaviour, for example, it sets MT9M111_OUTFMT_FLIP_BAYER_ROW in 
> the OUTPUT_FORMAT_CTRL register for the V4L2_MBUS_FMT_SBGGR8_1X8 8 bit 
> Bayer format. Maybe other things too - please have a look.

For the YUV and RGB formats, tested and acked.
For the bayer, I don't use it. With row switch, that gives back:
byte offset: 0 1 2 3
             B G B G
             G R G R

Without the switch:
byte offset: 0 1 2 3
             G R G R
             B G B G

I would have expected the second version (ie. without the switch, ie. the
original version of mt9m111 driver) to be correct, but I might be wrong. Maybe
Michael can enlighten me here.

-- 
Robert
