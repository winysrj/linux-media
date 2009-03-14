Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:40189 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbZCNLDD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 07:03:03 -0400
Date: Sat, 14 Mar 2009 12:02:02 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Uri Shkolnik <urishk@yahoo.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] siano: add high level SDIO interface driver for SMS
 based cards
In-Reply-To: <20090314075154.2e2af9e7@pedra.chehab.org>
Message-ID: <alpine.LRH.1.10.0903141154310.5517@pub4.ifh.de>
References: <469952.82552.qm@web110812.mail.gq1.yahoo.com> <20090314075154.2e2af9e7@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

(sorry for hijacking) (since when do we like top-posts ? ;) )

On Sat, 14 Mar 2009, Mauro Carvalho Chehab wrote:

> Hi Uri,
>
> The patch looks sane, but I'd like to have a better picture of the Siano
> device, to better understand this interface.
>
> The basic question is: why do we need an SDIO interface for a DVB device? For
> what reason this interface is needed?

The answer is relatively easy: Some hosts only have a SDIO interface, so 
no USB, no PCI, no I2C, no MPEG2-streaming interface. So, the device has 
to provide a SDIO interface in order to read and write register and to 
make DMAs to get the data to the host. Think of your cell-phone, or your 
PDA.

There are some/a lot of vendors who use Linux in their commercial 
mobile-TV product and there are some component-makers like Siano, who are 
supporting those vendors through GPL drivers.

regards,
Patrick.
