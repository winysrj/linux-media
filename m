Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34964 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbbCJHxG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 03:53:06 -0400
Message-ID: <54FEA2E0.8090405@iki.fi>
Date: Tue, 10 Mar 2015 09:53:04 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dirk Nehring <dnehring@gmx.net>, linux-media@vger.kernel.org
CC: "nibble.max" <nibble.max@gmail.com>
Subject: Re: [PATCH 1/1] Fix DVBsky rc-keymap
References: <1425938573-7107-1-git-send-email-dnehring@gmx.net>
In-Reply-To: <1425938573-7107-1-git-send-email-dnehring@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/10/2015 12:02 AM, Dirk Nehring wrote:
> Signed-off-by: Dirk Nehring <dnehring@gmx.net>
> ---
>   drivers/media/rc/keymaps/rc-dvbsky.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/rc/keymaps/rc-dvbsky.c b/drivers/media/rc/keymaps/rc-dvbsky.c
> index c5115a1..b942b16 100644
> --- a/drivers/media/rc/keymaps/rc-dvbsky.c
> +++ b/drivers/media/rc/keymaps/rc-dvbsky.c
> @@ -33,16 +33,16 @@ static struct rc_map_table rc5_dvbsky[] = {
>   	{ 0x000b, KEY_STOP },
>   	{ 0x000c, KEY_EXIT },
>   	{ 0x000e, KEY_CAMERA }, /*Snap shot*/
> -	{ 0x000f, KEY_SUBTITLE }, /*PIP*/
> -	{ 0x0010, KEY_VOLUMEUP },
> -	{ 0x0011, KEY_VOLUMEDOWN },
> +	{ 0x000f, KEY_TV2 }, /*PIP*/

I don't know what kind of layout there really is, but according to 
comment that button is PIP which should be KEY_NEW. I wonder if you 
mapped those UP/DOWN buttons also badly...

http://linuxtv.org/wiki/index.php/Remote_Controllers



> +	{ 0x0010, KEY_RIGHT },
> +	{ 0x0011, KEY_LEFT },
>   	{ 0x0012, KEY_FAVORITES },
> -	{ 0x0013, KEY_LIST }, /*Info*/
> +	{ 0x0013, KEY_INFO },
>   	{ 0x0016, KEY_PAUSE },
>   	{ 0x0017, KEY_PLAY },
>   	{ 0x001f, KEY_RECORD },
> -	{ 0x0020, KEY_CHANNELDOWN },
> -	{ 0x0021, KEY_CHANNELUP },
> +	{ 0x0020, KEY_UP },
> +	{ 0x0021, KEY_DOWN },
>   	{ 0x0025, KEY_POWER2 },
>   	{ 0x0026, KEY_REWIND },
>   	{ 0x0027, KEY_FASTFORWARD },
>

-- 
http://palosaari.fi/
