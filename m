Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36207 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256Ab2EVUig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 16:38:36 -0400
Received: by obbtb18 with SMTP id tb18so10063136obb.19
        for <linux-media@vger.kernel.org>; Tue, 22 May 2012 13:38:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FBBF83C.8040201@gmail.com>
References: <4FBBF83C.8040201@gmail.com>
Date: Tue, 22 May 2012 16:38:36 -0400
Message-ID: <CAGoCfiwgpnAFZ0axsZqzWBzjGffLZPeZ8bnA_vaL1jcia0rk5A@mail.gmail.com>
Subject: Re: HVR1600 and Centos 6.2 x86_64 -- Strange Behavior
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bob Lightfoot <boblfoot@gmail.com>
Cc: linux-media@vger.kernel.org, atrpms-users@atrpms.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 22, 2012 at 4:34 PM, Bob Lightfoot <boblfoot@gmail.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Dear LinuxTv and AtRpms Communities:
>     In the most recent three kernels {2.6.32-220.7.1 ;
> 2.6.32-220.13.1 ; 2.6.32-220.17.1} released for CentOS 6.2 I have
> experienced what can only be described as a strange behavior of the
> V4L kernel modules with the Hauppage HVR 1600 Card.  If I reboot the
> PC in question {HP Pavillion Elite M9040n} I will lose sound on the
> Analog TV Tuner.  If I Power off the PC, leave it off for 30-60
> seconds and start it back up then I have sound with the Analog TV
> Tuner every time.  Not sure what is causing this, but thought the
> condition was worth sharing.

Could you please clarify which HVR-1600 board you have (e.g. the PCI
ID)?  I suspect we're probably not resetting the audio processor
properly, but I would need to know exactly which board you have in
order to check that.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
