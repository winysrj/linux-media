Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52810 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118Ab2AEUhy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 15:37:54 -0500
Received: by vcbfk14 with SMTP id fk14so683277vcb.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jan 2012 12:37:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHF9RemG4M2apwcbUG+7YvkLrbpoZmE6Nh2XMHPT4FM3jRW_Ng@mail.gmail.com>
References: <CAHF9RemG4M2apwcbUG+7YvkLrbpoZmE6Nh2XMHPT4FM3jRW_Ng@mail.gmail.com>
Date: Thu, 5 Jan 2012 15:37:53 -0500
Message-ID: <CAGoCfiwEeFiU+0scdZ48nbDfF-NCg8Ac701XkCZtXuTjckq0ng@mail.gmail.com>
Subject: Re: Support for RC-6 in em28xx driver?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Simon_S=F8ndergaard?= <john7doe@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/1/5 Simon Søndergaard <john7doe@gmail.com>:
> Hi,
>
> I recently purchased a PCTV 290e USB Stick (em28174) it comes with a
> remote almost as small as the stick itself... I've been able to get
> both stick and remote to work. I also own an MCE media center remote
> from HP (this make
> http://www.ebay.com/itm/Original-Win7-PC-MCE-Media-Center-HP-Remote-Controller-/170594956920)
> that sends RC-6 codes. While it do have a windows logo I still think
> it is vastly superior to the one that shipped with the stick :-)
>
> If I understand it correctly em28174 is a derivative of em2874?
>
> In em28xx-input.c it is stated that: "em2874 supports more protocols.
> For now, let's just announce the two protocols that were already
> tested"
>
> I've been searching high and low for a datasheet for em28(1)74, but
> have been unable to find it online. Do anyone know if one of the
> protocols supported is RC-6? and if so how do I get a copy of the
> datasheet?

The 2874 supports NEC, RC-5, and RC-6/6A.  I did the original support
(based on the docs provided under NDA) but ironically enough I didn't
have an RC6 remote kicking around so I didn't do the support for it.

IR receivers for MCE devices are dirt cheap (< $20), and if you're
doing a media center then it's likely the PCTV 290e probably isn't in
line-of-site for a remote anyway.  That said, if you still really want
to see it supported I can probably find a couple of hours to do it (or
walk Mauro through the register differences if he cares to).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
