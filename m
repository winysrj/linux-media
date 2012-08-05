Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab2HEVbJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Aug 2012 17:31:09 -0400
Message-ID: <501EE61A.2060804@redhat.com>
Date: Sun, 05 Aug 2012 18:31:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/2] get rid of fe_ioctl_override()
References: <1344190590-10863-1-git-send-email-mchehab@redhat.com> <CAGoCfizhL6=WhV9-9RMx9PX8ctV2Ao+GyMzPL8T67g4y5nBWAw@mail.gmail.com>
In-Reply-To: <CAGoCfizhL6=WhV9-9RMx9PX8ctV2Ao+GyMzPL8T67g4y5nBWAw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-08-2012 15:44, Devin Heitmueller escreveu:
> On Sun, Aug 5, 2012 at 2:16 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> There's just one driver using fe_ioctl_override(), and it can be
>> replaced at tuner_attach call. This callback is evil, as only DVBv3
>> calls are handled.
>>
>> Removing it is also a nice cleanup, as about 90 lines of code are
>> removed.
>>
>> Get rid of it!
> 
> Did you consult with anyone about this?  Did you talk to the
> maintainer for the driver that uses this functionality (he's not on
> the CC: for this patch series).  Did you actually do any testing to
> validate that it didn't break anything?
> 
> This might indeed be a piece of functionality that can possibly be
> removed, assuming you can answer yes to all three of the questions
> above.

This is not how it works. Patches are posted at the ML and developers can
review and comment about them. Does those patches break something? If not, 
please stop flaming.

With regards to Cc the driver maintainer (mkrufky), the patch also got
forwarded to him, in priv (it were supposed to be sent via git send-email, 
but, as it wasn't, the patch was manually forwarded for him to review,
just after the patchbomb).

In any case, my intention is to wait for a couple days before merging
the patches I posted today, as the dvb-usb-v2 is too new, and it is good
to hear some comments about it.

Regards,
Mauro
