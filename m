Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:49640 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab1HYXnw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 19:43:52 -0400
Message-ID: <4E56DE32.6010809@linuxtv.org>
Date: Fri, 26 Aug 2011 01:43:46 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: Is DVB ioctl FE_SET_FRONTEND broken?
References: <1314314849.52943.YahooMailClassic@web121708.mail.ne1.yahoo.com>
In-Reply-To: <1314314849.52943.YahooMailClassic@web121708.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Chris,

On 26.08.2011 01:27, Chris Rankin wrote:
> As far as I understand it, the FE_SET_FRONTEND ioctl is supposed to tell a DVB device to tune itself, and will send a poll() event when it completes. The "frequency" parameter of this event will be the frequency of the newly tuned channel, or 0 if tuning failed.
> 
> http://www.linuxtv.org/docs/dvbapi/DVB_Frontend_API.html#SECTION00328000000000000000
> 
> I have now tested with 2 different DVB adapters, and I don't think the 3.0.x kernel still behaves like this. A study of the dvb-core/dvb_frontend.c file reveals the following code:
> 
> In the dvb_frontend_ioctl_legacy() function,
> 
>     switch(cmd) {
> 
>     ...
> 
>     case FE_SET_FRONTEND: {
> 
>         ...
> 
>         fepriv->state = FESTATE_RETUNE;
> 
>         /* Request the search algorithm to search */
>         fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
> 
>         dvb_frontend_wakeup(fe);
>         dvb_frontend_add_event(fe, 0);   // <--- HERE!!!!
>         fepriv->status = 0;
>         err = 0;
>         break;
>     }
> 
> So basically, the ioctl always sends an event immediately and does not wait for the tuning to happen first. Presumably, the device still tunes in the background and writes the frequency into the frontend's private structure so that a second FE_SET_FRONTEND ioctl succeeds. But this is not the documented behaviour.
> 
> The bug is visible when you try to use the device for the very first time. I tested by unloading / reloading the kernel modules, launching xine and then pressing its DVB button. This *always* fails the first time, for the reason described above, and works every time after that.

can you please test whether https://patchwork.kernel.org/patch/1036132/
restores the old behaviour?

These three pending patches are also related to frontend events:
https://patchwork.kernel.org/patch/1036112/
https://patchwork.kernel.org/patch/1036142/
https://patchwork.kernel.org/patch/1036122/

Regards,
Andreas
