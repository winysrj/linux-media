Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61755 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1GXNuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 09:50:07 -0400
Received: by ewy4 with SMTP id 4so2157289ewy.19
        for <linux-media@vger.kernel.org>; Sun, 24 Jul 2011 06:50:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiyM1O1o2Ops=fzwPEL2pR-e4TbSqm0qDXtQqAfifa0KjQ@mail.gmail.com>
References: <CAGoCfiyp4TB6RvF75WFrFLkTxha0-XKrXnR8L13BwJu938PaHg@mail.gmail.com>
	<4E2C16B5.5010703@redhat.com>
	<CAGoCfiyM1O1o2Ops=fzwPEL2pR-e4TbSqm0qDXtQqAfifa0KjQ@mail.gmail.com>
Date: Sun, 24 Jul 2011 09:50:04 -0400
Message-ID: <CAGoCfizDnecpta5wA29Bq9cWKxVFm_sgriUjDivUBXh1DOZN0Q@mail.gmail.com>
Subject: Re: [PATCH] Fix regression introduced which broke the Hauppauge
 USBLive 2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 24, 2011 at 9:02 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> I don't dispute the possibility that there is some *other* bug that
> effects users who have some other value for HZ, but neither I nor the
> other use saw it.  Without this patch though, the device is broken for
> *everybody*.
>
> I would suggest checking in this patch, and separately the HZ issue
> can be investigated.
>
> I'll see if I can find some cycles today to reconfigure my kernel with
> a different HZ.  Will also check the datasheets and see if Conexant
> documented any sort of time for power ramping.  It's not uncommon for
> such documentation to include a diagram showing timing for power up.

Reconfigured CONFIG_HZ to 1000 and indeed I am seeing the problem.
Will try to track down the correct fix this afternoon.

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
