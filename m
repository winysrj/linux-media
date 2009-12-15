Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:64312 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbZLOLEW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 06:04:22 -0500
Date: Tue, 15 Dec 2009 12:04:12 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Jan Korbel <jackc@teptin.net>
cc: Markus Suvanto <markus.suvanto@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: High cpu load (dvb_usb_dib0700)
In-Reply-To: <4B2750BD.6000700@teptin.net>
Message-ID: <alpine.LRH.2.00.0912151203580.16159@pub6.ifh.de>
References: <bcf98daa0911270513v7463260dm36e0a5e2557b797f@mail.gmail.com> <4B2750BD.6000700@teptin.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, 15 Dec 2009, Jan Korbel wrote:

> Hello.
>
> I have the same problem. Two tuners "ASUS My Cinema U3000 Mini DVBT Tuner":
>
> Bus 005 Device 004: ID 0b05:171f ASUSTek Computer, Inc.
> Bus 005 Device 003: ID 0b05:171f ASUSTek Computer, Inc.
>
> Kernel 2.6.31 and 2.6.32 (debian packages), firmware dvb-usb-dib0700-1.20.fw. 
> Intel Atom 330 (dualcore CPU).

Have you tried to load dvb-usb with disable_rc_polling=1 ?

It may or may not help.

If it helps it will necessary to have a look at the ir-polling code to see 
whether there is some thing like 'scheduling'.

regards,
--

Patrick
