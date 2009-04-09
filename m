Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd18532.kasserver.com ([85.13.139.13]:47227 "EHLO
	dd18532.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937066AbZDIWOU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 18:14:20 -0400
Date: Fri, 10 Apr 2009 00:14:15 +0200
From: Carsten Meier <cm@trexity.de>
To: linux-media@vger.kernel.org
Cc: liplianin@me.by
Subject: Keymap for TeVii S650's remote control
Message-ID: <20090410001415.079a2df4@tuvok>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've created a keymap for the remote control that ships with the TeVii
S650. It is just a hack, I simply replaced the previous keymap in
linux/drivers/media/dvb/dvb-usb/dw2102.c (line 527)

Here's the code:

static struct dvb_usb_rc_key dw210x_rc_keys[] = {
	{ 0xf8, 0x00, KEY_UP },
	{ 0xf8, 0x01, KEY_DOWN },
	{ 0xf8, 0x02, KEY_RIGHT },
	{ 0xf8, 0x03, KEY_LEFT },
	{ 0xf8, 0x04, KEY_RECORD },
/*	{ 0xf8, 0x05, KEY_ },			live-mode */
	{ 0xf8, 0x06, KEY_CHANNELDOWN },
/*	{ 0xf8, 0x07, KEY_ },			play-mode */
	{ 0xf8, 0x08, KEY_CHANNELUP },
	{ 0xf8, 0x09, KEY_VOLUMEUP },
	{ 0xf8,	0x0a, KEY_POWER2 },
/*	{ 0xf8, 0x0b, KEY_ },			timer */
	{ 0xf8,	0x0c, KEY_MUTE },
	{ 0xf8, 0x0e, KEY_OPEN },
	{ 0xf8, 0x0f, KEY_VOLUMEDOWN },
	{ 0xf8, 0x10, KEY_KP0 },
	{ 0xf8,	0x11, KEY_KP1 },
	{ 0xf8,	0x12, KEY_KP2 },
	{ 0xf8,	0x13, KEY_KP3 },
	{ 0xf8,	0x14, KEY_KP4 },
	{ 0xf8,	0x15, KEY_KP5 },
	{ 0xf8,	0x16, KEY_KP6 },
	{ 0xf8,	0x17, KEY_KP7 },
	{ 0xf8,	0x18, KEY_KP8 },
	{ 0xf8,	0x19, KEY_KP9 },
	{ 0xf8, 0x1a, KEY_LAST },		/* recall / event info */
	{ 0xf8, 0x1b, KEY_FAVORITES },		/* fav /cur/next */
	{ 0xf8, 0x1c, KEY_MENU },
	{ 0xf8, 0x1d, KEY_BACK },
	{ 0xf8, 0x1e, KEY_REWIND },
	{ 0xf8, 0x1f, KEY_OK },
	{ 0xf8, 0x40, KEY_PLAYPAUSE },
	{ 0xf8, 0x41, KEY_AB },
	{ 0xf8, 0x43, KEY_AUDIO },
	{ 0xf8, 0x44, KEY_EPG },
	{ 0xf8, 0x45, KEY_SUBTITLE },
	{ 0xf8, 0x46, KEY_F1 },			/* F1 / satellite */
	{ 0xf8, 0x48, KEY_F2 },			/* F2 / provider */
	{ 0xf8, 0x4a, KEY_LIST },
	{ 0xf8, 0x4c, KEY_INFO },
	{ 0xf8, 0x4d, KEY_FASTFORWARD },
	{ 0xf8, 0x52, KEY_F5 },			/* F5 / all */
/*	{ 0xf8, 0x56, KEY_ },			mon */
/*	{ 0xf8, 0x58, KEY_ },			FS */
	{ 0xf8, 0x5a, KEY_F6 },
	{ 0xf8, 0x5c, KEY_F4 },			/* F4 / favorites */
	{ 0xf8, 0x5e, KEY_F3 }			/* F3 / transp */
};

For the commented-out keys, I haven't found a matching kernel-constant.

It would be nice if somebody could integrate this into the v4l-dvb-tree.
(Don't ask me to do it, I have no clue how to do it without breaking
the other devices that depend on the old keymap)

Cheers,
Carsten
