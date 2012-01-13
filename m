Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52092 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758173Ab2AMOYx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 09:24:53 -0500
Received: by werb13 with SMTP id b13so428189wer.19
        for <linux-media@vger.kernel.org>; Fri, 13 Jan 2012 06:24:52 -0800 (PST)
Message-ID: <4F103EAF.1010302@gmail.com>
Date: Fri, 13 Jan 2012 15:24:47 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Jim Darby <uberscubajim@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: Possible regression in 3.2 kernel with PCTV Nanostick T2 (em28xx,
 cxd2820r and tda18271)
References: <4F0C3D1B.2010904@gmail.com> <4F0CE040.7020904@iki.fi> <4F0DE0C2.5050907@gmail.com> <4F0F08DB.4050301@gmail.com> <4F1013CD.10104@redhat.com> <4F102D0F.3010408@gmail.com>
In-Reply-To: <4F102D0F.3010408@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 13/01/2012 14:09, Jim Darby ha scritto:
> On 13/01/12 11:21, Mauro Carvalho Chehab wrote:
> 
>> Hmm... this patch shouldn't be causing troubles for an application that
>> only uses DVBv3 call. Is Kaffeine filling the DTV_DELIVERY_SYSTEM with
>> SYS_UNDEFINED (0)?
> 
> I think this is perhaps where (some of) our problems are starting. I
> just looked at the kaffeine source code and, as far as I can make out,
> DTV_DELIVERY_SYSTEM is filled out by performing a FE_SET_PROPERTY ioctl
> with a key/value pair of something like DTV_DELIVERY_SYSTEM/SYS_DVBS2
> (amongst other parameters).
> 
> The issue here is that kaffeine *only* performs any sort of
> FE_SET_PROPERTY ioctl for DVB-S2. It certainly doesn't for any form of
> DVB-T (2 or original).
> 
> It would therefore appear that kaffeine is committing a sin of omission
> in not setting the front-end properties and hence we have this problem.

Hi Jim,
that's because Kaffeine is using the new DVBv5 API to interface with
DVB-S2 hardware (as this is the only API supported), while it is using
the old DVBv3 API to interface to DVB-T/C hardware. It's not a real
problem, as in dvb-core there is some emulation logic that takes care of
supporting DVBv3 applications.

> Mauro, if you can confirm that this is the case and that with the latest
> linux-media drivers performing the FE_SET_PROPERTY ioctl is mandatory
> then I can work with the kaffeine developers and get this fixed.
> 
> For reference, the existing kaffeine works with the stock 3.2.0 kernel.
> It's just the linux-media from linux-tv.org that breaks it.

Mauro already fixed the bug I reported. But if you can work with the
Kaffeine developers to adopt DVBv5 API also for DVB-T/C tuners, it would
be a nice contribution.

Best regards,
Gianluca

