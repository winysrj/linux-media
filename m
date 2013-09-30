Return-path: <linux-media-owner@vger.kernel.org>
Received: from cernmx32.cern.ch ([137.138.144.178]:9281 "EHLO CERNMX32.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328Ab3I3OcE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 10:32:04 -0400
From: Dinesh Ram <Dinesh.Ram@cern.ch>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "edubezval@gmail.com" <edubezval@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: RE: [PATCH 2/6] si4713 : Modified i2c driver to handle cases where
 interrupts are not used
Date: Mon, 30 Sep 2013 14:32:00 +0000
Message-ID: <C40DBE54484849439FC5081A05AEF5F5979F18A6@PLOXCHG24.cern.ch>
References: <a661e3d7ccefe3baa8134888a0471ce1e5463f47.1377861337.git.dinram@cisco.com>
 <1377862104-15429-1-git-send-email-dinram@cisco.com>
 <b1680e68e86967955634fab0d4054a8e8100d422.1377861337.git.dinram@cisco.com>
 <CAC-25o9OW1nmuzbmRX6dW4pLwaJHaFTxXTr_nzaGXk1HDzcdzA@mail.gmail.com>
 <52231DA0.20307@xs4all.nl>
 <CAC-25o-+u5u7yNiJ8PY40FQ9EMdLvga+NKXJaELJHT6oEBUzKg@mail.gmail.com>,<52243A18.1010209@xs4all.nl>
 <C40DBE54484849439FC5081A05AEF5F5979DEC6D@PLOXCHG23.cern.ch>,<5249779D.8020205@xs4all.nl>
In-Reply-To: <5249779D.8020205@xs4all.nl>
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I probably should have done it by now.
I will send you the changes this weekend and you can test those.
I have been quite busy on my thesis lately.

Regards,
Dinesh
________________________________________
From: Hans Verkuil [hverkuil@xs4all.nl]
Sent: 30 September 2013 15:07
To: Dinesh Ram
Cc: edubezval@gmail.com; Linux-Media
Subject: Re: [PATCH 2/6] si4713 : Modified i2c driver to handle cases where interrupts are not used

On 09/02/2013 12:29 PM, Dinesh Ram wrote:
> Hi Hans and Eduardo,
>
> Sorry for my radio silence. I was infact travelling and didn't have much opportunity to check my mails.
> I will go through the list of comments in the thread and try to fix / justify them in the next few days.
> Hans, probably at the end you might have to test it as I don't have the hardware anymore.
>
> Regards,
> Dinesh

Dinesh,

Do you plan on finalizing this, or should I take over?

Regards,

        Hans
