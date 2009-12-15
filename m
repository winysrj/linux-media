Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f211.google.com ([209.85.217.211]:43748 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760137AbZLOMVA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 07:21:00 -0500
Received: by gxk3 with SMTP id 3so5584981gxk.1
        for <linux-media@vger.kernel.org>; Tue, 15 Dec 2009 04:20:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.0912151203580.16159@pub6.ifh.de>
References: <bcf98daa0911270513v7463260dm36e0a5e2557b797f@mail.gmail.com>
	 <4B2750BD.6000700@teptin.net>
	 <alpine.LRH.2.00.0912151203580.16159@pub6.ifh.de>
Date: Tue, 15 Dec 2009 14:20:59 +0200
Message-ID: <bcf98daa0912150420u586a16b8k5c49076b01407a8e@mail.gmail.com>
Subject: Re: High cpu load (dvb_usb_dib0700)
From: Markus Suvanto <markus.suvanto@gmail.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Jan Korbel <jackc@teptin.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Have you tried to load dvb-usb with disable_rc_polling=1 ?
>
> It may or may not help.
>
> If it helps it will necessary to have a look at the ir-polling code to see
> whether there is some thing like 'scheduling'.

Yes it helps.
echo 1 >  /sys/module/dvb_usb/parameters/disable_rc_polling
and my cpu load goes down but remote control don't work anymore.

-Markus
