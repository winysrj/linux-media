Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab0IHQ37 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 12:29:59 -0400
Message-ID: <4C87BA04.7030908@redhat.com>
Date: Wed, 08 Sep 2010 13:29:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: Re: IR code autorepeat issue?
References: <20100829064036.GB22853@kryten> <4C7A8056.4070901@infradead.org>
In-Reply-To: <4C7A8056.4070901@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 29-08-2010 12:44, Mauro Carvalho Chehab escreveu:
> Em 29-08-2010 03:40, Anton Blanchard escreveu:
>>
>> I'm seeing double IR events on 2.6.36-rc2 and a DViCO FusionHDTV DVB-T Dual
>> Express.
> There's one issue on touching on this constant: it is currently just one global 
> timeout value that will be used by all protocols. This timeout should be enough to
> retrieve and proccess the repeat key event on all protocols, and on all devices, or 
> we'll need to do a per-protocol (and eventually per device) timeout init. From 
> http://www.sbprojects.com/knowledge/ir/ir.htm, we see that NEC prococol uses 110 ms
> for repeat code, and we need some aditional time to wake up the decoding task. I'd
> say that anything lower than 150-180ms would risk to not decode repeat events with
> NEC.
> 
> I got exactly the same problem when adding RC CORE support at the dib0700 driver. At
> that driver, there's an additional time of sending/receiving URB's from USB. So, we
> probably need a higher timeout. Even so, I tried to reduce the timeout to 200ms or 150ms 
> (not sure), but it didn't work. So, I ended by just patching the dibcom driver to do 
> dev->rep[REP_DELAY] = 500:

Ok, just sent a patch adding it to rc-core, and removing from dib0700 driver.

Cheers,
Mauro.
