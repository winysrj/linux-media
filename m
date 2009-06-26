Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:55605 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZFZOuc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 10:50:32 -0400
Received: by gxk26 with SMTP id 26so878953gxk.13
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 07:50:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A44DCFB.3010906@koala.ie>
References: <4A448634.7000209@powercraft.nl>
	 <829197380906260640r45a31a83gd4bf23c06fdcf88f@mail.gmail.com>
	 <4A44DCFB.3010906@koala.ie>
Date: Fri, 26 Jun 2009 10:50:32 -0400
Message-ID: <829197380906260750yc99868i9da83ee0153943aa@mail.gmail.com>
Subject: Re: Pinnacle Systems PCTV 330e and Hauppauge WinTV HVR 900 (R2) not
	working under Debian 2.6.30-1
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Simon Kenyon <simon@koala.ie>
Cc: Jelle de Jong <jelledejong@powercraft.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 26, 2009 at 10:36 AM, Simon Kenyon<simon@koala.ie> wrote:
> as you know i have the xl10353 variant. and you got it to work on my
> machine.
>
> now i know you don't want to hear this but the same code will not work on
> another machine.
> both are running 2.6.28-gentoo-r5, however i'm pretty sure the
> configurations are different.
> the working machine has an MSI KA780G MS-7551 [SB700 chipset] motherboard
> and
> the non-working machine has an ASUSTeK M3N78-EM [GeForce 8200 chipset]
> motherboard
>
> in fact, i've seen reference on this list to the fact that there are
> problems with the SB700. that seems to be the opposite to me.
> i will check it out on an Atom based netbook and an old Intel Centrino
> laptop to see if the code works there.
> i suspect it will - but need to confirm it.
>
> i'm afriad it is two steps forward and one step backwards
> --
> simon

Well, that's better than one step forward and two steps backward.  :-)

Send me the dmesg offline and I will work with you to try to debug the
issue.  I have some significant doubts this is an em28xx issue though.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
