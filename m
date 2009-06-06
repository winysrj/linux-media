Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:37266 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZFFWUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 18:20:25 -0400
MIME-Version: 1.0
In-Reply-To: <200906061500.49338.hverkuil@xs4all.nl>
References: <200906061500.49338.hverkuil@xs4all.nl>
Date: Sat, 6 Jun 2009 18:20:26 -0400
Message-ID: <9e4733910906061520o7b0b2858wf4530cf672b1adc9@mail.gmail.com>
Subject: Re: RFC: proposal for new i2c.h macro to initialize i2c address lists
	on the fly
From: Jon Smirl <jonsmirl@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-i2c@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 6, 2009 at 9:00 AM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> Hi all,
>
> For video4linux we sometimes need to probe for a single i2c address.
> Normally you would do it like this:

Why does video4linux need to probe to find i2c devices? Can't the
address be determined by knowing the PCI ID of the board?


>
> static const unsigned short addrs[] = {
>        addr, I2C_CLIENT_END
> };
>
> client = i2c_new_probed_device(adapter, &info, addrs);
>
> This is a bit awkward and I came up with this macro:
>
> #define V4L2_I2C_ADDRS(addr, addrs...) \
>        ((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END })
>
> This can construct a list of one or more i2c addresses on the fly. But this
> is something that really belongs in i2c.h, renamed to I2C_ADDRS.
>
> With this macro we can just do:
>
> client = i2c_new_probed_device(adapter, &info, I2C_ADDRS(addr));
>
> Comments?
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Jon Smirl
jonsmirl@gmail.com
