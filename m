Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:36073 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab1GQHjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 03:39:23 -0400
Received: from basile.remlab.net (cs27062010.pp.htv.fi [89.27.62.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by yop.chewa.net (Postfix) with ESMTPSA id 43024FE
	for <linux-media@vger.kernel.org>; Sun, 17 Jul 2011 09:39:22 +0200 (CEST)
From: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices bridge (ddbridge)
Date: Sun, 17 Jul 2011 10:39:17 +0300
References: <201107032321.46092@orion.escape-edv.de> <4E21B3EC.9060709@linuxtv.org> <4E223344.1080109@redhat.com>
In-Reply-To: <4E223344.1080109@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107171039.18383.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le dimanche 17 juillet 2011 03:56:36 Mauro Carvalho Chehab, vous avez écrit :
> >>> After all, you cannot connect both a DVB-C cable and a DVB-T antenna at
> >>> the same time, so the vast majority of users won't ever want to switch
> >>> modes at all.
> >> 
> >> You are wrong, actually you can. At least here in Finland some cable
> >> networks offers DVB-T too.
> 
> As Antti and Rémi pointed, there are issues with some cable operators. Not
> sure how critical is that, but an userspace application changing it via
> sysfs might work while the applications are not ported to support both
> ways.

Telling applications to use sysfs... I can see many ways that you might regret 
that in the future...

Accessing sysfs directly from an application is against all the good practices 
I thought I had learnt regarding Linux. There is the theoretical possibility 
that udev gets "explicit" support for Linux DVB and exposes the properties 
nicely. But that would be rather inconvenient, and cannot be used to change 
properties.

> Antti/Rémi, how the current applications work with one physical frontend
> supporting both DVB-T and DVB-C? Do they allow to change channels from one
> to the other mode on a transparent way?

I don't know. VLC does not care if you switch from DVB-T to DVB-C, to the DVD 
drive or to YouTube. Each channel (or at least each multiplex) is a different 
playlist item. So it'll close the all device nodes and (re)open them. There 
are obviously other applications at stake.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
