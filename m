Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34455 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932329AbdHVO6o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 10:58:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+ABipq+YCpSwu_vhjk0rkZQimCD2vG1x5GL91wi6dzKw@mail.gmail.com>
References: <20170822001912.27638-1-niklas.soderlund+renesas@ragnatech.se> <CAL_Jsq+ABipq+YCpSwu_vhjk0rkZQimCD2vG1x5GL91wi6dzKw@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 22 Aug 2017 16:58:43 +0200
Message-ID: <CAMuHMdXU1j=vwJJnhjt96=g5ikCVhuoH7AZysk+WAd5HYJnV4w@mail.gmail.com>
Subject: Re: [PATCH v2] device property: preserve usecount for node passed to of_fwnode_graph_get_port_parent()
To: Rob Herring <robh@kernel.org>
Cc: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On Tue, Aug 22, 2017 at 4:49 PM, Rob Herring <robh@kernel.org> wrote:
> On Mon, Aug 21, 2017 at 7:19 PM, Niklas S=C3=B6derlund
> <niklas.soderlund+renesas@ragnatech.se> wrote:
>> Using CONFIG_OF_DYNAMIC=3Dy uncovered an imbalance in the usecount of th=
e
>> node being passed to of_fwnode_graph_get_port_parent(). Preserve the
>> usecount by using of_get_parent() instead of of_get_next_parent() which
>> don't decrement the usecount of the node passed to it.
>>
>> Fixes: 3b27d00e7b6d7c88 ("device property: Move fwnode graph ops to firm=
ware specific locations")
>> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech=
.se>
>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  drivers/of/property.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Isn't this already fixed with this fix:
>
> commit c0a480d1acf7dc184f9f3e7cf724483b0d28dc2e
> Author: Tony Lindgren <tony@atomide.com>
> Date:   Fri Jul 28 01:23:15 2017 -0700
>
> device property: Fix usecount for of_graph_get_port_parent()

No, this one is for of_fwnode_graph_get_port_parent().

You're letting too many similarly-named new functions through ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
