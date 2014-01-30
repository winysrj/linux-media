Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaA3Cyo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jan 2014 21:54:44 -0500
Date: Wed, 29 Jan 2014 21:54:32 -0500
From: Dave Jones <davej@redhat.com>
To: mkrufky@linuxtv.org
Cc: linux-media@vger.kernel.org
Subject: mlx111sf: Fix unintentional garbage stack read.
Message-ID: <20140130025432.GA20019@redhat.com>
References: <20140129195756.GB30316@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129195756.GB30316@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mxl111sf_read_reg takes an address of a variable to write to as an argument.
drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c:mxl111sf_config_pin_mux_modes passes
several uninitialized stack variables to this routine, expecting them to be
filled in.  In the event that something unexpected happens when reading from
the chip, we end up doing a pr_debug of the value passed in, revealing whatever
garbage happened to be on the stack.

Change the pr_debug to match what happens in the 'success' case, where we assign
buf[1] to *data.

Spotted with Coverity (Bugs 731910 through 731917)

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index 08240e498451..ccd854afd2f8 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -105,7 +105,7 @@ int mxl111sf_read_reg(struct mxl111sf_state *state, u8 addr, u8 *data)
 		ret = -EINVAL;
 	}
 
-	pr_debug("R: (0x%02x, 0x%02x)\n", addr, *data);
+	pr_debug("R: (0x%02x, 0x%02x)\n", addr, buf[1]);
 fail:
 	return ret;
 }
