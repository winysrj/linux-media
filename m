Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2328 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZBPWBm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 17:01:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: wk <handygewinnspiel@gmx.de>
Subject: Re: DVB-API v5 questions and no dvb developer answering ?
Date: Mon, 16 Feb 2009 23:01:47 +0100
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
References: <4999A6DD.7030707@gmx.de> <412bdbff0902161133u22febbc7v9ca9173bb547bb99@mail.gmail.com> <4999DD20.5080801@gmx.de>
In-Reply-To: <4999DD20.5080801@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902162301.48049.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 16 February 2009 22:39:44 wk wrote:
> Devin Heitmueller wrote:
> > As always we continue to welcome patches, including for the
> > documentation.  Instead of bitching and moaning, how about you roll up
> > your sleeves and actually help out?
> >
> > Let's try to remember that pretty much all the developers here are
> > volunteers, so berating them for not doing things fast enough for your
> > personal taste is not really very productive.
> >
> > Regards,
> >
> > Devin
>
> Devin,
>
> can you please explain, how others should contribute to an dvb api if
> - the only DVB API file to be found is a pdf file, and therefore not
> editable. Which files exactly to be edited you are writing of?

10 minutes searching revealed that the sources are still available in the 
old CVS repository:

http://www.linuxtv.org/cgi-bin/viewcvs.cgi/DVB/doc/dvbapi/

So we need a volunteer to take this, merge it into the current v4l-dvb 
master repository (just as I did recently with the v4l2 API spec) and then 
start updating the docs bit by bit.

Regards,

	Hans

> - one doesn't know which ioctls exist for what function, which return
> codes and arguments, how to understand and to use..?
>
> What you suggest is almost impossible to someone not perfectly familiar
> with the drivers, only for dvb experts who have written at least a bunch
> of drivers.
> Its something different than sending patches for one single driver where
> some bug/improvement was found.
>
> On the other hand, in principle a driver without existing api doc is
> useless. Nobody can use it, the same for drivers with undocumented new
> features.
>
> Regards,
> Winfried
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
