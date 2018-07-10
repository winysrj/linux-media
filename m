Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:57680 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751082AbeGJISK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:18:10 -0400
Subject: Re: [PATCH v5 02/22] fixup! v4l2-ctrls: add
 v4l2_ctrl_request_hdl_find/put/ctrl_find functions
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, marco.franchi@nxp.com,
        icenowy@aosc.io, keiichiw@chromium.org,
        Jonathan Corbet <corbet@lwn.net>, smitha.t@samsung.com,
        tom.saeger@oracle.com, Andrzej Hajda <a.hajda@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        jacob-chen@iotwrt.com, Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>, acourbot@chromium.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        posciak@chromium.org,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>, samitolvanen@google.com,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        hugues.fruchet@st.com, ayaka@soulik.info
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
 <20180710080114.31469-3-paul.kocialkowski@bootlin.com>
 <CAMuHMdVgJuK5G0+szV0BAWDBybxWV0iDWE5kZKuTdgNiGjpnEg@mail.gmail.com>
 <5adf8a6aa70fd6f7f4326ccb068b66d6221d8d8b.camel@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <eb5fb671-4589-e0cf-5385-84a5cc912905@xs4all.nl>
Date: Tue, 10 Jul 2018 10:17:55 +0200
MIME-Version: 1.0
In-Reply-To: <5adf8a6aa70fd6f7f4326ccb068b66d6221d8d8b.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/18 10:13, Paul Kocialkowski wrote:
> Hi,
> 
> On Tue, 2018-07-10 at 10:07 +0200, Geert Uytterhoeven wrote:
>> On Tue, Jul 10, 2018 at 10:02 AM Paul Kocialkowski
>> <paul.kocialkowski@bootlin.com> wrote:
>>> [PATCH v5 02/22] fixup! v4l2-ctrls: add v4l2_ctrl_request_hdl_find/put/ctrl_find functions
>>
>> git rebase -i ;-)
> 
> Although I should have mentionned it (and did not), this is totally
> intentional! The first patch (from Hans Verkuil) requires said fixup to
> work properly. I didn't want to squash that change into the commit to
> make the diff obvious.

Just squash the two for the next version you post.

> Ultimately, this framework patch is not really part of the series but is
> one of its underlying requirements, that should be merged separately (as
> part of the requests API series).

There is a good chance that this patch will go in via your series anyway
since it is not needed by vivid or vim2m.

Regards,

	Hans

> 
> I hope this clears up some of the confusion about this patch :)
> 
> Cheers!
> 
>> Gr{oetje,eeting}s,
>>
>>                         Geert
>>
