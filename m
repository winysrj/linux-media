Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35499 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbcC2G2k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 02:28:40 -0400
MIME-Version: 1.0
In-Reply-To: <1458911416-47981-4-git-send-email-hverkuil@xs4all.nl>
References: <1458911416-47981-1-git-send-email-hverkuil@xs4all.nl>
	<1458911416-47981-4-git-send-email-hverkuil@xs4all.nl>
Date: Tue, 29 Mar 2016 15:28:39 +0900
Message-ID: <CAJKOXPdpkE5OdNEAVTsbQrjpZZgwDgY2=g9ocM0rFaOU-N=pEw@mail.gmail.com>
Subject: Re: [PATCHv14 03/18] dts: exynos4412-odroid*: enable the HDMI CEC device
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
	lars@opdenkamp.eu, linux@arm.linux.org.uk,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 25, 2016 at 10:10 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
>
> Add a dts node entry and enable the HDMI CEC device present in the Exynos4
> family of SoCs.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  arch/arm/boot/dts/exynos4412-odroid-common.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)

Applied for v4.7 with a little bit different subject and the new node
put in alphabetical order. Please don't include your original patch in
your tree because any merging will probably end with having these
nodes twice.

https://git.kernel.org/cgit/linux/kernel/git/krzk/linux.git/log/?h=next/dt
(but tell me if you need to base on this so I would prepare a tag)

Best regards,
Krzysztof
