Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:44926 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932860AbeBLL47 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 06:56:59 -0500
Received: by mail-qt0-f196.google.com with SMTP id f18so18387728qth.11
        for <linux-media@vger.kernel.org>; Mon, 12 Feb 2018 03:56:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <259fa00659be126f371ecfa4d75a7830107c3eea.1516008708.git.sean@mess.org>
References: <cover.1516008708.git.sean@mess.org> <259fa00659be126f371ecfa4d75a7830107c3eea.1516008708.git.sean@mess.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 12 Feb 2018 12:56:58 +0100
Message-ID: <CANiq72krrK7S36atHbJNVirJXvtv8-C3OqiKGx7c=L+FzWeenw@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_3=2F5=5D_auxdisplay=3A_charlcd=3A_add_escape_sequ?=
        =?UTF-8?Q?ence_for_brightness_on_NEC_=C2=B5PD16314?=
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 15, 2018 at 10:58 AM, Sean Young <sean@mess.org> wrote:
> The NEC =C2=B5PD16314 can alter the the brightness of the LCD. Make it po=
ssible
> to set this via escape sequence Y0 - Y3. B and R were already taken, so
> I picked Y for luminance.
>
> Signed-off-by: Sean Young <sean@mess.org>

CC'ing Willy and Geert.

> ---
>  drivers/auxdisplay/charlcd.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
> index a16c72779722..7a671ad959d1 100644
> --- a/drivers/auxdisplay/charlcd.c
> +++ b/drivers/auxdisplay/charlcd.c
> @@ -39,6 +39,8 @@
>  #define LCD_FLAG_F             0x0020  /* Large font mode */
>  #define LCD_FLAG_N             0x0040  /* 2-rows mode */
>  #define LCD_FLAG_L             0x0080  /* Backlight enabled */
> +#define LCD_BRIGHTNESS_MASK    0x0300  /* Brightness */
> +#define LCD_BRIGHTNESS_SHIFT   8

Not sure about the name (since the brightness is also used in
priv->flags). By the way, should we start using the bitops.h stuff
(e.g. BIT(9) | BIT(8), GENMASK(9, 8)...) in new code? Not sure how
widespread they are.

>
>  /* LCD commands */
>  #define LCD_CMD_DISPLAY_CLEAR  0x01    /* Clear entire display */
> @@ -490,6 +492,17 @@ static inline int handle_lcd_special_code(struct cha=
rlcd *lcd)
>                 charlcd_gotoxy(lcd);
>                 processed =3D 1;
>                 break;
> +       case 'Y':       /* brightness (luma) */
> +               switch (esc[1]) {
> +               case '0':       /* 25% */
> +               case '1':       /* 50% */
> +               case '2':       /* 75% */
> +               case '3':       /* 100% */
> +                       priv->flags =3D (priv->flags & ~(LCD_BRIGHTNESS_M=
ASK)) |
> +                               (('3' - esc[1]) << LCD_BRIGHTNESS_SHIFT);
> +                       processed =3D  1;
> +                       break;
> +               }
>         }
>
>         /* TODO: This indent party here got ugly, clean it! */
> @@ -507,12 +520,15 @@ static inline int handle_lcd_special_code(struct ch=
arlcd *lcd)
>                         ((priv->flags & LCD_FLAG_C) ? LCD_CMD_CURSOR_ON :=
 0) |
>                         ((priv->flags & LCD_FLAG_B) ? LCD_CMD_BLINK_ON : =
0));
>         /* check whether one of F,N flags was changed */

Should we add "or brightness" to the comment?

> -       else if ((oldflags ^ priv->flags) & (LCD_FLAG_F | LCD_FLAG_N))
> +       else if ((oldflags ^ priv->flags) & (LCD_FLAG_F | LCD_FLAG_N |
> +                                            LCD_BRIGHTNESS_MASK))
>                 lcd->ops->write_cmd(lcd,
>                         LCD_CMD_FUNCTION_SET |
>                         ((lcd->ifwidth =3D=3D 8) ? LCD_CMD_DATA_LEN_8BITS=
 : 0) |
>                         ((priv->flags & LCD_FLAG_F) ? LCD_CMD_FONT_5X10_D=
OTS : 0) |
> -                       ((priv->flags & LCD_FLAG_N) ? LCD_CMD_TWO_LINES :=
 0));
> +                       ((priv->flags & LCD_FLAG_N) ? LCD_CMD_TWO_LINES :=
 0) |
> +                       ((priv->flags & LCD_BRIGHTNESS_MASK) >>
> +                                                       LCD_BRIGHTNESS_SH=
IFT));
>         /* check whether L flag was changed */
>         else if ((oldflags ^ priv->flags) & LCD_FLAG_L)
>                 charlcd_backlight(lcd, !!(priv->flags & LCD_FLAG_L));
> --
> 2.14.3
>
