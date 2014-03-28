Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37607 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbaC1A4c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Mar 2014 20:56:32 -0400
Date: Fri, 28 Mar 2014 01:56:28 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	James Hogan <james.hogan@imgtec.com>
Subject: NECX scancode consistency
Message-ID: <20140328005628.GA23915@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FYI, I've gone through all the drivers in the media tree that generate
NECX codes to make sure they are consistent. There are two question
marks (that probably just need a small cleanup) and one driver that
reverses the order of the address bytes compared to the rest.


file:	./media/rc/ir-nec-decoder.c
======================================================================
order:	aa„„cc
keymap: RC_MAP_NEC_TERRATEC_CINERGY_XS (0x04eb)
	(used in ./pci/cx23885/cx23885-input.c)
code:	address     = bitrev8((data->bits >> 24) & 0xff);
	not_address = bitrev8((data->bits >> 16) & 0xff);
	command     = bitrev8((data->bits >>  8) & 0xff);
	...
	scancode = address     << 16 |
		   not_address <<  8 |
		   command;


file:	./media/usb/dvb-usb/dib0700_core.c 
======================================================================
note:	clarification requested via mail
	http://www.spinics.net/lists/linux-media/msg75004.html
order:	aa„„cc (?)
keymap: RC_MAP_DIB0700_NEC_TABLE (0x866b)
code:	scancode = RC_SCANCODE_NECX(be16_to_cpu(poll_reply->system16),
				    poll_reply->data);
	which seems to actually mean:
	keycode = poll_reply->system     << 16 |
                  poll_reply->not_system << 8  |
                  poll_reply->data;


file:	./media/usb/dvb-usb-v2/az6007.c
======================================================================
order:	aa„„cc
keymap: RC_MAP_NEC_TERRATEC_CINERGY_XS (0x04eb)
code:
	code = RC_SCANCODE_NECX(st->data[1] << 8 | st->data[2],
				st->data[3]);


file:	./media/usb/dvb-usb-v2/af9035.c
======================================================================
order:	aa„„cc
keymap: RC_MAP_IT913X_V1 (0x61d6 + 0x807f)
	RC_MAP_IT913X_V2 (0x807f + 0x866b)
code:	key = RC_SCANCODE_NECX(buf[0] << 8 | buf[1], buf[2]);


file:	./media/usb/dvb-usb-v2/rtl28xxu.c
======================================================================
order:	aa„„cc
keymap: RC_MAP_TERRATEC_SLIM (0x02bd)
code:	rc_code = RC_SCANCODE_NECX(buf[0] << 8 | buf[1], 
				   buf[2]);
                      
file: ./media/usb/dvb-usb-v2/af9015.c
======================================================================
order:	aa„„cc
keymap:	RC_MAP_MSI_DIGIVOX_III (0x61d6)
	RC_MAP_TERRATEC_SLIM (0x02bd)
	RC_MAP_TOTAL_MEDIA_IN_HAND (0x02bd)
code:	state->rc_keycode = RC_SCANCODE_NECX(buf[12] << 8 |
					     buf[13],
					     buf[14]);


file: ./media/usb/dvb-usb-v2/lmedm04.c 
======================================================================
note:	clarification requested via mail
order:	almost aa„„cc, except if aa = 0x00, in which case it's NEC16?
keymap:	RC_MAP_LME2510 (0x10ed)
code:	key = RC_SCANCODE_NECX((ibuf[2] ^ 0xff) << 8 |
			       (ibuf[3] > 0) ? (ibuf[3] ^ 0xff) : 0,
			       ibuf[5]);
	
	If firmware sends inverted bytes...then...

	ibuf[2] = ~addr		= not_addr;
	ibuf[3] = ~not_addr	= addr;
	ibuf[4] = ~cmd		= not_cmd;
	ibuf[5] = ~not_cmd	= cmd;

	roughly (not completely true due to the ibuf[3] > 0 ? check)...
		key = RC_SCANCODE_NECX(addr << 8 | not_addr, cmd);

	but for addr = 0x00
		key = RC_SCANCODE_NECX(0x00, cmd);

	note that the keytable includes 1-byte scancodes, which would be
	explained by the addr = 0x00 scenario...


file: ./media/usb/em28xx/em28xx-input.c
======================================================================
order:	aa„„cc
keymap:	RC_MAP_DELOCK_61959 (0x866b)
keymap: RC_MAP_REDDO (0x61d6)
code:	poll_result->scancode = RC_SCANCODE_NECX(msg[1] << 8 |
						 msg[2], msg[3]); 


file:	./media/pci/cx88/cx88-input.c
======================================================================
order:	aa„„cc
keymap:	RC_MAP_PIXELVIEW_MK12 (0x866b)
code:	addr = (data >> 8) & 0xffff;
	cmd  = (data >> 0) & 0x00ff;
	scancode = RC_SCANCODE_NECX(addr, cmd);


file:	./media/pci/saa7134/saa7134-input.c
======================================================================
order:	„„aacc (!!!)
keymap:	RC_MAP_BEHOLD (0x6b86 -> 0x866b)
code:	*scancode = RC_SCANCODE_NECX(((data[10] << 8) | data[11]), data[9]);


The only NECX keymap not listed above is RC_MAP_PIXELVIEW_002T which is
used in ./usb/cx231xx/cx231xx-cards.c, but that driver has a one-byte
scancode filter so only the last byte is actually compared.


-- 
David H‰rdeman
