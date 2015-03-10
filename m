Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:35001 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbCJBsd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 21:48:33 -0400
Received: by wesw55 with SMTP id w55so16597939wes.2
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2015 18:48:32 -0700 (PDT)
Date: Tue, 10 Mar 2015 09:48:33 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Dirk Nehring" <dnehring@gmx.net>
Cc: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1] Fix DVBsky rc-keymap
Message-ID: <201503100948297650804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Mapping VOLUME and CHANNEL keys to the general ones will break some tv softwares remote control functions.

Best Regards,
Max

On 2015-03-10 06:05:02, Dirk Nehring <dnehring@gmx.net> wrote:
>Signed-off-by: Dirk Nehring <dnehring@gmx.net>
>---
> drivers/media/rc/keymaps/rc-dvbsky.c | 12 ++++++------
> 1 file changed, 6 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/media/rc/keymaps/rc-dvbsky.c b/drivers/media/rc/keymaps/rc-dvbsky.c
>index c5115a1..b942b16 100644
>--- a/drivers/media/rc/keymaps/rc-dvbsky.c
>+++ b/drivers/media/rc/keymaps/rc-dvbsky.c
>@@ -33,16 +33,16 @@ static struct rc_map_table rc5_dvbsky[] = {
> 	{ 0x000b, KEY_STOP },
> 	{ 0x000c, KEY_EXIT },
> 	{ 0x000e, KEY_CAMERA }, /*Snap shot*/
>-	{ 0x000f, KEY_SUBTITLE }, /*PIP*/
>-	{ 0x0010, KEY_VOLUMEUP },
>-	{ 0x0011, KEY_VOLUMEDOWN },
>+	{ 0x000f, KEY_TV2 }, /*PIP*/
>+	{ 0x0010, KEY_RIGHT },
>+	{ 0x0011, KEY_LEFT },
> 	{ 0x0012, KEY_FAVORITES },
>-	{ 0x0013, KEY_LIST }, /*Info*/
>+	{ 0x0013, KEY_INFO },
> 	{ 0x0016, KEY_PAUSE },
> 	{ 0x0017, KEY_PLAY },
> 	{ 0x001f, KEY_RECORD },
>-	{ 0x0020, KEY_CHANNELDOWN },
>-	{ 0x0021, KEY_CHANNELUP },
>+	{ 0x0020, KEY_UP },
>+	{ 0x0021, KEY_DOWN },
> 	{ 0x0025, KEY_POWER2 },
> 	{ 0x0026, KEY_REWIND },
> 	{ 0x0027, KEY_FASTFORWARD },
>-- 
>2.1.0
>

