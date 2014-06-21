Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49439 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059AbaFUCuW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jun 2014 22:50:22 -0400
Message-ID: <53A4F2EA.6070600@iki.fi>
Date: Sat, 21 Jun 2014 05:50:18 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Best way to add subdev that doesn't use I2C or SPI?
References: <CAGoCfiyeHbYYTSYY_VPEXJ4z8668w6LdjprW1+FbMJCOoCekwA@mail.gmail.com>
In-Reply-To: <CAGoCfiyeHbYYTSYY_VPEXJ4z8668w6LdjprW1+FbMJCOoCekwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Devin

On 06/21/2014 04:58 AM, Devin Heitmueller wrote:
> Hello,
>
> I'm in the process of adding support for a new video decoder.  However
> in this case it's an IP block on a USB bridge as opposed to the
> typical case which is an I2C device.  Changing registers for the
> subdev is the same mechanism as changing registers in the rest of the
> bridge (a specific region of registers is allocated for the video
> decoder).
>
> Doing a subdev driver seems like the logical approach to keep the
> video decoder related routines separate from the rest of the bridge.
> It also allows the reuse of the code if we find other cases where the
> IP block is present in other devices.  However I'm not really sure
> what the mechanics are for creating a subdev that isn't really an I2C
> device.
>
> I think we've had similar cases with the Conexant parts where the Mako
> was actually a block on the main bridge (i.e. cx23885/7/8, cx231xx).
> But in that case the cx25840 subdev just issues I2C commands and
> leverages the fact that you can talk to the parts over I2C even though
> they're really on-chip.
>
> Are there any other cases today where we have a subdev that uses
> traditional register access routines provided by the bridge driver to
> read/write the video decoder registers?  In this case I would want to
> reuse the register read/write routines provided by the bridge, which
> ultimately are send as USB control messages.
>
> Any suggestions welcome (and in particular if you can point me to an
> example case where this is already being done).
>
> Thanks in advance,
>
> Devin

Abuse I2C bus. If your integrated IP block is later sold as a separate 
chip, there is likely I2C bus used then. If you now abuse I2C it could 
be even possible that no changes at all is then needed or only small fixes.

I have done that few times, not for V4L2 sub-device, but on DVB side. 
For example AF9015/AF9013 and AF9035/AF9033/IT913x.

regards
Antti

-- 
http://palosaari.fi/
