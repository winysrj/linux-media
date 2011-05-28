Return-path: <mchehab@pedra>
Received: from yop.chewa.net ([91.121.105.214]:46553 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab1E1Mzd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 08:55:33 -0400
Received: from basile.remlab.net (cs27062010.pp.htv.fi [89.27.62.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by yop.chewa.net (Postfix) with ESMTPSA id 376C1C8
	for <linux-media@vger.kernel.org>; Sat, 28 May 2011 14:55:32 +0200 (CEST)
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
Date: Sat, 28 May 2011 15:55:27 +0300
References: <4DDAC0C2.7090508@redhat.com> <4DDB5C6B.6000608@redhat.com> <4DDBBC29.80009@infradead.org>
In-Reply-To: <4DDBBC29.80009@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105281555.28285.remi@remlab.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Le mardi 24 mai 2011 17:09:45 Mauro Carvalho Chehab, vous avez écrit :
> If we do that, then all other places where the association between an alsa
> device and a video4linux node is needed will need to copy it, and we'll
> have a fork. Also, we'll keep needing it at v4l-utils, as it is now needed
> by the new version of v4l2-sysfs-path tool.
> 
> Btw, this lib were created due to a request from the vlc maintainer that
> something like that would be needed. After finishing it, I decided to add
> it at xawtv in order to have an example about how to use it.

Hmm errm, I said VLC would need to be able to match a V4L2 device to an ALSA 
input (where applicable). Currently, V4L2 devices are enumerated with 
(lib)udev though. I am not very clear how v4l2-utils fits there (and oh, ALSA 
is a bitch for udev-hotplugging but I'm getting side tracked).

I guess I misunderstood that /dev/media would logically group related devices.  
Now I guess it is _solely_ intended to plug DSPs together à la OpenMAX IL. 
Sorry about that.

> > Mauro, I plan to do a new v4l-utils release soon (*), maybe even today. I
> > consider it unpolite to revert other peoples commits, so I would prefer
> > for you to revert the install libv4l2util.a patch yourself. But if you
> > don't (or don't get around to doing it before I do the release), I will
> > revert it, as this clearly needs more discussion before making it into
> > an official release tarbal (we can always re-introduce the patch after
> > the release).
> 
> I'm not a big fan or exporting the rest of stuff at libv4l2util.a either,
> but I think that at least the get_media_devices stuff should be exported
> somewhere, maybe as part of libv4l.

Should it be exposed as a udev device attribute instead then?

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
