Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.marcant.net ([217.14.160.186]:57172 "EHLO
	mail2.marcant.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbbCJIQj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 04:16:39 -0400
Date: Tue, 10 Mar 2015 09:16:33 +0100
From: Dirk Nehring <dnehring@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, "nibble.max" <nibble.max@gmail.com>
Subject: Re: [PATCH 1/1] Fix DVBsky rc-keymap
Message-ID: <20150310081633.GB6349@marcant.net>
References: <1425938573-7107-1-git-send-email-dnehring@gmx.net>
 <54FEA2E0.8090405@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54FEA2E0.8090405@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 10, 2015 at 09:53:04AM +0200, Antti Palosaari wrote:
> 
> 
> On 03/10/2015 12:02 AM, Dirk Nehring wrote:
> >Signed-off-by: Dirk Nehring <dnehring@gmx.net>
> >---
> >  drivers/media/rc/keymaps/rc-dvbsky.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> >diff --git a/drivers/media/rc/keymaps/rc-dvbsky.c b/drivers/media/rc/keymaps/rc-dvbsky.c
> >index c5115a1..b942b16 100644
> >--- a/drivers/media/rc/keymaps/rc-dvbsky.c
> >+++ b/drivers/media/rc/keymaps/rc-dvbsky.c
> >@@ -33,16 +33,16 @@ static struct rc_map_table rc5_dvbsky[] = {
> >  	{ 0x000b, KEY_STOP },
> >  	{ 0x000c, KEY_EXIT },
> >  	{ 0x000e, KEY_CAMERA }, /*Snap shot*/
> >-	{ 0x000f, KEY_SUBTITLE }, /*PIP*/
> >-	{ 0x0010, KEY_VOLUMEUP },
> >-	{ 0x0011, KEY_VOLUMEDOWN },
> >+	{ 0x000f, KEY_TV2 }, /*PIP*/
> 
> I don't know what kind of layout there really is, but according to
> comment that button is PIP which should be KEY_NEW. I wonder if you
> mapped those UP/DOWN buttons also badly...
> 
> http://linuxtv.org/wiki/index.php/Remote_Controllers

OK, KEY_NEW should be better (I just orientated on other rc
keymaps). The UP/DOWN buttons are correct, the DVBsky rc has no channel
up/down buttons.

Best regards,

Dirk


> 
> 
> 
> >+	{ 0x0010, KEY_RIGHT },
> >+	{ 0x0011, KEY_LEFT },
> >  	{ 0x0012, KEY_FAVORITES },
> >-	{ 0x0013, KEY_LIST }, /*Info*/
> >+	{ 0x0013, KEY_INFO },
> >  	{ 0x0016, KEY_PAUSE },
> >  	{ 0x0017, KEY_PLAY },
> >  	{ 0x001f, KEY_RECORD },
> >-	{ 0x0020, KEY_CHANNELDOWN },
> >-	{ 0x0021, KEY_CHANNELUP },
> >+	{ 0x0020, KEY_UP },
> >+	{ 0x0021, KEY_DOWN },
> >  	{ 0x0025, KEY_POWER2 },
> >  	{ 0x0026, KEY_REWIND },
> >  	{ 0x0027, KEY_FASTFORWARD },
> >
> 
> -- 
