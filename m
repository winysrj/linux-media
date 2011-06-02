Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47762 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1FBPRC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 11:17:02 -0400
Received: by ewy4 with SMTP id 4so310114ewy.19
        for <linux-media@vger.kernel.org>; Thu, 02 Jun 2011 08:17:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE7A131.7010208@redhat.com>
References: <4D764337.6050109@email.cz>
	<20110531124843.377a2a80@glory.local>
	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>
	<20110531174323.0f0c45c0@glory.local>
	<BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
	<4DE7A131.7010208@redhat.com>
Date: Thu, 2 Jun 2011 11:17:00 -0400
Message-ID: <BANLkTinKOoSJUOBFKy=PK3jJgaonzWrPxQ@mail.gmail.com>
Subject: Re: [linux-dvb] XC4000 patches for kernel 2.6.37.2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitri Belimov <d.belimov@gmail.com>, linux-media@vger.kernel.org,
	thunder.m@email.cz, "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>,
	bahathir@gmail.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jun 2, 2011 at 10:41 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>> 1.  Assemble tree with current patches
>
> It is probably easier for me to do this step, as I have my hg import
> scripts. However, as I don't have the PCTV devices added at dib0700,
> I can't test.
>
> OK, I did this work, as it just took me a few minutes to rebase patches
> 1 and 2. I didn't apply the patches that started with "djh" since they
> seemed to be a few hacks during the development time.
>
> The tree is at:
>
> git://linuxtv.org/mchehab/experimental.git branch xc4000
>
> There are two warnings there that needs to be fixed:
>
> drivers/media/common/tuners/xc4000.c:1293: warning: ‘xc4000_is_firmware_loaded’ defined but not used
> drivers/media/common/tuners/xc4000.c: In function ‘check_firmware.clone.0’:
> drivers/media/common/tuners/xc4000.c:1107: warning: ‘version’ may be used uninitialized in this function
>
> Both seems to be trivial.
>
> A disclaimer notice here: I didn't make any cleanup at the code,
> (except by running a whitespace cleanup script) nor I've reviewed it.
>
> IMO, the next step is to test the rebases against a real hardware,
> and adding a few patches fixing it, if the rebases broke.
>
> The next step would be fix the CodingStyle, and run checkpatch.pl.
> There aren't many CodingStyle warnings/errors (13 errors, 28 warnings).
> Most of the errors are due to the excess usage of printk's for debug,
> and due to some obsolete code commented with //.

Hi Mauro,

Thanks for taking this on.  The tree you posted looks like a pretty
reasonable start.  I agree that the "djh - " commits probably aren't
required as they are most just from rebasing the tree.  We'll find out
from testing though whether this is true.  There's one patch with
subject "djh - more debugging" might actually be needed, but we'll see
when users try the tree.

This provides a pretty good base for istan_v to work off of, since he
did a rather large amount of refactoring to get analog to work - which
I was unable to even try given the two devices I had can't do analog
support due to limitations in the dvb-usb framework.

Mohammad, it would be great if you could try out Mauro's tree, since
it should work as-is for the 340e.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
