Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39404 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab1BXU1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 15:27:11 -0500
Received: by bwz15 with SMTP id 15so1401066bwz.19
        for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 12:27:10 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 5/9 v2] ds3000: clean up in tune procedure
Date: Thu, 24 Feb 2011 22:27:07 +0200
Cc: linux-media@vger.kernel.org
References: <201102020040.49656.liplianin@me.by> <4D66AD51.6090608@redhat.com> <201102242225.35913.liplianin@me.by>
In-Reply-To: <201102242225.35913.liplianin@me.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102242227.07515.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В сообщении от 24 февраля 2011 22:25:35 автор Igor M. Liplianin написал:
> В сообщении от 24 февраля 2011 21:11:13 автор Mauro Carvalho Chehab написал:
> > Em 24-02-2011 16:04, Mauro Carvalho Chehab escreveu:
> > > Hi Igor,
> > > 
> > > Em 01-02-2011 20:40, Igor M. Liplianin escreveu:
> > >> Variable 'retune' does not make sense.
> > >> Loop is not needed for only one try.
> > >> Remove unnecessary dprintk's.
> > >> 
> > >> Signed-off-by: Igor M. Liplianin <liplianin@me.by>
> > > 
> > > This patch didn't apply. Please fix and resend.
> > 
> > PS.: I won't try to apply patches 7, 8 and 9, as they are all related to
> > tune changes. They'll probably fail to apply, and, even if not failing or
> > if I fix the conflicts, they may be breaking the driver. So, please put
> > them on your next patch series.
> > 
> > thanks!
> > Mauro
> 
> Hi Mauro,
> 
> Will do tonight.
> 
> BTW, Why did you dropp/miss dw2102 patches?
> They was sent before ds3000 series.
Do I must resend them?

> 
> Thank you in advance.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
