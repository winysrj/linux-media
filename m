Return-path: <mchehab@pedra>
Received: from smtp6-g21.free.fr ([212.27.42.6]:43269 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab1AaUuX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 15:50:23 -0500
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [RFC PATCH 04/12] mt9m111.c: convert to the control framework.
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
	<8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
	<56c1a8ef6e1a5405881611a18579db98e271fb86.1294786597.git.hverkuil@xs4all.nl>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 31 Jan 2011 21:50:12 +0100
In-Reply-To: <56c1a8ef6e1a5405881611a18579db98e271fb86.1294786597.git.hverkuil@xs4all.nl> (Hans Verkuil's message of "Wed\, 12 Jan 2011 00\:06\:04 +0100")
Message-ID: <87pqrcyf0b.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans Verkuil <hverkuil@xs4all.nl> writes:

[zip]

> @@ -1067,6 +968,26 @@ static int mt9m111_probe(struct i2c_client *client,
>  		return -ENOMEM;
>  
>  	v4l2_i2c_subdev_init(&mt9m111->subdev, client, &mt9m111_subdev_ops);
> +	v4l2_ctrl_handler_init(&mt9m111->hdl, 5);
> +	v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
> +			V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
> +			V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
> +			V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
> +	mt9m111->gain = v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
> +			V4L2_CID_GAIN, 0, 63 * 2 * 2, 1, 32);
> +	v4l2_ctrl_new_std_menu(&mt9m111->hdl,
> +			&mt9m111_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,
> +			V4L2_EXPOSURE_AUTO);
> +	mt9m111->subdev.ctrl_handler = &mt9m111->hdl;
> +	if (mt9m111->hdl.error) {
> +		int err = mt9m111->hdl.error;
> +
> +		kfree(mt9m111);
> +		return err;
> +	}
> +	mt9m111->gain->is_volatile = 1;

Hi Hans,

I would like to shift all the control initializations into one subfunction,
called from mt9m111_probe(). Right now it's not an issue, but if future
development adds a lot of controls, I'd like the controls initialization to be
gathered in one method.

Apart from that, I have no special comment.

Cheers.

--
Robert
