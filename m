Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:35688 "EHLO
	mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbcGGNY2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 09:24:28 -0400
Received: by mail-it0-f47.google.com with SMTP id j185so99777896ith.0
        for <linux-media@vger.kernel.org>; Thu, 07 Jul 2016 06:24:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467848203-14007-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467848203-14007-1-git-send-email-steve_longerbeam@mentor.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 7 Jul 2016 06:24:20 -0700
Message-ID: <CAJ+vNU1RL4qUix5knhhRjr+tdj_1E5LM9_thjBcJG1gU7kXkPQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] ARM: dts: imx6-sabre*: add video capture nodes
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 6, 2016 at 4:36 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Steve Longerbeam (6):
>   ARM: dts: imx6-sabrelite: add video capture devices and connections
>   ARM: dts: imx6-sabresd: add video capture devices and connections
>   ARM: dts: imx6-sabreauto: create i2cmux for i2c3
>   ARM: dts: imx6-sabreauto: add reset-gpios property for max7310_b
>   ARM: dts: imx6-sabreauto: add pinctrl for gpt input capture
>   ARM: dts: imx6-sabreauto: add video capture devices and connections
>
>  arch/arm/boot/dts/imx6dl-sabresd.dts     |  42 +++++++++
>  arch/arm/boot/dts/imx6q-sabresd.dts      |  14 +++
>  arch/arm/boot/dts/imx6qdl-sabreauto.dtsi | 154 ++++++++++++++++++++++++++-----
>  arch/arm/boot/dts/imx6qdl-sabrelite.dtsi |  95 +++++++++++++++++++
>  arch/arm/boot/dts/imx6qdl-sabresd.dtsi   | 130 +++++++++++++++++++++++++-
>  5 files changed, 413 insertions(+), 22 deletions(-)
>

Steve,

These should wait until your drivers make it to staging (or at least
reference that series to be clear they are somewhat dependent on
them).

Regards,

Tim
