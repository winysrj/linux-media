Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:46680 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZAZPGo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2009 10:06:44 -0500
Date: Mon, 26 Jan 2009 16:05:51 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Matthias Schwarzott <zzam@gentoo.org>
cc: linux-dvb@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC - Flexcop Streaming watchdog (VDSB)
In-Reply-To: <200901252217.08848.zzam@gentoo.org>
Message-ID: <alpine.LRH.1.10.0901261603500.6777@pub6.ifh.de>
References: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de> <200901252217.08848.zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthias,
hi Andy,


On Sun, 25 Jan 2009, Matthias Schwarzott wrote:
>> What can I do? What is the proper way to protect access to this list? Is
>> it needed at all?
>
> I thought this is a perfectly legetimate usage of spinlocks. What is the exact
> wording of the message. Is it a message of lockdep, or another kind of
> message?
>
> Does it get better using spin_lock_irqsave instead of spin_lock_irq ?

I'll try yours suggestions this evening... along with dumping all 
error message if any.

Thanks for taking the time.

best regards
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
