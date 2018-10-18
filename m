Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44269 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbeJRViF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 17:38:05 -0400
Received: by mail-ed1-f68.google.com with SMTP id z21-v6so28245603edb.11
        for <linux-media@vger.kernel.org>; Thu, 18 Oct 2018 06:36:59 -0700 (PDT)
Date: Thu, 18 Oct 2018 15:36:49 +0200
From: Benjamin Valentin <benpicco@googlemail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: XBox DVD Remote uses 12 bits scancodes
Message-ID: <20181018153649.2d86c9b5@rechenknecht2k11>
In-Reply-To: <20181018112717.8361-2-sean@mess.org>
References: <20181018112717.8361-1-sean@mess.org>
        <20181018112717.8361-2-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested-by: Benjamin Valentin <benpicco@googlemail.com>

On Thu, 18 Oct 2018 12:27:17 +0100
Sean Young <sean@mess.org> wrote:

> The xbox dvd remote sends 24 bits, the first 12 bits are repeated
> and inverted so only 12 bits are used. The upper 4 bits can be read
> at offset 3. Ensure we pass this to rc-core and update the keymap
> accordingly.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/keymaps/rc-xbox-dvd.c | 58
> +++++++++++++------------- drivers/media/rc/xbox_remote.c         |
> 7 ++-- 2 files changed, 33 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/media/rc/keymaps/rc-xbox-dvd.c
> b/drivers/media/rc/keymaps/rc-xbox-dvd.c index
> 61da6706715c..af387244636b 100644 ---
> a/drivers/media/rc/keymaps/rc-xbox-dvd.c +++
> b/drivers/media/rc/keymaps/rc-xbox-dvd.c @@ -7,35 +7,35 @@
>  
>  /* based on lircd.conf.xbox */
>  static struct rc_map_table xbox_dvd[] = {
> -	{0x0b, KEY_OK},
> -	{0xa6, KEY_UP},
> -	{0xa7, KEY_DOWN},
> -	{0xa8, KEY_RIGHT},
> -	{0xa9, KEY_LEFT},
> -	{0xc3, KEY_INFO},
> -
> -	{0xc6, KEY_9},
> -	{0xc7, KEY_8},
> -	{0xc8, KEY_7},
> -	{0xc9, KEY_6},
> -	{0xca, KEY_5},
> -	{0xcb, KEY_4},
> -	{0xcc, KEY_3},
> -	{0xcd, KEY_2},
> -	{0xce, KEY_1},
> -	{0xcf, KEY_0},
> -
> -	{0xd5, KEY_ANGLE},
> -	{0xd8, KEY_BACK},
> -	{0xdd, KEY_PREVIOUSSONG},
> -	{0xdf, KEY_NEXTSONG},
> -	{0xe0, KEY_STOP},
> -	{0xe2, KEY_REWIND},
> -	{0xe3, KEY_FASTFORWARD},
> -	{0xe5, KEY_TITLE},
> -	{0xe6, KEY_PAUSE},
> -	{0xea, KEY_PLAY},
> -	{0xf7, KEY_MENU},
> +	{0xa0b, KEY_OK},
> +	{0xaa6, KEY_UP},
> +	{0xaa7, KEY_DOWN},
> +	{0xaa8, KEY_RIGHT},
> +	{0xaa9, KEY_LEFT},
> +	{0xac3, KEY_INFO},
> +
> +	{0xac6, KEY_9},
> +	{0xac7, KEY_8},
> +	{0xac8, KEY_7},
> +	{0xac9, KEY_6},
> +	{0xaca, KEY_5},
> +	{0xacb, KEY_4},
> +	{0xacc, KEY_3},
> +	{0xacd, KEY_2},
> +	{0xace, KEY_1},
> +	{0xacf, KEY_0},
> +
> +	{0xad5, KEY_ANGLE},
> +	{0xad8, KEY_BACK},
> +	{0xadd, KEY_PREVIOUSSONG},
> +	{0xadf, KEY_NEXTSONG},
> +	{0xae0, KEY_STOP},
> +	{0xae2, KEY_REWIND},
> +	{0xae3, KEY_FASTFORWARD},
> +	{0xae5, KEY_TITLE},
> +	{0xae6, KEY_PAUSE},
> +	{0xaea, KEY_PLAY},
> +	{0xaf7, KEY_MENU},
>  };
>  
>  static struct rc_map_list xbox_dvd_map = {
> diff --git a/drivers/media/rc/xbox_remote.c
> b/drivers/media/rc/xbox_remote.c index 141ef9253018..4d41e31369d2
> 100644 --- a/drivers/media/rc/xbox_remote.c
> +++ b/drivers/media/rc/xbox_remote.c
> @@ -55,7 +55,7 @@ struct xbox_remote {
>  	struct usb_interface *interface;
>  
>  	struct urb *irq_urb;
> -	unsigned char inbuf[DATA_BUFSIZE];
> +	unsigned char inbuf[DATA_BUFSIZE] __aligned(sizeof(u16));
>  
>  	char rc_name[NAME_BUFSIZE];
>  	char rc_phys[NAME_BUFSIZE];
> @@ -95,7 +95,7 @@ static void xbox_remote_input_report(struct urb
> *urb)
>  	 * data[0] = 0x00
>  	 * data[1] = length - always 0x06
>  	 * data[2] = the key code
> -	 * data[3] = high part of key code? - always 0x0a
> +	 * data[3] = high part of key code
>  	 * data[4] = last_press_ms (low)
>  	 * data[5] = last_press_ms (high)
>  	 */
> @@ -107,7 +107,8 @@ static void xbox_remote_input_report(struct urb
> *urb) return;
>  	}
>  
> -	rc_keydown(xbox_remote->rdev, RC_PROTO_UNKNOWN, data[2], 0);
> +	rc_keydown(xbox_remote->rdev, RC_PROTO_UNKNOWN,
> +		   le16_to_cpup((__le16*)(data + 2)), 0);
>  }
>  
>  /*
