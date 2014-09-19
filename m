Return-path: <linux-media-owner@vger.kernel.org>
Received: from 5.mo2.mail-out.ovh.net ([87.98.181.248]:39655 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932212AbaISUBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Sep 2014 16:01:07 -0400
Received: from mail637.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo2.mail-out.ovh.net (Postfix) with SMTP id 91EACFF9EAA
	for <linux-media@vger.kernel.org>; Fri, 19 Sep 2014 21:55:31 +0200 (CEST)
Message-ID: <541C8A26.6050207@ventoso.org>
Date: Fri, 19 Sep 2014 21:55:18 +0200
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
References: <20140919014124.GA8326@localhost> <541C7D9D.30908@googlemail.com> <541C826D.7060702@googlemail.com>
In-Reply-To: <541C826D.7060702@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

El 19/09/14 21:22, Frank Schäfer ha escrit:

>>
>> So symbol_request() returns pointers.!= NULL
>>
>> A closer look at the definition of symbol_request() shows, that it does
>> nothing if CONFIG_MODULES is disabled (it just returns its argument).
>>
>>
>> One possibility to fix this bug would be to embrace these three lines with
>>
>> #ifdef CONFIG_DVB_USB_AF9005_REMOTE
>> ...
>> #endif
> Luca, what do you think ?
> 
> This seems to be an ancient bug, which is known at least since 5 1/2 years:
> https://lkml.org/lkml/2009/2/4/350

Well, it's been a while so I don't remember the details, but I think the
same now as then ;-)
The idea behind CONFIG_DVB_USB_AF9005_REMOTE was to provide an
alternative implementation (based on lirc, at the time it wasn't in the
kernel), since this adapter doesn't decode the IR pulses by itself.
In theory you could leave it undefined but still provide an
implementation in a different module. Just adding

#ifdef CONFIG_DVB_USB_AF9005_REMOTE

would nuke the (futile?) effort.

Now, since the problem seems to be with CONFIG_MODULES disabled, maybe
you could combine both conditions

#if defined(CONFIG_MODULE) || defined(CONFIG_DVB_USB_AF9005_REMOTE)

Bye
-- 
Luca

