Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35673 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161277AbcFMS6o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 14:58:44 -0400
Subject: Re: [PATCH 5/7] ARM: OMAP: dmtimer: Do not call PM runtime functions
 when not needed.
To: Tony Lindgren <tony@atomide.com>
References: <1462634508-24961-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1462634508-24961-6-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160509193624.GH5995@atomide.com> <5730F840.3050807@gmail.com>
 <20160610102225.GS22406@atomide.com> <575B2F48.4090707@gmail.com>
 <20160613071057.GQ22406@atomide.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <575F025F.7000101@gmail.com>
Date: Mon, 13 Jun 2016 21:58:39 +0300
MIME-Version: 1.0
In-Reply-To: <20160613071057.GQ22406@atomide.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 13.06.2016 10:10, Tony Lindgren wrote:
> * Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com> [160610 14:23]:
>>
>> On 10.06.2016 13:22, Tony Lindgren wrote:
>>>
>>> OK. And I just applied the related dts changes. Please repost the driver
>>> changes and DT binding doc with Rob's ack to the driver maintainers to
>>> apply.
>>>
>>
>> Already did, see https://lkml.org/lkml/2016/5/16/429
>>
>> Shall I do anything else?
>
> Probably good idea to repost just the driver changes to the
> subsystem maintainers. With v4.7 out any pre v4.7 patchsets
> easily get forgotten.
>

Sorry for the maybe stupid question, but does this mean that I should 
send separate patches instead of series? Or the series without what 
you've already applied?

Thanks,
Ivo
