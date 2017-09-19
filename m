Return-path: <linux-media-owner@vger.kernel.org>
Received: from unicorn.mansr.com ([81.2.72.234]:52190 "EHLO unicorn.mansr.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751773AbdISMVd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:21:33 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Cc: Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Mason <slash.tmp@free.fr>
Subject: Re: [PATCH v1] media: rc: Add driver for tango IR decoder
References: <e05783d3-012d-0798-9a54-ff42039e728d@sigmadesigns.com>
        <yw1xd16oyqas.fsf@mansr.com>
        <569e41a9-57c9-3d6f-4157-dffb23f997c6@sigmadesigns.com>
Date: Tue, 19 Sep 2017 13:21:32 +0100
In-Reply-To: <569e41a9-57c9-3d6f-4157-dffb23f997c6@sigmadesigns.com> (Marc
        Gonzalez's message of "Tue, 19 Sep 2017 13:53:30 +0200")
Message-ID: <yw1xwp4uyj3n.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marc Gonzalez <marc_gonzalez@sigmadesigns.com> writes:

> On 18/09/2017 17:33, Måns Rullgård wrote:
>
>> What have you changed compared to my original code?
>
> I forgot to mention one change you may not approve of, so we should
> probably discuss it.
>
> Your driver supported an optional DT property "linux,rc-map-name"
> to override the RC_MAP_EMPTY map. Since the IR decoder supports
> multiple protocols, I found it odd to specify a scancode map in
> something as low-level as the device tree.
>
> I saw only one board using that property:
> $ git grep "linux,rc-map-name" arch/
> arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts:     linux,rc-map-name = "rc-geekbox";
>
> So I removed support for "linux,rc-map-name" and used ir-keytable
> to load a given map from user-space, depending on which RC I use.
>
> Mans, Sean, what do you think?

The property is documented as common for IR receivers although only a
few drivers seem to actually implement the feature.  Since driver
support is trivial, I see no reason to skip it.  Presumably someone
had a use for it, or it wouldn't have been added.

-- 
Måns Rullgård
