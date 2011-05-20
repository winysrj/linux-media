Return-path: <mchehab@pedra>
Received: from blu0-omc2-s34.blu0.hotmail.com ([65.55.111.109]:44646 "EHLO
	blu0-omc2-s34.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932947Ab1ETNYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 09:24:39 -0400
Message-ID: <BLU0-SMTP10D5BA32150BC672A6B5FED8710@phx.gbl>
From: Lou <tuxoholic@hotmail.de>
To: linux-media@vger.kernel.org
Subject: AW: Remote control not working for Terratec Cinergy C (2.6.37 Mantis driver)
Date: Fri, 20 May 2011 15:24:36 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Chris

This applies fine against 2.6.39 stable, but the Twinhan VP-1041 uses the 
keymap of Twinhan DTV CAB CI, so it's not a perfect fit for the Terratec 
Cinergy S2 HD keymap. I assume from earlier postings in vdr-portal [1] Cinergy 
S2 HD and Skystar 2 HD do share the same keymappings.

Here's a paste of the VP-1041 keymap, as it used to work with s2-liplianin:


/* Twinhan VP-1041 */
static struct ir_scancode  ir_codes_mantis_vp1041[] = {
	{ 0x29, KEY_POWER},
	{ 0x28, KEY_FAVORITES},
	{ 0x30, KEY_TEXT},
	{ 0x17, KEY_INFO},		/* Preview */
	{ 0x23, KEY_EPG},
	{ 0x3b, KEY_F22},		/* Record List */

	{ 0x3c, KEY_1},
	{ 0x3e, KEY_2},
	{ 0x39, KEY_3},
	{ 0x36, KEY_4},
	{ 0x22, KEY_5},
	{ 0x20, KEY_6},
	{ 0x32, KEY_7},
	{ 0x26, KEY_8},
	{ 0x24, KEY_9},
	{ 0x2a, KEY_0},

	{ 0x33, KEY_CANCEL},
	{ 0x2c, KEY_BACK},
	{ 0x15, KEY_CLEAR},
	{ 0x3f, KEY_TAB},
	{ 0x10, KEY_ENTER},
	{ 0x14, KEY_UP},
	{ 0x0d, KEY_RIGHT},
	{ 0x0e, KEY_DOWN},
	{ 0x11, KEY_LEFT},

	{ 0x21, KEY_VOLUMEUP},
	{ 0x35, KEY_VOLUMEDOWN},
	{ 0x3d, KEY_CHANNELDOWN},
	{ 0x3a, KEY_CHANNELUP},
	{ 0x2e, KEY_RECORD},
	{ 0x2b, KEY_PLAY},
	{ 0x13, KEY_PAUSE},
	{ 0x25, KEY_STOP},

	{ 0x1f, KEY_REWIND},
	{ 0x2d, KEY_FASTFORWARD},
	{ 0x1e, KEY_PREVIOUS},		/* Replay |< */
	{ 0x1d, KEY_NEXT},		/* Skip   >| */

	{ 0x0b, KEY_CAMERA},		/* Capture */
	{ 0x0f, KEY_LANGUAGE},		/* SAP */
	{ 0x18, KEY_MODE},		/* PIP */
	{ 0x12, KEY_ZOOM},		/* Full screen */
	{ 0x1c, KEY_SUBTITLE},
	{ 0x2f, KEY_MUTE},
	{ 0x16, KEY_F20},		/* L/R */
	{ 0x38, KEY_F21},		/* Hibernate */

	{ 0x37, KEY_SWITCHVIDEOMODE},	/* A/V */
	{ 0x31, KEY_AGAIN},		/* Recall */
	{ 0x1a, KEY_KPPLUS},		/* Zoom+ */
	{ 0x19, KEY_KPMINUS},		/* Zoom- */
	{ 0x27, KEY_RED},
	{ 0x0C, KEY_GREEN},
	{ 0x01, KEY_YELLOW},
	{ 0x00, KEY_BLUE},
};
struct ir_scancode_table ir_codes_mantis_vp1041_table = {
	.scan = ir_codes_mantis_vp1041,
	.size = ARRAY_SIZE(ir_codes_mantis_vp1041),
};
EXPORT_SYMBOL_GPL(ir_codes_mantis_vp1041_table);


Maybe someone else can confirm this?


Regards

Lou@vdr-portal

[1] http://www.vdr-portal.de/board18-vdr-hardware/board13-
fernbedienungen/95304-falsches-mapping-mit-fb-von-skystar-hd2-unter-linux/


> Hello,
> 
> This patch is a rework of a old patch I've posted some time ago.
> It adds support for Remote-Control in the mantis driver and implements the
> new rc-API.
> The patch enables rc for the cards
> - vp1041
> - vp2033
> - vp2040
> 
> It's only tested with a Terratec Cinergy S2 HD.
> Would be nice to get some Feedback.
> 
> Regards
> Chris

