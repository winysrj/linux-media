Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41856 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZH1OCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 10:02:36 -0400
Date: Fri, 28 Aug 2009 11:02:30 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Ville =?ISO-8859-1?B?U3lyauRs5A==?= <syrjala@sci.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Input <linux-input@vger.kernel.org>
Subject: Re: [RFC] Infrared Keycode standardization
Message-ID: <20090828110230.59dd25e7@pedra.chehab.org>
In-Reply-To: <1251459682.3187.38.camel@palomino.walls.org>
References: <20090827045710.2d8a7010@pedra.chehab.org>
	<20090827183636.GG26702@sci.fi>
	<20090827185853.0aa2de76@pedra.chehab.org>
	<829197380908271506i251b47caoe8c08d483e78e938@mail.gmail.com>
	<1251459682.3187.38.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Aug 2009 07:41:22 -0400
Andy Walls <awalls@radix.net> escreveu:

> On Thu, 2009-08-27 at 18:06 -0400, Devin Heitmueller wrote:
> > On Thu, Aug 27, 2009 at 5:58 PM, Mauro Carvalho
> > Chehab<mchehab@infradead.org> wrote:
> > > Em Thu, 27 Aug 2009 21:36:36 +0300
> > > Ville Syrjälä <syrjala@sci.fi> escreveu:
> 
> > Since we're on the topic of IR support, there are probably a couple of
> > other things we may want to be thinking about if we plan on
> > refactoring the API at all:
> > 
> > 1.  The fact that for RC5 remote controls, the tables in ir-keymaps.c
> > only have the second byte.  In theory, they should have both bytes
> > since the vendor byte helps prevents receiving spurious commands from
> > unrelated remote controls.  We should include the ability to "ignore
> > the vendor byte" so we can continue to support all the remotes
> > currently in the ir-keymaps.c where we don't know what the vendor byte
> > should contain.
> 
> Since I uncovered this in my research, I thought I'd share...
> 
> RC-6A has a third (or thrid and fouth) byte:
> 
> http://www.picbasic.nl/frameload_uk.htm?http://www.picbasic.nl/info_rc6_uk.htm
> 
> for the "Customer Identifier".
> 
> It appears that the mode bits in the header determine if RC-6 (mode 0)
> or RC-6A is in use.  The position of the mode bits in the header are
> documented here:
> 
> http://www.sbprojects.com/knowledge/ir/rc6.htm
> 
> I'm guesing some MCE remotes use RC-6A.  When I get CX23888 IR support
> to the point of actually working, I'll check both of my MCE remotes.

Andy,

If you look at the get_key functions at ir-kbd-i2c, you'll see that some
remotes (and/or maybe the ir decoding chip) sends code with up to 6 chars (some
bits were used there for keycode sync). So, probably, there are already some
rc6 IR's around.

While it would theoretically be possible to still use
EVIOCGKEYCODE/EVIOCSKEYCODE for handling 24 or 32 bits scan codes at the way I've
proposed, I suspect that this won't scale. In order to get the current keycode
table, userspace needs to do something like:
	for (i = 0; i <= LAST_SCANCODE; i++)
		ioctl(fd, EVIOCGKEYCODE, codes);

On a set operation, it will do about the same loop 4 times - since internally a
set operation also calls a get, and since we need first to clean the entire
table before adding the new codes (so, we'll have 2^32 to 2^34 get/set
operations).

On my tests, with MAX_SCANCODE of 0xffff (the maximum currently supported by
dvb-usb), this happens really fast. Still, this is not an efficient code, since a
real table size is generally lower than 40 scancodes wide, but as keycode table
load is not a frequent operation (generally, it will happen only during boot
time, on a real case), I don't think we should bother with optimizing it for
2^16.

I haven't tested, but I doubt that seeking for a 4 byte scancode would be fast
enough, since it is a wild goose chase to seek for 40 valid codes in the
middle of 2^32 to 2^34 codes, during a keycode table load/save operation.

I can see a few possible solutions for it:

1) send some IR mask to the driver (or hardcode the mask) for the driver to
filter just the valid the IR codes, and use a 16 bit scancode for it. This will
use a strategy similar to what we currently have at ir-common, and could mean
that we'll have to discuss the approach again some years later;

2) create some EVIOCGKEYCODE/EVIOCSKEYCODE variants that will be based on a sequencial
index, not based on scancode.

3) create some table load/save methods at the input system, to allow
changing the entire table at once, maybe using an approach similar to
request_firmware.

Currently, V4L drivers have their IR tables declared as:

u32 ir_table[IR_KEYTAB_SIZE];	/* IR_KEYTAB_SIZE is the size of the scantable, currently 128 */

while dvb-usb (and some other DVB drivers) use:

struct dvb_usb_rc_key {
        u8 custom,data;
        u32 event;
};

In order to implement the second approach, the better would be to use something like:

	struct {
		be32 scancode;
		u32 keycode;
	};

It shouldn't be hard to write a few scripts for doing this conversion for both
DVB and V4L type of tables.

Even if we opt for a different approach, I still think that the better is to
merge "custom" and "data" at scancode, since it would be easier to extend
the number of bits, if later needed.

Cheers,
Mauro
