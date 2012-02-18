Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:39173 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab2BRQeE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Feb 2012 11:34:04 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: PnP support for the new ISA radio framework?
Date: Sat, 18 Feb 2012 17:33:32 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202181733.34599.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
there are some ISA radio cards with PnP support (e.g. SF16-FMI) but the new 
ISA radio framework has no PnP support.

I got AOpen FX-3D/Pro Radio card which is AD1816 with Gemtek radio - and with 
PnP. But radio-gemtek fails to load because the radio I/O port is not enabled 
(and the driver does not support PnP).

Tried to add PnP support to radio-isa but failed. Splitted non-isa_driver 
related parts from radio_isa_probe() to a separate function and tried to 
create radio_isa_pnp_probe() only to realize that I'm not able to access 
struct radio_isa_driver.

radio_isa_probe() relies on the fact that "driver" (struct isa_driver) is the 
first element of struct radio_isa_driver, so these two structs have the same 
pointer:
HW radio driver registers the driver by calling:
  isa_register_driver(&gemtek_driver.driver, GEMTEK_MAX);
radio_isa_probe() in radio-isa.c does:
  struct radio_isa_driver *drv = pdev->platform_data;

So adding struct pnp_driver to struct radio_isa_driver does not seem to be 
possible.

-- 
Ondrej Zary
