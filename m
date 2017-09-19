Return-path: <linux-media-owner@vger.kernel.org>
Received: from us-smtp-delivery-107.mimecast.com ([63.128.21.107]:25544 "EHLO
        us-smtp-delivery-107.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751263AbdISMnW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:43:22 -0400
Subject: Re: [PATCH v1] media: rc: Add driver for tango IR decoder
To: Mans Rullgard <mans@mansr.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC: Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Mason <slash.tmp@free.fr>
References: <e05783d3-012d-0798-9a54-ff42039e728d@sigmadesigns.com>
 <yw1xd16oyqas.fsf@mansr.com>
 <569e41a9-57c9-3d6f-4157-dffb23f997c6@sigmadesigns.com>
 <yw1xwp4uyj3n.fsf@mansr.com>
From: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Message-ID: <f4478664-be7f-5193-372c-54b972776fbb@sigmadesigns.com>
Date: Tue, 19 Sep 2017 14:43:17 +0200
MIME-Version: 1.0
In-Reply-To: <yw1xwp4uyj3n.fsf@mansr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+ Rob & Mark for the DT bindings question.

On 19/09/2017 14:21, Måns Rullgård wrote:

> Marc Gonzalez writes:
> 
>> On 18/09/2017 17:33, Måns Rullgård wrote:
>>
>>> What have you changed compared to my original code?
>>
>> I forgot to mention one change you may not approve of, so we should
>> probably discuss it.
>>
>> Your driver supported an optional DT property "linux,rc-map-name"
>> to override the RC_MAP_EMPTY map. Since the IR decoder supports
>> multiple protocols, I found it odd to specify a scancode map in
>> something as low-level as the device tree.
>>
>> I saw only one board using that property:
>> $ git grep "linux,rc-map-name" arch/
>> arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts:     linux,rc-map-name = "rc-geekbox";
>>
>> So I removed support for "linux,rc-map-name" and used ir-keytable
>> to load a given map from user-space, depending on which RC I use.
>>
>> Mans, Sean, what do you think?
> 
> The property is documented as common for IR receivers although only a
> few drivers seem to actually implement the feature.  Since driver
> support is trivial, I see no reason to skip it.  Presumably someone
> had a use for it, or it wouldn't have been added.

I do not dispute the usefulness of the "linux,rc-map-name" property
in general, e.g. for boards that support a single remote control.

I am arguing that the person writing the device tree has no way of
knowing which rc-map a given user will be using, because it depends
on the actual remote control being used.

Maybe I'm missing something.

Regards.
