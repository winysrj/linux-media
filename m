Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:62821 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZAVU72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 15:59:28 -0500
Received: by qyk4 with SMTP id 4so4838226qyk.13
        for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 12:59:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <39c74bb90901221255y6a278b1bkff01875551a426c3@mail.gmail.com>
References: <39c74bb90901221255y6a278b1bkff01875551a426c3@mail.gmail.com>
Date: Thu, 22 Jan 2009 15:59:26 -0500
Message-ID: <412bdbff0901221259q3c21d678v6e9e0e0a5e863b98@mail.gmail.com>
Subject: Re: Hauppauge TD-500
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Glen Ford <glen.a.ford@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 22, 2009 at 3:55 PM, Glen Ford <glen.a.ford@gmail.com> wrote:
> Hi,
>
>
> I am assuming this is the right list to post to.
>
> I recently setup MythBuntu on my system with Hauppauge TD-500 - the
> system worked except for the IR Remote Control - I tried using the
> latest v4l-dvb from the Hg repo to no avail.
>
> I had to make the following changes to dib0700_devices.c in order for
> the remote to be recognised and appear as an event device (other
> changes needed for MythBuntu itself can be found on my ubuntuforum
> post here: http://ubuntuforums.org/showthread.php?p=6509202#post6509202)
>
> root@pvr:~/dvb/v4l-dvb# hg diff
> diff -r f4d7d0b84940 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
> --- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Sun Jan 18
> 10:55:38 2009 +0000
> +++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Wed Jan 21
> 19:41:36 2009 +0000
> @@ -1683,7 +1683,13 @@
>                                { &dib0700_usb_id_table[43], NULL },
>                                { NULL },
>                        }
> -               }
> +               },
> +
> +               .rc_interval      = DEFAULT_RC_INTERVAL,
> +               .rc_key_map       = dib0700_rc_keys,
> +               .rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
> +               .rc_query         = dib0700_rc_query
> +
>        }, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>
>                .num_adapters = 1
>
> Regards,
>
>
> Glen

Hello Glen,

This exact patch has already been merged into my tree (contributed by
Arne Luehrs), and a PULL request was sent to Mauro on Tuesday for it
to go into the mainline v4l-dvb.

http://linuxtv.org/hg/~dheitmueller/dib0700-pbfixes/rev/cf6003290b09

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
