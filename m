Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33430 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbcFJVVR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2016 17:21:17 -0400
Subject: Re: [PATCH 5/7] ARM: OMAP: dmtimer: Do not call PM runtime functions
 when not needed.
To: Tony Lindgren <tony@atomide.com>
References: <1462634508-24961-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1462634508-24961-6-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160509193624.GH5995@atomide.com> <5730F840.3050807@gmail.com>
 <20160610102225.GS22406@atomide.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <575B2F48.4090707@gmail.com>
Date: Sat, 11 Jun 2016 00:21:12 +0300
MIME-Version: 1.0
In-Reply-To: <20160610102225.GS22406@atomide.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 10.06.2016 13:22, Tony Lindgren wrote:
>
> OK. And I just applied the related dts changes. Please repost the driver
> changes and DT binding doc with Rob's ack to the driver maintainers to
> apply.
>

Already did, see https://lkml.org/lkml/2016/5/16/429

Shall I do anything else?

Thanks,
Ivo
