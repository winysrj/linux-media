Return-path: <linux-media-owner@vger.kernel.org>
Received: from 9.mo1.mail-out.ovh.net ([178.32.108.172]:48320 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752130AbaIYRNx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 13:13:53 -0400
Received: from mail604.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo1.mail-out.ovh.net (Postfix) with SMTP id CD832FFAF72
	for <linux-media@vger.kernel.org>; Thu, 25 Sep 2014 17:57:45 +0200 (CEST)
Message-ID: <54243B6B.9000102@ventoso.org>
Date: Thu, 25 Sep 2014 17:57:31 +0200
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
To: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Fengguang Wu <fengguang.wu@intel.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Jet Chen <jet.chen@intel.com>,
	Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
	LKP <lkp@01.org>, linux-kernel@vger.kernel.org, crope@iki.fi
Subject: Re: [media/dvb_usb_af9005] BUG: unable to handle kernel paging request
 (WAS: [media/em28xx] BUG: unable to handle kernel)
References: <20140919014124.GA8326@localhost> <541C7D9D.30908@googlemail.com> <541C826D.7060702@googlemail.com> <541C8A26.6050207@ventoso.org> <5421C187.2070407@googlemail.com> <5421E00B.2050404@ventoso.org> <54241E7D.3050201@googlemail.com>
In-Reply-To: <54241E7D.3050201@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

El 25/09/14 15:54, Frank Schäfer ha escrit:
> 
> Am 23.09.2014 um 23:03 schrieb Luca Olivetti:
>> El 23/09/14 20:52, Frank Schäfer ha escrit:
>>
>>>>> This seems to be an ancient bug, which is known at least since 5 1/2 years:
>>>>> https://lkml.org/lkml/2009/2/4/350
>> [...]
>>>> #if defined(CONFIG_MODULE) || defined(CONFIG_DVB_USB_AF9005_REMOTE)
>>> What happens, if CONFIG_MODULES is enabled, but neither module
>>> af9005-remote nor any other IR module is available ?
>>> Has this ever been tested ?
>> I think I tested at the time and symbol_request returned NULL in that
>> case, however I'm not sure and I cannot find any documentation on how
>> symbol_request is supposed to work in that case.
> 
> Ok, thanks.
> I assume noone wants to invest some time into this old driver and covert
> it to todays kernel IR infrastructure as suggested by Antti ? :-)

Not me ;-)

> Then I'm going to send a patch with the 
> 
> #if defined(CONFIG_MODULE) || defined(CONFIG_DVB_USB_AF9005_REMOTE)
> 
> approach.
> That's at least better than leaving the bug unfixed.

Yes, it's an acceptable workaround until the bug in symbol_request is
fixed (because the bug actually is in symbol_request, isn't it?)

Bye
-- 
Luca
