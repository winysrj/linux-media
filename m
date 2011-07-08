Return-path: <mchehab@localhost>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52545 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab1GHAb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2011 20:31:29 -0400
Received: by vws1 with SMTP id 1so1104039vws.19
        for <linux-media@vger.kernel.org>; Thu, 07 Jul 2011 17:31:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110705172119.GA19358@kroah.com>
References: <1308252706-13879-1-git-send-email-jarod@redhat.com>
	<20110705172119.GA19358@kroah.com>
Date: Thu, 7 Jul 2011 20:31:28 -0400
Message-ID: <CANOx78EPynqirWSuSyRCjhwUks2Br1R1vBQGSD6H7HpYtydH=w@mail.gmail.com>
Subject: Re: [PATCH] [staging] lirc_serial: allocate irq at init time
From: Jarod Wilson <jarod@wilsonet.com>
To: Greg KH <greg@kroah.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Tue, Jul 5, 2011 at 1:21 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Jun 16, 2011 at 03:31:46PM -0400, Jarod Wilson wrote:
>> There's really no good reason not to just grab the desired IRQ at driver
>> init time, instead of every time the lirc device node is accessed. This
>> also improves the speed and reliability with which a serial transmitter
>> can operate, as back-to-back transmission attempts (i.e., channel change
>> to a multi-digit channel) don't have to spend time acquiring and then
>> releasing the IRQ for every digit, sometimes multiple times, if lircd
>> has been told to use the min_repeat parameter.
>>
>> CC: devel@driverdev.osuosl.org
>> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>> ---
>>  drivers/staging/lirc/lirc_serial.c |   44 +++++++++++++++++------------------
>>  1 files changed, 21 insertions(+), 23 deletions(-)
>
> This patch doesn't apply to the staging-next branch, care to respin it
> and resend it so I can apply it?

This actually got merged into mainline a few days ago via the media tree.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c4b0afee3c1730cf9b0f6ad21729928d23d3918e

Do you want me to take a look at what's in staging-next and fix that
up to apply on top of the above?

-- 
Jarod Wilson
jarod@wilsonet.com
