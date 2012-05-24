Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933124Ab2EXQoy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 12:44:54 -0400
Message-ID: <4FBE657F.3080805@redhat.com>
Date: Thu, 24 May 2012 13:44:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL for v3.5-rc1] media updates for v3.5
References: <4FBE5518.5090705@redhat.com> <CALF0-+WqCmx0NMRZWr0D9gan4cF-J-Kf-5k_nTXKjFMYmBSt=A@mail.gmail.com>
In-Reply-To: <CALF0-+WqCmx0NMRZWr0D9gan4cF-J-Kf-5k_nTXKjFMYmBSt=A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

Em 24-05-2012 13:33, Ezequiel Garcia escreveu:
> Hi Mauro,
> 
> On Thu, May 24, 2012 at 12:34 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Ezequiel Garcia (2):
>>      [media] em28xx: Make card_setup() and pre_card_setup() static
>>      [media] em28xx: Remove unused list_head struct for queued buffers
>>
>> Ezequiel García (19):
>>      [media] em28xx: Remove redundant dev->ctl_input set
>>      [media] em28xx: Export em28xx_[read,write]_reg functions as SYMBOL_GPL
> 
> Looks like I have a clone ;)

:)

> I wasn't sure how to handle the accentuated "i" in García.
> Perhaps this change obeys the fact in some point, I changed the way
> gmail sends my name.

The from: comes from the email header, so if you changed it on your emailer, it
will affect the way it will be handled.

> I have always signed-off as Garcia (non accentuated), despite being wrong.
> 
> It's not really important, right?

No, this is not relevant. It is not uncommon that the from: line is not
matching the signed-off-by line, due to lowercase/upserspace and accents,
among other issues.

Regards,
Mauro

