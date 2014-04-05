Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:57354 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbaDEQvb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Apr 2014 12:51:31 -0400
Received: by mail-qa0-f51.google.com with SMTP id j7so4399487qaq.10
        for <linux-media@vger.kernel.org>; Sat, 05 Apr 2014 09:51:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20140405T175545-158@post.gmane.org>
References: <op.v7n77sv031sqp4@00-25-22-b5-7b-09.dummy.porta.siemens.net> <loom.20140405T175545-158@post.gmane.org>
From: Ramiro Morales <cramm0@gmail.com>
Date: Sat, 5 Apr 2014 13:43:11 -0300
Message-ID: <CAO7PdF9OdqjZWs9dPN=rM9m-fGMUCfm5WaOTtXNSnbJTH+EcFg@mail.gmail.com>
Subject: Re: [PATCH] rc-videomate-m1f.c Rename to match remote controler name
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 5, 2014 at 1:34 PM, Ramiro Morales <cramm0@gmail.com> wrote:
> This hasn't landed correctly. Two years later, the rename is still
> implemented in a halfway fashion on the kernel source tree:
>
> The drivers/media/rc/keymaps/Makefile file still mentions
> rc-videomate-m1f.o and there is still a drivers/media/rc/keymaps
> /rc-videomate-m1f.c file that should be named rc-videomate-m1f.c instead.

See:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/media/rc/keymaps/Makefile?id=refs/tags/v3.14#n97

and

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/media/rc/keymaps/rc-videomate-m1f.c?id=refs/tags/v3.14

-- 
Ramiro Morales
@ramiromorales
