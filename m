Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37560 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaC0MHa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Mar 2014 08:07:30 -0400
Date: Thu, 27 Mar 2014 13:07:28 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: pboettcher@kernellabs.com
Cc: linux-media@vger.kernel.org
Subject: dib0700 NEC scancode question
Message-ID: <20140327120728.GA13748@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

a quick question regarding the dib0700 driver:

in ./media/usb/dvb-usb/dib0700_core.c the RC RX packet is defined as:

	struct dib0700_rc_response {
		u8 report_id;
		u8 data_state;
		union {
			u16 system16;
			struct {
				u8 not_system;
				u8 system;
			};
		};
		u8 data;
		u8 not_data;
	};

The NEC protocol transmits in the order:
	system
	not_system
	data
	not_data

Does the dib0700 fw really reorder the bytes, or could the order of
not_system and system in struct dib0700_rc_response have been
accidentally reversed?

Note that the NEC extended keycode is later defined in dib0700_core.c as:

	keycode = be16_to_cpu(poll_reply->system16) << 8 | poll_reply->data;

i.e.

	keycode = poll_reply->not_system << 16 |
		  poll_reply->system     << 8  |
		  poll_reply->data;

Which, if the order *is* reversed, would mean that the scancode that
gets defined is in reality:

	keycode = poll_reply->system     << 16 |
		  poll_reply->not_system << 8  |
		  poll_reply->data;

Which is the same as the order used in drivers/media/rc/ir-nec-decoder.c.

(An order which I'm considering trying to correct, which is why I'm
checking all the places where NEC scancodes are generated).

-- 
David Härdeman
