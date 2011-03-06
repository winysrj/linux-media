Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37978 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1CFM6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 07:58:44 -0500
Received: by fxm17 with SMTP id 17so3373611fxm.19
        for <linux-media@vger.kernel.org>; Sun, 06 Mar 2011 04:58:42 -0800 (PST)
Date: Sun, 6 Mar 2011 13:51:33 +0100
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: Patches an media build tree
Message-ID: <20110306135133.693758ab@grobi>
In-Reply-To: <AANLkTi=2fN-qWN9zovwGwcNqfA0ogA1u3KCr7oD9CZMg@mail.gmail.com>
References: <4D31A520.2050703@helmutauer.de>
	<4D333AF2.8070806@redhat.com>
	<20110305164309.1796daad@grobi>
	<AANLkTi=2fN-qWN9zovwGwcNqfA0ogA1u3KCr7oD9CZMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 6 Mar 2011 17:23:11 +0530
Manu Abraham <abraham.manu@gmail.com> wrote:

> Hi Steffen,

Hi Manu , 

thx for the reply :) 

> On Sat, Mar 5, 2011 at 9:13 PM, Steffen Barszus
> > Manu , Mauro please comment ! Thanks !
> >
> > Avoid unnecessary data copying inside dvb_dmx_swfilter_204()
> > function 2010-08-07      Marko Ristola           Under Review
> > Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt
> >        2010-08-07      Marko Ristola           Under Review
> 
> 
> I had tried this patch a while back, but due to some reason it was
> causing a complete freeze at my side: it could have been due to a
> different version of the bridge or so, But it wasn't really easy on my
> side to ascertain that. That time looking at the patch it wasn't easy
> to identify the reason as well. I need to retry the same again, with a
> cooler head as to see what happens.

That would be good, as far as i remember - the issue is, without these
patches the driver crashes after a while caused by vdr's excessive use
by EIT scanner. So it can only be used without EPG scan enabled. With
that it was running stable. There have been a few different patches
floating around to address this issue.  

> > [v2] V4L/DVB: faster DVB-S lock for mantis cards using stb0899 demod
> >        2010-10-10      Tuxoholic               Under Review
> >
> 
> I was under the assumption that this issue was fixed in the right way,
> with the fix being applied to the stb6100 driver sometime back. Was
> your test with that fix in ?

Think i did not put it into relation. 

Let me get to the users of the cards, to test the current dkms [1] w/o
any patches and confirm back to you whats current situation
It was this one: 

commit f14bfe94e459cb070a489e1786f26d54e9e7b5de
Author: Manu Abraham <abraham.manu@gmail.com>
Date:   Sun Nov 14 15:52:10 2010 -0300

    [media] stb6100: Improve tuner performance

right ?

Kind Regards

Steffen

[1] Test version of the dkms, need to remove above named patches
tomorrow. Will remove the above patches again for testing, then its
except for a small fix for more then on TT S2 1600 plain media_tree. 
https://launchpad.net/~yavdr/+archive/testing-vdr/+packages?field.name_filter=v4l-dvb-dkms&field.status_filter=published&field.series_filter=
