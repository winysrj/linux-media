Return-path: <linux-media-owner@vger.kernel.org>
Received: from 9.mo4.mail-out.ovh.net ([46.105.40.176]:55781 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751746AbaIWXcu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 19:32:50 -0400
Received: from mail607.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id 236C5FFA85F
	for <linux-media@vger.kernel.org>; Tue, 23 Sep 2014 23:03:22 +0200 (CEST)
Message-ID: <5421E00B.2050404@ventoso.org>
Date: Tue, 23 Sep 2014 23:03:07 +0200
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
References: <20140919014124.GA8326@localhost> <541C7D9D.30908@googlemail.com> <541C826D.7060702@googlemail.com> <541C8A26.6050207@ventoso.org> <5421C187.2070407@googlemail.com>
In-Reply-To: <5421C187.2070407@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

El 23/09/14 20:52, Frank Schäfer ha escrit:

>>> This seems to be an ancient bug, which is known at least since 5 1/2 years:
>>> https://lkml.org/lkml/2009/2/4/350
[...]
>>
>> #if defined(CONFIG_MODULE) || defined(CONFIG_DVB_USB_AF9005_REMOTE)
> What happens, if CONFIG_MODULES is enabled, but neither module
> af9005-remote nor any other IR module is available ?
> Has this ever been tested ?

I think I tested at the time and symbol_request returned NULL in that
case, however I'm not sure and I cannot find any documentation on how
symbol_request is supposed to work in that case.

Bye
-- 
Luca

