Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41843 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaKDT0W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Nov 2014 14:26:22 -0500
Message-ID: <54592859.7060705@iki.fi>
Date: Tue, 04 Nov 2014 21:26:17 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?=
	<u.kleine-koenig@pengutronix.de>
CC: Fabio Estevam <festevam@gmail.com>, shawn.guo@linaro.org,
	Fabio Estevam <fabio.estevam@freescale.com>,
	linux-arm-kernel@lists.infradead.org,
	Jeff Mahoney <jeffm@suse.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: imx: Fix the removal of CONFIG_SPI option
References: <1415096927-4097-1-git-send-email-festevam@gmail.com> <20141104152646.GA8450@pengutronix.de> <5458F6F3.8050007@iki.fi> <20141104191808.GH8316@pengutronix.de>
In-Reply-To: <20141104191808.GH8316@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka,

On 11/04/2014 09:18 PM, Uwe Kleine-König wrote:
> Hello,
>
> On Tue, Nov 04, 2014 at 05:55:31PM +0200, Antti Palosaari wrote:
>> On 11/04/2014 05:26 PM, Uwe Kleine-König wrote:
>>> [Note, this is a resend of a mail I accidently only sent to Fabio
>>> before.]
>>>
>>> Hello,
>>>
>>> On Tue, Nov 04, 2014 at 08:28:47AM -0200, Fabio Estevam wrote:
>>>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>>>
>>>> Since 64546e9fe3a5b8c ("ARM: imx_v6_v7_defconfig updates") and commit
>>>> 0650f855d2e4b0b9 ("ARM: imx_v4_v5_defconfig: Select CONFIG_IMX_WEIM") CONFIG_SPI
>>>> selection was dropped by savedefconfig for imx_v4_v5_defconfig and
>>>> imx_v6_v7_defconfig.
>>>>
>>>> In order to keep the same behaviour as previous kernel versions and avoid
>>>> regressions, let's add CONFIG_SPI option back.
>>>>
>>>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>>>> ---
>>>> Changes since v1:
>>>> - Add commit id's that caused the issue.
>>> on top of 64546e9fe3a5b8c doing
>>>
>>>          make imx_v6_v7_defconfig
>>>
>>> resulted in CONFIG_SPI=y. That's because MEDIA_SUBDRV_AUTOSELECT selects
>>> SPI and has default y.
>>>
>>> So the commit that really broke imx_v6_v7_defconfig is 7d24c514e8e0
>>> ([media] Kconfig: do not select SPI bus on sub-driver auto-select).
>>> On a side note I wonder how that commit sneaked into v3.17-rc6.
>>>
>>> I think people need to be more aware of the results of Kconfig changes
>>
>> I added that SPI select patch for 3.17-rc1 and it was removed right
>> after I got bug report it should not be there. But there was of
>> course some delay and removal patch went to 3.17-rc6.
> Still I think that -rc6 is quite late for such a patch. But obviously
> I'm not the relevant maintainer here and YMMV.


Yes, it is late. I send PULL request last day of rc1, but media fixes 
are not send for every rc, instead for rc1 and 1-2 times after that, 
usually very near end of merge window.



>
>> But all in all, it was all happening during 3.17 period and I wonder
>> how it could affect you?
> Commit 64546e9fe3a5 was based on v3.17-rc3 and so had the "select SPI".
> That's why savedefconfig removed CONFIG_SPI=y from the minimized config.
>
> Dropping the select for -rc6 resulted in imx_v6_v7_defconfig not
> including CONFIG_SPI any more.
>
> I checked all commits listed by:
>
> 	git log --oneline linus/master ^e4462ffc1602 -SCONFIG_SPI
>
> and the two imx defconfigs are the only ones being affected by this
> issue.
>
> Best regards
> Uwe
>

regards
Antti

-- 
http://palosaari.fi/
