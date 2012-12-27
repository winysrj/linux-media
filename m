Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:58479 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab2L0MX3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 07:23:29 -0500
Date: Thu, 27 Dec 2012 13:23:23 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCHv2 0/9] dvb-usb/m920x: support VP-7049 DVB-T USB Stick
 and other fixes
Message-Id: <20121227132323.27d3364fa5e7b1f7cff0db0c@studenti.unina.it>
In-Reply-To: <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
	<1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 10 Dec 2012 22:37:08 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> Hi,
>

Ping.

> Here is a second iteration of the patchset to add support for the
> Twinhan VP7049 DVB-T USB Stick, v1 is at:
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/56714
> 
> Patches from 1 to 7 are small fixes or refactorings to make the addition
> of the new device easier.
> 
> Patches 8 and 9 are specific to the device.
> 
> Changes since v1:
>   - Patches 1-7: more refactorings
> 
>   - Patch 9: don't add a .pre_init callback to dvb-usb, Antti convinced
>     me that the initialization is better done just before the frontend
>     attach is called.
> 
>   - Patch 9: use the RC core infrastructure, the keymap I needed was
>     already here: I could reuse the rc-twinhan1027 driver without
>     touching anything in it.
> 
> Again I deliberately ignored some checkpatch.pl warnings and errors
> because I preferred to stick with the code style in use in the
> dvb-usb/m920x files, let me know if you want me to do otherwise.
> 
> Thanks,
>    Antonio
> 
> Antonio Ospite (9):
>   [media] dvb-usb: fix indentation of a for loop
>   [media] m920x: fix a typo in a comment
>   [media] m920x: factor out a m920x_write_seq() function
>   [media] m920x: factor out a m920x_parse_rc_state() function
>   [media] m920x: avoid repeating RC state parsing at each keycode
>   [media] m920x: introduce m920x_rc_core_query()
>   [media] m920x: send the RC init sequence also when rc.core is used
>   [media] get_dvb_firmware: add entry for the vp7049 firmware
>   [media] m920x: add support for the VP-7049 Twinhan DVB-T USB Stick
> 
>  Documentation/dvb/get_dvb_firmware       |   15 +-
>  drivers/media/dvb-core/dvb-usb-ids.h     |    1 +
>  drivers/media/usb/dvb-usb/dvb-usb-init.c |   60 +++----
>  drivers/media/usb/dvb-usb/m920x.c        |  269 ++++++++++++++++++++++++------
>  4 files changed, 266 insertions(+), 79 deletions(-)
> 
> -- 
> Antonio Ospite
> http://ao2.it
> 
> A: Because it messes up the order in which people normally read text.
>    See http://en.wikipedia.org/wiki/Posting_style
> Q: Why is top-posting such a bad thing?
> 


-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
