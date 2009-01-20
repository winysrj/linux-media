Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:1884 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbZATTJy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 14:09:54 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1501553qwe.37
        for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 11:09:53 -0800 (PST)
Message-ID: <412bdbff0901201109i8542c7erb1a0abb956e6817e@mail.gmail.com>
Date: Tue, 20 Jan 2009 14:09:53 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Luhrs, Arne F.E." <arne.luehrs@hp.com>
Subject: Re: [PATCH] Hauppauge WinTV-Nova-T 500 - problem wit internal IR receiver
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <1A5872E54ACA7C40BE798507A106BB203ADEC6B4D8@GVW1163EXB.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f6e4f67d0901200834o1933d4d0n6687cfb9b3d87032@mail.gmail.com>
	 <1A5872E54ACA7C40BE798507A106BB203ADEC6B4D8@GVW1163EXB.americas.hpqcorp.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 20, 2009 at 2:05 PM, Luhrs, Arne F.E. <arne.luehrs@hp.com> wrote:
> changeset:   10236:f49ac8245842
> tag:         tip
> user:        Arne Luehrs <arne.luehrs@googlemail.com>
> date:        Wed Jan 14 23:01:07 2009 +0100
> files:       linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
> description:
> [PATCH] enable IR receiver in Nova TD usb stick (52009)
>
> From: Arne Luehrs <arne.luehrs@googlemail.com>
>
> Adds the IR data structur to the configuration datastructure of the
> Hauppauge WinTV Nova-TD USB stick (52009)
>
> Provided remote control is the same as theone provided with the Nova-T500
> Card.
>
> Priority: normal
>
>
> Signed-off-by: Arne Luehrs <arne.luehrs@googlemail.com>
> diff -r 6896782d783d -r f49ac8245842 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
> --- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Wed Jan 14 10:06:12 2009 -0200
> +++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Wed Jan 14 23:01:07 2009 +0100
> @@ -1683,7 +1683,12 @@
>                                { &dib0700_usb_id_table[43], NULL },
>
>                                { NULL },
>                        }
> -               }
> +               },
> +
> +               .rc_interval      = DEFAULT_RC_INTERVAL,
> +               .rc_key_map       = dib0700_rc_keys,
> +               .rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
> +               .rc_query         = dib0700_rc_query
>        }, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>
>                .num_adapters = 1,

I haven't forgotten about this.  It's in a batch of five or six
patches I have queued up for Patrick Boettcher which I will hopefully
submit to him this week.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
