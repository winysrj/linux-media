Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:46777 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbZHFPVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 11:21:08 -0400
Received: by yxe5 with SMTP id 5so1118959yxe.33
        for <linux-media@vger.kernel.org>; Thu, 06 Aug 2009 08:21:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7AF3CF.3060803@email.it>
References: <4A79EC82.4050902@email.it> <4A7AE0B0.20507@email.it>
	 <829197380908060717ua009e78nc045f2940c7fc76e@mail.gmail.com>
	 <20090806112317.21240b9c@gmail.com> <4A7AF3CF.3060803@email.it>
Date: Thu, 6 Aug 2009 11:21:08 -0400
Message-ID: <829197380908060821x6cfb60f0jd73e5f9b30c21569@mail.gmail.com>
Subject: Re: Issues with Empire Dual Pen: request for help and suggestions!!!
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: xwang1976@email.it
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 6, 2009 at 11:16 AM, <xwang1976@email.it> wrote:
> Ok,
> I've made the change and now the digital tv works perfectly.
> So now I should test the analog tv, but I fear to have another kernel panic.
> Is there something I can do before testing so that to be sure that at least
> all the file system are in a safety condition even if a kernel panic
> happens.
> I'm wondering if it is the case, for example, to umount them and remount in
> read only mode so that if I have to turn off the pc, nothing can be
> corrupted (is it so?).
> What do you suggest?
> In case, how can I temporarly umount and remout the file systems in read
> only mode? Should I use alt+sys+S followed by alt+sys+U? Can I use such
> commands while I'm in KDE?
> Thank you,
> Xwang

Glad to hear it's working now.  I will add the patch and issue a PULL
request to get it into the mainline (I had to do this already for
several other boards).

Regarding your concerns on panic, as long as you have a modern
filesystem like ext3, and you don't have alot of applications running
which are doing writes, a panic is a pretty safe event.  I panic my
machine many times a week and never have any problems.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
