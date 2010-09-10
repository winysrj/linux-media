Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:39193 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752854Ab0IJAyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 20:54:14 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [GIT PULL FOR 2.6.37] new AF9015 devices
Date: Fri, 10 Sep 2010 02:54:05 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, TerraTux <terratux@terratec.de>
References: <4C894DB8.8080908@iki.fi>
In-Reply-To: <4C894DB8.8080908@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009100254.07762.s.L-H@gmx.de>
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

Another test and some further debugging of the IR core usedby the af9015 
branch of this git tree led me to partial success. DVB-T functionality 
continues to be fine and I've now found the proper values for this remote,
however once a key gets pressed, it is never released (unless another key 
gets pressed which is then struck or unless I ctrl-c it (only works on 
terminals). Likewise I'm not sure yet how to distinguish between the 
"Cinergy T Dual" and my "Cinergy T RC MKII":

lsusb:		0ccd:0097 TerraTec Electronic GmbH Cinergy T RC MKII
EEPROM hash:	0x11f6768f

static struct ir_scancode ir_codes_terratec[] = {
	{ 0x001e, KEY_1 },
	{ 0x001f, KEY_2 },
	{ 0x0020, KEY_3 },
	{ 0x0021, KEY_4 },
	{ 0x0022, KEY_5 },
	{ 0x0023, KEY_6 },
	{ 0x0024, KEY_7 },
	{ 0x0025, KEY_8 },
	{ 0x0026, KEY_9 },
	{ 0x0027, KEY_0 },
	{ 0x004b, KEY_CHANNELUP },
	{ 0x004e, KEY_CHANNELDOWN },
	{ 0x0009, KEY_ZOOM },
	{ 0x0010, KEY_MUTE },
	{ 0x0056, KEY_VOLUMEDOWN },
	{ 0x0057, KEY_VOLUMEUP },
	{ 0x001c, KEY_GOTO },	/* jump */
	{ 0x043d, KEY_POWER },
};

static u8 af9015_ir_terratec[] = {
	0x80, 0x7f, 0x12, 0xed, 0x3d, 0x04, 0x00, /* power */
	0x80, 0x7f, 0x01, 0xfe, 0x10, 0x00, 0x00, /* mute */
	0x80, 0x7f, 0x1a, 0xe5, 0x57, 0x00, 0x00, /* vol+ */
	0x80, 0x7f, 0x02, 0xfd, 0x56, 0x00, 0x00, /* vol- */
	0x80, 0x7f, 0x1e, 0xe1, 0x4b, 0x00, 0x00, /* ch+ */
	0x80, 0x7f, 0x03, 0xfc, 0x4e, 0x00, 0x00, /* ch- */
	0x80, 0x7f, 0x04, 0xfb, 0x1e, 0x00, 0x00, /* 1 */
	0x80, 0x7f, 0x05, 0xfa, 0x1f, 0x00, 0x00, /* 2 */
	0x80, 0x7f, 0x06, 0xf9, 0x20, 0x00, 0x00, /* 3 */
	0x80, 0x7f, 0x07, 0xf8, 0x21, 0x00, 0x00, /* 4 */
	0x80, 0x7f, 0x08, 0xf7, 0x22, 0x00, 0x00, /* 5 */
	0x80, 0x7f, 0x09, 0xf6, 0x23, 0x00, 0x00, /* 6 */
	0x80, 0x7f, 0x0a, 0xf5, 0x24, 0x00, 0x00, /* 7 */
	0x80, 0x7f, 0x1b, 0xe4, 0x25, 0x00, 0x00, /* 8 */
	0x80, 0x7f, 0x1f, 0xe0, 0x26, 0x00, 0x00, /* 9 */
	0x80, 0x7f, 0x0d, 0xf2, 0x27, 0x00, 0x00, /* 0 */
	0x80, 0x7f, 0x0c, 0xf3, 0x09, 0x00, 0x00, /* zoom */
	0x80, 0x7f, 0x0e, 0xf1, 0x1c, 0x00, 0x00, /* jump */
};

Likewise lirc's irrecord comes up with this lircd.conf:

begin remote

  name  lircd.conf.Cinergy-T-RC-MKII
  bits           56
  eps            30
  aeps          100

  one             0     0
  zero            0     0
  pre_data_bits   8
  pre_data       0x0
  gap          452913
  toggle_bit_mask 0x0

      begin codes
          KEY_1                    0x01000200000001 0x00000000000000
          KEY_2                    0x01000300000001 0x00000000000000
          KEY_3                    0x01000400000001 0x00000000000000
          KEY_4                    0x01000500000001 0x00000000000000
          KEY_5                    0x01000600000001 0x00000000000000
          KEY_6                    0x01000700000001 0x00000000000000
          KEY_7                    0x01000800000001 0x00000000000000
          KEY_8                    0x01000900000001 0x00000000000000
          KEY_9                    0x01000A00000001 0x00000000000000
          KEY_0                    0x01000B00000001 0x00000000000000
          KEY_CHANNELUP            0x01019200000001 0x00000000000000
          KEY_CHANNELDOWN          0x01019300000001 0x00000000000000
          KEY_ZOOM                 0x01017400000001 0x00000000000000
          KEY_MUTE                 0x01007100000001 0x00000000000000
          KEY_VOLUMEDOWN           0x01007200000001 0x00000000000000
          KEY_VOLUMEUP             0x01007300000001 0x00000000000000
          KEY_GOTO                 0x01016200000001 0x00000000000000
          KEY_POWER                0x01007400000001 0x00000000000000
      end codes

end remote

Given that keys, once pressed, remain to be stuck, using both lirc's 
dev/input and without any dæmon trying to catch keypresses, I have not 
reached a functional configuration.

Regards
	Stefan Lippers-Hollmann
