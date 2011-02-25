Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57187 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1BYRh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 12:37:59 -0500
Received: by bwz15 with SMTP id 15so2149563bwz.19
        for <linux-media@vger.kernel.org>; Fri, 25 Feb 2011 09:37:58 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 5/9 v2] ds3000: clean up in tune procedure
Date: Fri, 25 Feb 2011 19:37:30 +0200
Cc: linux-media@vger.kernel.org
References: <201102020040.49656.liplianin@me.by> <201102242225.35913.liplianin@me.by> <4D66EAD5.70603@redhat.com>
In-Reply-To: <4D66EAD5.70603@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102251937.30307.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В сообщении от 25 февраля 2011 01:33:41 автор Mauro Carvalho Chehab написал:
> Em 24-02-2011 17:25, Igor M. Liplianin escreveu:
> > В сообщении от 24 февраля 2011 21:11:13 автор Mauro Carvalho Chehab написал:
> >> Em 24-02-2011 16:04, Mauro Carvalho Chehab escreveu:
> >>> Hi Igor,
> >>> 
> >>> Em 01-02-2011 20:40, Igor M. Liplianin escreveu:
> >>>> Variable 'retune' does not make sense.
> >>>> Loop is not needed for only one try.
> >>>> Remove unnecessary dprintk's.
> >>>> 
> >>>> Signed-off-by: Igor M. Liplianin <liplianin@me.by>
> >>> 
> >>> This patch didn't apply. Please fix and resend.
> >> 
> >> PS.: I won't try to apply patches 7, 8 and 9, as they are all related to
> >> tune changes. They'll probably fail to apply, and, even if not failing
> >> or if I fix the conflicts, they may be breaking the driver. So, please
> >> put them on your next patch series.
> >> 
> >> thanks!
> >> Mauro
> > 
> > Hi Mauro,
> > 
> > Will do tonight.
> 
> OK.
> 
> > BTW, Why did you dropp/miss dw2102 patches?
> > They was sent before ds3000 series.
> 
> I probably missed, or they are still on my queue. While in general I apply
> patches in order, sometimes I reorder them, trying to merge first the more
> trivial ones (or the ones that I had already analyzed, like the altera
> ones). Please take a look at Patchwork. If they're there, then I'll
> probably be handling until the weekend. Otherwise, just re-send them to
> me.
Patches you already included are OK, but 5 to 9 needs(and depend) to be applied after dw2102 
series. I can rebase in differend order, but what's a matter?
I will create git tree somwere (probably at assembla), push there and send you pull request.

> 
> That's said, it is probably a good idea if you could have a git repository
> somewhere to send me patches. Git works better when there are lots of
> patches, so, works better for driver maintainers. If you want, I may
> create you an account at LinuxTV (or you may host it on any other place).
I will appreciate you very much if you create it for me, as I have a lot of stuff to commit.

Thank you in advance.
Igor
> 
> Thanks,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
