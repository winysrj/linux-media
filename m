Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34707 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbcC2G1J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 02:27:09 -0400
MIME-Version: 1.0
In-Reply-To: <1458911416-47981-3-git-send-email-hverkuil@xs4all.nl>
References: <1458911416-47981-1-git-send-email-hverkuil@xs4all.nl>
	<1458911416-47981-3-git-send-email-hverkuil@xs4all.nl>
Date: Tue, 29 Mar 2016 15:27:08 +0900
Message-ID: <CAJKOXPcqY6cXnvuokVZ+nZpbHpoVQLPJKJR_5QDR4RTSabAApg@mail.gmail.com>
Subject: Re: [PATCHv14 02/18] dts: exynos4: add node for the HDMI CEC device
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
	lars@opdenkamp.eu, linux@arm.linux.org.uk,
	Kamil Debski <kamil@wypas.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 25, 2016 at 10:10 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Kamil Debski <kamil@wypas.org>
>
> This patch adds HDMI CEC node specific to the Exynos4210/4x12 SoC series.
>
> Signed-off-by: Kamil Debski <kamil@wypas.org>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4.dtsi | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

Applied for v4.7 with a little bit different subject.

Best regards,
Krzysztof
