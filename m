Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55377 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729741AbeKEHun (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 02:50:43 -0500
Date: Sun, 4 Nov 2018 22:34:09 +0000
From: Sean Young <sean@mess.org>
To: Benjamin Valentin <benpicco@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [RFC] [PATCH] media: rc: Improve responsiveness of Xbox DVD
 Remote
Message-ID: <20181104223409.yxdz77ukbl6j7yyx@gofer.mess.org>
References: <20181104215746.113942a9@rechenknecht2k11>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181104215746.113942a9@rechenknecht2k11>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 04, 2018 at 09:57:46PM +0100, Benjamin Valentin wrote:
> The Xbox DVD Remote feels somewhat sluggish, pressing a button
> repeatedly is sometimes interpreted as it being kept pressed down.
> 
> It seems like the RC subsystem is doing some incorrect heuristics when
> in fact the data that comes from the device is already pretty clean.
> 
> When looking at rc_keydown(), the timeout parameter for a keypress
> seems to be relevant here.
> 
> And indeed changing it from the default value of 125000000 to something
> lower improves situation greatly.
> I'm not sure what the 'correct' value is here - even just setting it to
> 0 works fine and might even be the proper thing to do as the receiver
> dongle seems to do some filtering on it's own?

If a button is held down, then the remote will keep on repeating the same
message over and over again. When the button is released, then it stops
sending the message. We want to send the key up event when the button
is released, but not when held down. So, rc-core sets up up the keyup
timer for this, which is rearmed each a time an IR message is received.

There are two values involved here; one is how much time there is between
two IR messages when a key held down, this the protocol repeat period. This
is purely on IR protocol level.

The second is how long will it take (maximum) for the IR receiver to
deliver that message to rc-core, and that is the timeout you've modified
here. If the usb bus is highly contented there might some delay here
from one message to the next, for example. Or the IR receiver device might
do some of its own filtering.

So there is no protocol define for the xbox protocol, so we use
RC_PROTO_UNKNOWN for now. This has a default repeat period of 125ms. It
would be useful to know if this is wrong for this protocol. If it, we
should define a new protocol RC_PROTO_XBOX and give it the right
repeat period.

Using a raw IR receiver you measure this easily using:

	ir-ctl -r -t 500000

And then adding up all the pulse/spaces for each message, including the
long space between two IR messages.

For the IR receiver timeout, this is kind of hard to measure. raw IR
receivers tend to be worse here, because they rely on the IR timeout,
which is usually worse for the last IR message than any between IR messages.

Any IR receivers which do the the decoding themselves tend to deliver
the decoded scancode as soon as the final pulse is observed. A bit of
experimentation will suffice here.


Sean

> 
> ---
>  drivers/media/rc/xbox_remote.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/rc/xbox_remote.c b/drivers/media/rc/xbox_remote.c
> index 07ed9be24a60..496f1394216d 100644
> --- a/drivers/media/rc/xbox_remote.c
> +++ b/drivers/media/rc/xbox_remote.c
> @@ -157,6 +157,8 @@ static void xbox_remote_rc_init(struct xbox_remote *xbox_remote)
>  	rdev->device_name = xbox_remote->rc_name;
>  	rdev->input_phys = xbox_remote->rc_phys;
>  
> +	rdev->timeout = 1000;
> +
>  	usb_to_input_id(xbox_remote->udev, &rdev->input_id);
>  	rdev->dev.parent = &xbox_remote->interface->dev;
>  }
