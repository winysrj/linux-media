Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:54178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab1F3NYL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 09:24:11 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5UDOBfY003708
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 30 Jun 2011 09:24:11 -0400
Message-ID: <4E0C78F9.2010302@redhat.com>
Date: Thu, 30 Jun 2011 10:24:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [git:xawtv3/master] xawtv: reenable its usage with webcam's
References: <E1Qbdw6-0007wL-E8@www.linuxtv.org> <4E0B05F5.1000704@redhat.com> <4E0B1407.8000907@redhat.com> <4E0B199B.4010008@redhat.com> <4E0B7CA3.3010104@redhat.com> <4E0C5639.9030501@redhat.com> <4E0C6D7E.4080800@redhat.com> <4E0C7815.3010907@redhat.com>
In-Reply-To: <4E0C7815.3010907@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 30-06-2011 10:20, Mauro Carvalho Chehab escreveu:
> Em 30-06-2011 09:35, Mauro Carvalho Chehab escreveu:
>> Em 30-06-2011 07:55, Hans de Goede escreveu:
> 
>>> 1) This bit should be #ifdef __linux__ since we only support
>>> auto* on linux because of the sysfs dep:
>>
>> True, but instead of adding it on every place, the better would be to replace auto/auto_tv
>> at the library, instead of adding the test at each place we change to auto mode.
> 
> I fixed it using this approach.
> 
>>> 2) The added return NULL in case no device can be found lacks
>>> printing an error message:
> 
>>> I propose changing the return NULL, with a goto to the error print further down.
>>
>> Yes, that sounds better to me.
> 
> The error message didn't look good, so I added an specific message for it.
> 
> Yet, IMO, we're being too verbose:
> 
> $ scantv 
> vid-open-auto: failed to open an analog TV device at /dev/video0
> vid-open: could not find a suitable videodev
> no analog TV device available

Ah, calling it without any media driver is also verbose and wrong:

$ xawtv
This is xawtv-, running on Linux/x86_64 (2.6.32-131.0.15.el6.x86_64)
vid-open-auto: failed to open a capture device at 
vid-open: could not find a suitable videodev
no video grabber device available

$ scantv
vid-open-auto: failed to open an analog TV device at �7
                                                       
vid-open: could not find a suitable videodev
no analog TV device available

Mauro
