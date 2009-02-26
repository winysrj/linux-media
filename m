Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:15057 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbZBZKzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 05:55:53 -0500
Received: by rv-out-0506.google.com with SMTP id g37so492827rvb.1
        for <linux-media@vger.kernel.org>; Thu, 26 Feb 2009 02:55:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0902050846080.5553@axis700.grange>
References: <ubpthwd06.wl%morimoto.kuninori@renesas.com>
	 <Pine.LNX.4.64.0902050846080.5553@axis700.grange>
Date: Thu, 26 Feb 2009 19:55:51 +0900
Message-ID: <aec7e5c30902260255h71e483cbgcc1af6beb9fd4409@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] sh_mobile_ceu: Add field signal operation
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 5, 2009 at 5:04 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Tue, 3 Feb 2009, Kuninori Morimoto wrote:
>
>> sh_mobile_ceu can support "field signal" from external module.
>> To support this operation, SH_CEU_FLAG_USE_FLDID_{HIGH, LOW}
>> are added to header.
>
> I never dealt with interlaced video, so, I probably just don't understand
> something, please explain. I understand the Field ID signal is optional,
> and, if used, it can be either active high or low. But who gets to decide
> which polarity is applicable in a specific case? The platform? Is it not
> like with other control signals, where if both partners are freely
> configurable, then any polarity can be used; if one is configurable and
> another is hard-wired, only one polarity can be used. And as long as the
> signal is available (connected), the platform has no further influence on
> its use? Ok, there can be an inverter there, but that we can handle too.

I believe you are correct. It is just yet another signal.

> So, wouldn't something like
>
> +       if (pcdev->pdata->flags & SH_CEU_FLAG_USE_FLDID)
> +               flags |= SOCAM_FIELD_ID_ACTIVE_HIGH | SOCAM_FIELD_ID_ACTIVE_LOW;
> +
>
> ...
>
> +       if (common_flags & (SOCAM_FIELD_ID_ACTIVE_HIGH | SOCAM_FIELD_ID_ACTIVE_LOW) ==
> +           SOCAM_FIELD_ID_ACTIVE_LOW)
> +               /* The client only supports active low field ID */
> +               value |= 1 << 16;
> +       /* Otherwise we are free to choose, leave default active high */
>
> Or does Field ID work differently?

Nope, it works just like that. I guess what makes this confusing is
that we have some boards that don't have the FLD signal. So far the
CEU driver has had it's configuration passed as platform data, but
making it more generic and fit better to the soc-camera framework is
of course a good idea. But we may need a way to specify the actual
configuration of our board.

So the TV decoder chip has a field signal. So does the CEU. But not
early versions of the board.

> And what do you do, if the platform doesn't specify SH_CEU_FLAG_USE_FLDID,
> i.e., it is not connected, but the client does? Or the other way round? In
> other words, is it a working configuration, when one of the partners
> provides this signal and the other one doesn't? I guess it is, because,
> you say, it is optional. So we shouldn't test it in
> soc_camera_bus_param_compatible()?

I made a hack half a year ago that worked around the interlaced
640x480 video with missing field signal to 640x240 progressive.
Basically exactly the same as interlace for the TV decoder but the CEU
is configured in 640x240 progressive mode and gets the double amount
of frames per second.

Not sure if we want such a feature upstream though, so maybe this may
be a non-issue. =)

Cheers,

/ magnus
