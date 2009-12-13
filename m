Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:55667 "HELO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753460AbZLMTEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2009 14:04:05 -0500
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id F0A5194013B
	for <linux-media@vger.kernel.org>; Sun, 13 Dec 2009 20:04:00 +0100 (CET)
Received: from [192.168.15.210] (napalm.rochet.org [81.57.142.20])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 12F919400F3
	for <linux-media@vger.kernel.org>; Sun, 13 Dec 2009 20:03:58 +0100 (CET)
Subject: Re: [linux-dvb] Is there somobody dealing with DVB cards here ?!?
From: dvblinux <dvblinux@free.fr>
Cc: linux-media@vger.kernel.org
In-Reply-To: <a3ef07920912131059s79e5cefbw7b42d6b698996c5d@mail.gmail.com>
References: <267bb6670912120230m59eeeeffqc52cfb320ac05ec2@mail.gmail.com>
	 <200912121359.16169.liplianin@me.by>
	 <1260633864.2329.4.camel@hercules.rochet.org>
	 <a3ef07920912122043u2aaec2c6vd3d5296cdaae4c22@mail.gmail.com>
	 <1260729576.2469.5.camel@hercules.rochet.org>
	 <a3ef07920912131059s79e5cefbw7b42d6b698996c5d@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Dec 2009 20:03:16 +0100
Message-Id: <1260730996.2469.8.camel@hercules.rochet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I first have to learn what is and how to "create a patch" since I only
used my vi to modify the source of the driver and then recompiled it...

Thanks for the answers.

Regards.


Le dimanche 13 décembre 2009 à 10:59 -0800, VDR User a écrit :
> On Sun, Dec 13, 2009 at 10:39 AM, dvblinux <dvblinux@free.fr> wrote:
> > My question was specific:
> 
> Asking if people deal with DVB-T/DVB-S is really generic.  There's
> nothing specific about it.  See below.
> 
> > Support for device ASUS (1043:48cd) lacks in current saa driver;
> >
> > I managed to make it work by modifying current version, since it's a
> > clone of ASUS (1043:4876) device;
> >
> > How could I share this, if this list is the relevant audience of
> > linux-dvb stuff.
> >
> > Perhaps this list is NOT the right place to deal with dvb driver
> > development, I don't know.
> 
> You should have posted all this the first time but to answer your
> questions..  Create a patch and post it with an explanation of what it
> does.  Someone will likely sign-off on it as long as there's no
> problems.  Yes, this is the right list for media-related things.
> 
> Regards.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


