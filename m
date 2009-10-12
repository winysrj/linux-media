Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36517 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933483AbZJLWcA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 18:32:00 -0400
Message-ID: <4AD3AE34.6020305@iki.fi>
Date: Tue, 13 Oct 2009 01:31:16 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx mode switching
References: <829197380910121512y62a90cdcs49a0aa9606e8a588@mail.gmail.com>
In-Reply-To: <829197380910121512y62a90cdcs49a0aa9606e8a588@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/13/2009 01:12 AM, Devin Heitmueller wrote:
> I was debugging an issue on a user's hybrid board, when I realized
> that we are switching the em28xx mode whenever we start and stop dvb
> streaming.  We already have the ts_bus_ctrl callback implemented which
> puts the device into digital mode and puts it back into suspend
> whenever the frontend is opened/closed.
>
> This call seems redundant, and in fact can cause problems if the
> dvb_gpio definition strobes the reset pin, as it can put the driver
> out of sync with the demodulator's state (in fact this is what I ran
> into with the zl10353 - the reset pin got strobed when the streaming
> was started but the demod driver's init() routine was not being run
> because it already ran when the frontend was originally opened).
>
> The only case I can think of where toggling the device mode when
> starting/stopping dvb streaming might be useful is if we wanted to
> support being able to do an analog tune while the dvb frontend was
> still open but not streaming.  However, this seems like this could
> expose all sorts of bugs, and I think the locking would have to be
> significantly reworked if this were a design goal.
>
> Thoughts anybody?
>
> Devin

I ran this same trap few weeks ago when adding Reddo DVB-C USB Box 
support to em28xx :) Anyhow, since it is dvb only device I decided to 
switch from .dvb_gpio to .tuner_gpio to fix the problem. I haven't pull 
requested it yet.
http://linuxtv.org/hg/~anttip/reddo-dvb-c/rev/38f946af568f

Antti
-- 
http://palosaari.fi/
