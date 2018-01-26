Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34458 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753020AbeAZQ0w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 11:26:52 -0500
Date: Fri, 26 Jan 2018 17:24:54 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>
Subject: Re: [PATCH] sh: clk: Relax clk rate match test
Message-ID: <20180126162454.GA11798@w540>
References: <1516879493-24637-1-git-send-email-jacopo+renesas@jmondi.org>
 <CAMuHMdVZpAB+Xu4trs0Eaiygk1WD7DPzKr3ehF-kugB5Fbps2g@mail.gmail.com>
 <20180125141407.GH17416@w540>
 <CAMuHMdWi=s=9oAA5YdPrZA=RjnPfh2YBiPOGQXu1ksj2srxZfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdWi=s=9oAA5YdPrZA=RjnPfh2YBiPOGQXu1ksj2srxZfA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Thu, Jan 25, 2018 at 03:39:32PM +0100, Geert Uytterhoeven wrote:
> Hi Jacopo,
[snip]
> >> > ---
> >> >  drivers/sh/clk/core.c | 9 ++++++---
> >> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >> >
> >> > diff --git a/drivers/sh/clk/core.c b/drivers/sh/clk/core.c
> >> > index 92863e3..d2cb94c 100644
> >> > --- a/drivers/sh/clk/core.c
> >> > +++ b/drivers/sh/clk/core.c
> >> > @@ -198,9 +198,12 @@ int clk_rate_table_find(struct clk *clk,
> >> >  {
> >> >         struct cpufreq_frequency_table *pos;
> >> >
> >> > -       cpufreq_for_each_valid_entry(pos, freq_table)
> >> > -               if (pos->frequency == rate)
> >> > -                       return pos - freq_table;
> >> > +       cpufreq_for_each_valid_entry(pos, freq_table) {
> >> > +               if (pos->frequency > rate)
> >> > +                       continue;
> >>
> >> This assumes all frequency tables are sorted.
> >>
> >> Shouldn't you pick the closest frequency?
> >>
> >> However, that's what clk_rate_table_round() does, which is called from
> >> sh_clk_div_round_rate(), and thus already used as .round_rate:
> >>
> >>     static struct sh_clk_ops sh_clk_div_enable_clk_ops = {
> >>             .recalc         = sh_clk_div_recalc,
> >>             .set_rate       = sh_clk_div_set_rate,
> >>             .round_rate     = sh_clk_div_round_rate,
> >>             .enable         = sh_clk_div_enable,
> >>             .disable        = sh_clk_div_disable,
> >>     };
> >
> > Does this implies clock rates should be set using clk_round_rate() and
> > not clk_set_rate() if I understand this right?
>
> Not necessarily...
>
> Note that both cpg_div6_clock_round_rate() and cpg_div6_clock_set_rate()
> in the CCF implementation for DIV6 clocks use rounding.
>

Yeah but it doesn't seem to me that CCF implementation for DIV6 clocks does
have to walk static tables like the old sh clock driver does. They
perform rounding, but on the clock dividers given a requested rate
and the respective parent clock, if I'm not wrong.

Anyway, in this case a much simpler:
clk_set_rate(video_clk, clk_round_rate(video_clk, 10000000));
does the job for Migo-R.

I will include this in next CEU iterations, since I already have a
small comment from you to fix there ;)

Thanks
   j

> >> (clk_rate_table_find() is called from sh_clk_div_set_rate())
> >>
> >> Or are you supposed to ask for the exact clock rate? Where does the 10 MHz
> >> come from?
> >
> > From board initialization code, in order to provide a valid input
> > clock to OV7720 sensor.
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
