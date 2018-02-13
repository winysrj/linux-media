Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34809 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965378AbeBMRe6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 12:34:58 -0500
Date: Tue, 13 Feb 2018 17:34:56 +0000
From: Sean Young <sean@mess.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: linux-media@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 3/5] =?iso-8859-1?Q?auxdisplay?=
 =?iso-8859-1?Q?=3A_charlcd=3A_add_escape_sequence_for_brightness_on_NEC_?=
 =?iso-8859-1?Q?=B5PD16314?=
Message-ID: <20180213173455.u5taldxobrjpd67h@gofer.mess.org>
References: <cover.1516008708.git.sean@mess.org>
 <259fa00659be126f371ecfa4d75a7830107c3eea.1516008708.git.sean@mess.org>
 <CANiq72krrK7S36atHbJNVirJXvtv8-C3OqiKGx7c=L+FzWeenw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72krrK7S36atHbJNVirJXvtv8-C3OqiKGx7c=L+FzWeenw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 12, 2018 at 12:56:58PM +0100, Miguel Ojeda wrote:
> On Mon, Jan 15, 2018 at 10:58 AM, Sean Young <sean@mess.org> wrote:
> > The NEC µPD16314 can alter the the brightness of the LCD. Make it possible
> > to set this via escape sequence Y0 - Y3. B and R were already taken, so
> > I picked Y for luminance.
> >
> > Signed-off-by: Sean Young <sean@mess.org>
> 
> CC'ing Willy and Geert.
> 
> > ---
> >  drivers/auxdisplay/charlcd.c | 20 ++++++++++++++++++--
> >  1 file changed, 18 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
> > index a16c72779722..7a671ad959d1 100644
> > --- a/drivers/auxdisplay/charlcd.c
> > +++ b/drivers/auxdisplay/charlcd.c
> > @@ -39,6 +39,8 @@
> >  #define LCD_FLAG_F             0x0020  /* Large font mode */
> >  #define LCD_FLAG_N             0x0040  /* 2-rows mode */
> >  #define LCD_FLAG_L             0x0080  /* Backlight enabled */
> > +#define LCD_BRIGHTNESS_MASK    0x0300  /* Brightness */
> > +#define LCD_BRIGHTNESS_SHIFT   8
> 
> Not sure about the name (since the brightness is also used in
> priv->flags). By the way, should we start using the bitops.h stuff
> (e.g. BIT(9) | BIT(8), GENMASK(9, 8)...) in new code? Not sure how
> widespread they are.

The brightness is not really a flag, maybe it belongs in a separate field;
we could use bit fields in order to waste less space.

BIT() would be nicer and is more idiomatic by current standards.

Note that x, y and flags are currently unsigned long, they could be u8.

> 
> >
> >  /* LCD commands */
> >  #define LCD_CMD_DISPLAY_CLEAR  0x01    /* Clear entire display */
> > @@ -490,6 +492,17 @@ static inline int handle_lcd_special_code(struct charlcd *lcd)
> >                 charlcd_gotoxy(lcd);
> >                 processed = 1;
> >                 break;
> > +       case 'Y':       /* brightness (luma) */
> > +               switch (esc[1]) {
> > +               case '0':       /* 25% */
> > +               case '1':       /* 50% */
> > +               case '2':       /* 75% */
> > +               case '3':       /* 100% */
> > +                       priv->flags = (priv->flags & ~(LCD_BRIGHTNESS_MASK)) |
> > +                               (('3' - esc[1]) << LCD_BRIGHTNESS_SHIFT);
> > +                       processed =  1;
> > +                       break;
> > +               }
> >         }
> >
> >         /* TODO: This indent party here got ugly, clean it! */
> > @@ -507,12 +520,15 @@ static inline int handle_lcd_special_code(struct charlcd *lcd)
> >                         ((priv->flags & LCD_FLAG_C) ? LCD_CMD_CURSOR_ON : 0) |
> >                         ((priv->flags & LCD_FLAG_B) ? LCD_CMD_BLINK_ON : 0));
> >         /* check whether one of F,N flags was changed */
> 
> Should we add "or brightness" to the comment?

Indeed we should.

> 
> > -       else if ((oldflags ^ priv->flags) & (LCD_FLAG_F | LCD_FLAG_N))
> > +       else if ((oldflags ^ priv->flags) & (LCD_FLAG_F | LCD_FLAG_N |
> > +                                            LCD_BRIGHTNESS_MASK))
> >                 lcd->ops->write_cmd(lcd,
> >                         LCD_CMD_FUNCTION_SET |
> >                         ((lcd->ifwidth == 8) ? LCD_CMD_DATA_LEN_8BITS : 0) |
> >                         ((priv->flags & LCD_FLAG_F) ? LCD_CMD_FONT_5X10_DOTS : 0) |
> > -                       ((priv->flags & LCD_FLAG_N) ? LCD_CMD_TWO_LINES : 0));
> > +                       ((priv->flags & LCD_FLAG_N) ? LCD_CMD_TWO_LINES : 0) |
> > +                       ((priv->flags & LCD_BRIGHTNESS_MASK) >>
> > +                                                       LCD_BRIGHTNESS_SHIFT));
> >         /* check whether L flag was changed */
> >         else if ((oldflags ^ priv->flags) & LCD_FLAG_L)
> >                 charlcd_backlight(lcd, !!(priv->flags & LCD_FLAG_L));
> > --
> > 2.14.3
> >

I've discovered an issue in my sasem driver, I'll send out a new version
of these patch series once that is resolved.

Thanks,

Sean
