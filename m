Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53148 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002AbZIRUMV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 16:12:21 -0400
Date: Fri, 18 Sep 2009 17:11:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hiranotaka@zng.jp
Cc: linux-media@vger.kernel.org, tomy@users.sourceforge.jp
Subject: Re: [PATCH 2/2] Add a driver for Earthsoft PT1
Message-ID: <20090918171144.5f61e5cd@pedra.chehab.org>
In-Reply-To: <87my5r89xh.fsf@wei.zng.jp>
References: <87my5r89xh.fsf@wei.zng.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 23 Aug 2009 12:51:22 +0900
hiranotaka@zng.jp escreveu:

> 
> Add a driver for Earthsoft PT1
> 
> Eearthsoft PT1 is a PCI card for Japanese broadcasting with two ISDB-S
> and ISDB-T demodulators.
> 
> This card has neither MPEG decoder nor conditional access module
> onboard. It transmits only compressed and possibly encrypted MPEG data
> over the PCI bus, so you need an external software decoder and a
> decrypter to watch TV on your computer.
> 
> This driver is originally developed by Tomoaki Ishikawa
> <tomy@users.sourceforge.jp> by reverse engineering.
> 

Committed, thanks. Please take a look at the ISDB-T API recently added. It
would be good to support it on all ISDB-T drivers:

http://linuxtv.org/downloads/v4l-dvb-apis/ch09s03.html



Cheers,
Mauro
