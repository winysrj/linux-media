Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab2LORT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 12:19:59 -0500
Date: Sat, 15 Dec 2012 15:18:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 5/5] em28xx: fix+improve+unify i2c error handling, debug
 messages and code comments
Message-ID: <20121215151849.77d98e03@redhat.com>
In-Reply-To: <50CCA493.4070309@googlemail.com>
References: <1355502533-25636-1-git-send-email-fschaefer.oss@googlemail.com>
	<1355502533-25636-6-git-send-email-fschaefer.oss@googlemail.com>
	<50CB5BF8.5070201@iki.fi>
	<50CC7499.8020507@googlemail.com>
	<50CC7F4E.5060803@iki.fi>
	<50CCA493.4070309@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Dec 2012 17:25:55 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 15.12.2012 14:46, schrieb Antti Palosaari:
> > On 12/15/2012 03:01 PM, Frank Schäfer wrote:
> >> Am 14.12.2012 18:03, schrieb Antti Palosaari:
> >>> On 12/14/2012 06:28 PM, Frank Schäfer wrote:
> >>>> - check i2c slave address range (only 7 bit addresses supported)
> >>>> - do not pass USB specific error codes to userspace/i2c-subsystem
> >>>> - unify the returned error codes and make them compliant with
> >>>>     the i2c subsystem spec
> >>>> - check number of actually transferred bytes (via USB) everywehere
> >>>> - fix/improve debug messages
> >>>> - improve code comments
> >>>>
> >>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> >>>
> >>>
> >>>> @@ -244,16 +294,20 @@ static int em28xx_i2c_xfer(struct i2c_adapter
> >>>> *i2c_adap,
> >>>>            dprintk2(2, "%s %s addr=%x len=%d:",
> >>>>                 (msgs[i].flags & I2C_M_RD) ? "read" : "write",
> >>>>                 i == num - 1 ? "stop" : "nonstop", addr, msgs[i].len);
> >>>> +        if (addr > 0xff) {
> >>>> +            dprintk2(2, " ERROR: 10 bit addresses not supported\n");
> >>>> +            return -EOPNOTSUPP;
> >>>> +        }
> >>>
> >>> There is own flag for 10bit I2C address. Use it (and likely not
> >>> compare at all addr validly like that). This kind of address
> >>> validation check is quite unnecessary - and after all if it is wanted
> >>> then correct place is somewhere in I2C routines.
> >>
> >> Well, to be 100% sure and strict, we should check both, the flag and the
> >> actual address.
> >> We support 7 bit addresses only, no matter which i2c algo is used. So
> >> doing the address check in each i2c routine seems to be unnecessary code
> >> duplication to me ?
> >
> > I will repeat me, I see it overkill to check address correctness. And
> > as I said, that one is general validly could be done easily in I2C
> > core - so why the hell you wish make it just only for em28xx ?
> >
> > I am quite sure if that kind of address validness are saw important
> > they are already implemented by I2C core.
> >
> > Make patch for I2C which does that address validation against client
> > 10BIT flag and sent it to the mailing list for discussion.
> 
> The I2C core doesn't know about the capabilities of the adapter.
> Hence it doesn't know if ten bit addresses will work (the same as with
> the message size constraints).
> All it does ist to check the client for I2C_CLIENT_TEN && addr > 0x7f
> once, when it is instanciated with a call to i2c_new_device().
> But we don't use this function in em28xx and the same applies to many
> other drivers as well.
> Apart from that, the client address and flags can change anytime later
> (e.g. when probing devices).
> 
> But if you hate the check, I can kick it out.
> The risk that it will cause any problems in practice is small.

(c/c I2C maintainer)

I agree with Antti: instead of patching tons of drivers, the better is to
put such check inside the I2C core, as there are very few (if any) I2C
drivers with 10bit addresses.

> 
> Regards,
> Frank
> 
> >
> >> BTW: with the em28xx algorithm, the i2c address is transferred as 16 bit
> >> value. So 10 bit addresses COULD work in theory... ;)
> >
> > Could be, but I think 10bit is never used in real life.
> >
> > regards
> > Antti
> >
> 

Regards,
Mauro
