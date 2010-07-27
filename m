Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0G0TYF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 15:24:05 -0400
Message-ID: <4C4F3267.2060908@redhat.com>
Date: Tue, 27 Jul 2010 16:24:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 0/15] STAGING: add lirc device drivers
References: <20100726232546.GA21225@redhat.com> <4C4F0244.2070803@redhat.com> <20100727181757.GD9465@redhat.com>
In-Reply-To: <20100727181757.GD9465@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-07-2010 15:17, Jarod Wilson escreveu:
> On Tue, Jul 27, 2010 at 12:59:00PM -0300, Mauro Carvalho Chehab wrote:
>> Em 26-07-2010 20:25, Jarod Wilson escreveu:
>>> This patch series adds the remaining lirc_foo device drivers to the staging
>>> tree.
>>>  drivers/staging/lirc/TODO               |    8 +
> 
> ^^^
> 
>> Hi Jarod,
>>
>> Please add a TODO file at staging/lirc, describing what's needed for
>> the drivers to move to the IR branch.
> 
> See above. :)

Ops!

> It could use some further fleshing out though, particularly, some "known
> issues that must be fixed in this specific driver" type things.

Yes, but that's ok for now ;)

Cheers,
Mauro
