Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:48793 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756279Ab0IIXTQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Sep 2010 19:19:16 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [GIT PULL FOR 2.6.37] new AF9015 devices
Date: Fri, 10 Sep 2010 01:19:04 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, TerraTux <terratux@terratec.de>
References: <4C894DB8.8080908@iki.fi>
In-Reply-To: <4C894DB8.8080908@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009100119.08993.s.L-H@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi

On Friday 10 September 2010, Antti Palosaari wrote:
> Moikka Mauro!
> This patch series adds support for TerraTec Cinergy T Stick Dual RC and 
> TerraTec Cinergy T Stick RC. Also MxL5007T devices with ref. design IDs 
> should be working. Cinergy T Stick remote is most likely not working 
> since it seems to use different remote as Cinergy T Dual... Stefan could 
> you test and ensure T Stick is working?
> 
> and thanks to TerraTec!
[...]

DVB-T is working fine with my TerraTec "Cinergy T RC MKII" 0ccd:0097 
(branch af9015), as you expected the remote control doesn't react to 
the generic USB_VID_TERRATEC matching and the given IR codes. No ill 
effects though, the shipped remote just appears to be "dead" with those
settings. So these patches are fine and aren't a regression for my device.


I actually tried my luck with your suggestions for debugging the IR 
support, but as the remote continued to act in a weird (bouncing keycodes 
and no stable mappings at all), I didn't get very far. Except that the
EEPROM hash is 0x11f6768f.

A brutal first attempt to replace the predefined ir_codes_terratec/ 
af9015_ir_terratec with my current assumptions results in very similar,
erratic behaviour:

static struct ir_scancode ir_codes_terratec[] = {
	{ 0x0057, KEY_1 },
	{ 0x0020, KEY_2 },
	{ 0x0026, KEY_3 },
	{ 0x0056, KEY_4 },
	{ 0x0021, KEY_5 },
	{ 0x0027, KEY_6 },
	{ 0x004b, KEY_7 },
	{ 0x0022, KEY_8 },
	{ 0x0009, KEY_9 },
	{ 0x0023, KEY_0 },
	{ 0x0024, KEY_CHANNELUP },
	{ 0x0025, KEY_CHANNELDOWN },
	{ 0x004e, KEY_ZOOM },
	{ 0x0010, KEY_MUTE },
	{ 0x001f, KEY_VOLUMEDOWN },
	{ 0x001e, KEY_VOLUMEUP },
	{ 0x001c, KEY_GOTO },         /* jump */
	{ 0x043d, KEY_POWER },
};

static u8 af9015_ir_terratec[] = {
	0x80, 0x7f, 0x12, 0xed, 0x3d, 0x04, 0x00, /* power */
	0x80, 0x7f, 0x01, 0xfe, 0x10, 0x00, 0x00, /* mute */
	0x80, 0x7f, 0x1a, 0xe5, 0x57, 0x00, 0x00, /* 1 */
	0x80, 0x7f, 0x02, 0xfd, 0x56, 0x00, 0x00, /* 4 */
	0x80, 0x7f, 0x1e, 0xe1, 0x4b, 0x00, 0x00, /* 7 */
	0x80, 0x7f, 0x03, 0xfc, 0x4e, 0x00, 0x00, /* zoom */
	0x80, 0x7f, 0x04, 0xfb, 0x1e, 0x00, 0x00, /* volume up */
	0x80, 0x7f, 0x05, 0xfa, 0x1f, 0x00, 0x00, /* volume down */
	0x80, 0x7f, 0x06, 0xf9, 0x20, 0x00, 0x00, /* 2 */
	0x80, 0x7f, 0x07, 0xf8, 0x21, 0x00, 0x00, /* 5 */
	0x80, 0x7f, 0x08, 0xf7, 0x22, 0x00, 0x00, /* 8 */
	0x80, 0x7f, 0x09, 0xf6, 0x23, 0x00, 0x00, /* 0 */
	0x80, 0x7f, 0x0a, 0xf5, 0x24, 0x00, 0x00, /* channel up */
	0x80, 0x7f, 0x1b, 0xe4, 0x25, 0x00, 0x00, /* channel down */
	0x80, 0x7f, 0x1f, 0xe0, 0x26, 0x00, 0x00, /* 3 */
	0x80, 0x7f, 0x0d, 0xf2, 0x27, 0x00, 0x00, /* 6 */
	0x80, 0x7f, 0x0c, 0xf3, 0x09, 0x00, 0x00, /* 9 */
	0x80, 0x7f, 0x0e, 0xf1, 0x1c, 0x00, 0x00, /* jump */
};

The numbers seem to match, the rest was mostly "guessed" from the apparent 
strategy (top-->down. left-->right), but pressing '1' still results in 
"111111" (repeating until terminated by ctrl-c), pressing '4' in "54444445"
(until terminated).

Regards
	Stefan Lippers-Hollmann
