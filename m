Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:60366 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbaAQKTc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 05:19:32 -0500
Date: Fri, 17 Jan 2014 10:19:29 +0000
From: Sean Young <sean@mess.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: only turn on LED if keypress generated
Message-ID: <20140117101929.GA2531@pequod.mess.org>
References: <1389912982-25956-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389912982-25956-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 16, 2014 at 10:56:22PM +0000, James Hogan wrote:
> Since v3.12, specifically 153a60bb0fac ([media] rc: add feedback led
> trigger for rc keypresses), an LED trigger is activated on IR keydown
> whether or not a keypress is generated (i.e. even if there's no matching
> keycode). However the repeat and keyup logic isn't used unless there is
> a keypress, which results in non-keypress keydown events turning on the
> LED and not turning it off again.

Yes, this is a bug. I have a similar patch waiting to be submitted but
you beat me to it. 

Acked-by: Sean Young <sean@mess.org>

> 
> On the assumption that the intent was for the LED only to light up on
> valid key presses (you probably don't want it lighting up for the wrong
> remote control for example), move the led_trigger_event() call inside
> the keycode check.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Sean Young <sean@mess.org>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> ---
> Was that the original intent? If not it could be tweaked to set
> dev->keypressed in either case instead, so that they LED trigger works
> for unmapped scancodes too.

I'd say that the feedback led should only be activated if a valid key is
pressed; doing this for for unmapped scancodes is jus going to cause confusion.

> ---
>  drivers/media/rc/rc-main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 46da365..cff9d53 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -649,9 +649,10 @@ static void ir_do_keydown(struct rc_dev *dev, int scancode,
>  			   "key 0x%04x, scancode 0x%04x\n",
>  			   dev->input_name, keycode, scancode);
>  		input_report_key(dev->input_dev, keycode, 1);
> +
> +		led_trigger_event(led_feedback, LED_FULL);
>  	}
>  
> -	led_trigger_event(led_feedback, LED_FULL);
>  	input_sync(dev->input_dev);
>  }
>  
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
