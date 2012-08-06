Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272Ab2HFUUr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 16:20:47 -0400
Message-ID: <5020271B.1020702@redhat.com>
Date: Mon, 06 Aug 2012 17:20:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] mantis: merge both vp2033 and vp2040 drivers
References: <1344279745-13024-1-git-send-email-mchehab@redhat.com> <CAHFNz9Jz5x8i7-ip9BOdwC06tYR1SETctvvTpA4V=mbezhRoAw@mail.gmail.com>
In-Reply-To: <CAHFNz9Jz5x8i7-ip9BOdwC06tYR1SETctvvTpA4V=mbezhRoAw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-08-2012 17:07, Manu Abraham escreveu:
> On Tue, Aug 7, 2012 at 12:32 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> As noticed at:
>>         http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/48034
>>
>> Both drivers are identical, except for the name. So, there's no
>> sense on keeping both. Instead of forking the entire code, just
>> fork the vp3033_config struct, saving some space, and cleaning
>> up the Kernel.
> 
>>
>> Reported-by: Igor M. Liplianin <liplianin@me.by>
>> Cc: Manu Abraham <abraham.manu@gmail.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Nack.
> 
> VP-2033 and 2040 are both different in terms of hardware. If someone
> wants to add
> in additional frontend characteristic differences, he shouldn't have
> to add in this code
> again.

The code are just the same for both! If it ever become different, then
it could be forked again, but for now, it is just duplicating the same
code on both places and wasting 200 lines of useless code.

Mauro.

