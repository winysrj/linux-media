Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3213 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab1DRQzm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 12:55:42 -0400
Message-ID: <ebc1f00e7c3dc1e0956e9ffc7aa73bff.squirrel@webmail.xs4all.nl>
In-Reply-To: <Pine.LNX.4.64.1104181803340.27247@axis700.grange>
References: <Pine.LNX.4.64.1104181603470.27247@axis700.grange>
    <20110419001020.A4B5.B41FCDD0@s9.dion.ne.jp>
    <20110419005717.E36F.B41FCDD0@s9.dion.ne.jp>
    <Pine.LNX.4.64.1104181803340.27247@axis700.grange>
Date: Mon, 18 Apr 2011 18:55:31 +0200
Subject: Re: soc_camera with V4L2 driver
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Akira Tsukamoto" <akira-t@s9.dion.ne.jp>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> On Tue, 19 Apr 2011, Akira Tsukamoto wrote:
>
>> Hello Guennadi,
>>
>> > > >  static struct i2c_board_info i2c0_devices[] = {
>> > > >  	{
>> > > >  		I2C_BOARD_INFO("ag5evm_ts", 0x20),
>> > > >  		.irq	= pint2irq(12),	/* PINTC3 */
>> > > >  	},
>> > > > +	/* 2M camera */
>> > > > +	{
>> > > > +		I2C_BOARD_INFO("rj65na20", 0x40),
>> > > > +	},
>> > >
>> > > No, you do not have to include this here, the sensor must not be
>> registered
>> > > automatically during the board initialisation.
>>
>> I have one more question before sleeping :)
>>
>> The camera module needs to be initialized by writing values to the
>> registers.
>> Do I need to write init function at the following?
>>
>> static const struct v4l2_subdev_core_ops rj65na20_core_ops = {
>>          .reset = rj65na20_reset,
>> [snip]
>> }
>
> AFAICS neither soc_camera.c, nor sh_mobile_ceu_camera.c call the .reset
> subdevice core method, so, no, at the moment implementing it wouldn't
> produce any result. Either you have to choose one of the methods, that are
> currently called, or you have to add a call to .reset() as required.

I don't really like the use of reset for this. The reset op is a pretty
poorly defined op. There is a registration op as well these days that
might be better suited for this (see struct v4l2_subdev_internal_ops).

Regards,

        Hans

>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


