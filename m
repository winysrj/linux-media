Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35179 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdFONR5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 09:17:57 -0400
Date: Thu, 15 Jun 2017 15:17:51 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCHv2] ARM: dts: exynos: add needs-hpd to &hdmicec for
 Odroid-U3
Message-ID: <20170615131751.tz6jueb4f73essms@kozik-lap>
References: <a357d30b-9f83-ec65-c8a1-a9e81236f9ee@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a357d30b-9f83-ec65-c8a1-a9e81236f9ee@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 13, 2017 at 03:47:06PM +0200, Hans Verkuil wrote:
> The Odroid-U3 board has an IP4791CZ12 level shifter that is
> disabled if the HPD is low, which means that the CEC pin is
> disabled as well.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> Changes since v1: moved &hdmicec to after &buck to keep it somewhat
> alphabetical.
> ---
>  arch/arm/boot/dts/exynos4412-odroidu3.dts | 4 ++++
>  1 file changed, 4 insertions(+)

Thanks, applied.

Best regards,
Krzysztof
