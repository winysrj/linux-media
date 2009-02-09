Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:57181 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbZBIPOQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 10:14:16 -0500
Date: Mon, 9 Feb 2009 16:13:31 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Matthias Schwarzott <zzam@gentoo.org>
cc: linux-dvb@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC - Flexcop Streaming watchdog (VDSB)
In-Reply-To: <200901252217.08848.zzam@gentoo.org>
Message-ID: <alpine.LRH.1.10.0902091612080.3870@pub3.ifh.de>
References: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de> <200901252217.08848.zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On Sun, 25 Jan 2009, Matthias Schwarzott wrote:
> Does it get better using spin_lock_irqsave instead of spin_lock_irq ?

Thanks again for your input. My observation was wrong. It was not the 
spin_lock causing the problem, but a msleep which lead to the 
BUG_ON-condition....

Patrick.
