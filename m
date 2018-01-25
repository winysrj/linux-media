Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34699 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbeAYOje (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 09:39:34 -0500
MIME-Version: 1.0
In-Reply-To: <20180125141407.GH17416@w540>
References: <1516879493-24637-1-git-send-email-jacopo+renesas@jmondi.org>
 <CAMuHMdVZpAB+Xu4trs0Eaiygk1WD7DPzKr3ehF-kugB5Fbps2g@mail.gmail.com> <20180125141407.GH17416@w540>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 25 Jan 2018 15:39:32 +0100
Message-ID: <CAMuHMdWi=s=9oAA5YdPrZA=RjnPfh2YBiPOGQXu1ksj2srxZfA@mail.gmail.com>
Subject: Re: [PATCH] sh: clk: Relax clk rate match test
To: jacopo mondi <jacopo@jmondi.org>
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Thu, Jan 25, 2018 at 3:14 PM, jacopo mondi <jacopo@jmondi.org> wrote:
> On Thu, Jan 25, 2018 at 02:53:41PM +0100, Geert Uytterhoeven wrote:
>> CC linux-clk (yes I know this is about the legacy SH clock framework, but
>> the public API is/should be the same)
>>
>> On Thu, Jan 25, 2018 at 12:24 PM, Jacopo Mondi
>> <jacopo+renesas@jmondi.org> wrote:
>> > When asking for a clk rate to be set, the sh core clock matches only
>> > exact rate values against the calculated frequency table entries. If the
>> > rate does not match exactly the test fails, and the whole frequency
>> > table is walked, resulting in selection of the last entry, corresponding to
>> > the lowest available clock rate.
>>
>> IIUIC, the code does not select the last entry, but returns an error code,
>> which is propagated all the way up?
>>
>> > Ie. when asking for a 10MHz clock rate on div6 clocks (ie. "video_clk" line),
>> > the calculated clock frequency 10088572 Hz gets ignored, and the clock is
>> > actually set to 5201920 Hz, which is the last available entry of the frequencies
>> > table.
>>
>> Perhaps 5201920 is just the default (or old value)?
>>
>> > Relax the clock frequency match test, allowing selection of clock rates
>> > immediately slower than the required one.
>> >
>> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> >
>> > ---
>> > Hello renesas lists,
>> >
>> > I'm now working on handling frame rate for the ov7720 image sensor to have that
>> > driver accepted as part of v4l2. The sensor is installed on on Migo-R board.
>> > In order to properly calculate pixel clock and the framerate I noticed the
>> > clock signal fed to the sensor from the SH7722 chip was always the lowest
>> > available one.
>> >
>> > This patch fixes the issues and allows me to properly select which clock
>> > frequency supply to the sensor, which according to datasheet does not support
>> > input clock frequencies slower than 10MHz (but works anyhow).
>> >
>> > As all patches for SH architecture I wonder where they should be picked up from,
>> > as SH seems not maintained at the moment.
>> >
>> > Thanks
>> >    j
>> >
>> > ---
>> >  drivers/sh/clk/core.c | 9 ++++++---
>> >  1 file changed, 6 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/drivers/sh/clk/core.c b/drivers/sh/clk/core.c
>> > index 92863e3..d2cb94c 100644
>> > --- a/drivers/sh/clk/core.c
>> > +++ b/drivers/sh/clk/core.c
>> > @@ -198,9 +198,12 @@ int clk_rate_table_find(struct clk *clk,
>> >  {
>> >         struct cpufreq_frequency_table *pos;
>> >
>> > -       cpufreq_for_each_valid_entry(pos, freq_table)
>> > -               if (pos->frequency == rate)
>> > -                       return pos - freq_table;
>> > +       cpufreq_for_each_valid_entry(pos, freq_table) {
>> > +               if (pos->frequency > rate)
>> > +                       continue;
>>
>> This assumes all frequency tables are sorted.
>>
>> Shouldn't you pick the closest frequency?
>>
>> However, that's what clk_rate_table_round() does, which is called from
>> sh_clk_div_round_rate(), and thus already used as .round_rate:
>>
>>     static struct sh_clk_ops sh_clk_div_enable_clk_ops = {
>>             .recalc         = sh_clk_div_recalc,
>>             .set_rate       = sh_clk_div_set_rate,
>>             .round_rate     = sh_clk_div_round_rate,
>>             .enable         = sh_clk_div_enable,
>>             .disable        = sh_clk_div_disable,
>>     };
>
> Does this implies clock rates should be set using clk_round_rate() and
> not clk_set_rate() if I understand this right?

Not necessarily...

Note that both cpg_div6_clock_round_rate() and cpg_div6_clock_set_rate()
in the CCF implementation for DIV6 clocks use rounding.

>> (clk_rate_table_find() is called from sh_clk_div_set_rate())
>>
>> Or are you supposed to ask for the exact clock rate? Where does the 10 MHz
>> come from?
>
> From board initialization code, in order to provide a valid input
> clock to OV7720 sensor.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
