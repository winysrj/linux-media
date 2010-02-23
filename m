Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f189.google.com ([209.85.210.189]:39933 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0BWIEt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 03:04:49 -0500
Received: by yxe27 with SMTP id 27so191317yxe.21
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 00:04:47 -0800 (PST)
Date: Tue, 23 Feb 2010 00:04:37 -0800
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>,
	christophpfister@gmail.com
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
Message-ID: <20100223080437.GE4013@jenkins.home.ifup.org>
References: <4B55445A.10300@infradead.org>
 <4B5B30E4.7030909@redhat.com>
 <20100222225426.GC4013@jenkins.home.ifup.org>
 <201002230026.59712.hverkuil@xs4all.nl>
 <20100222233808.GD4013@jenkins.home.ifup.org>
 <4B83242E.40703@infradead.org>
 <4B832B61.30909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B832B61.30909@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22:12 Mon 22 Feb 2010, Mauro Carvalho Chehab wrote:
> Mauro Carvalho Chehab wrote:
> >> According to the wiki[1] these tools are without a maintainer. So, if
> >> no one cares about them enough to make releases why merge them and
> >> clutter up the git tree with dead code?
> >>
> >> [1] http://www.linuxtv.org/wiki/index.php/LinuxTV_dvb-apps
> > 
> > That's weird. I've recently added support for ISDB-T on it:
> > 	http://linuxtv.org/hg/~mchehab/dvb-apps-isdbt2/
> > 
> > and we've got some comments at the mailing list. Btw, the patches
> > I added there also adds DVB-S2 support to szap/scan, but tests
> > are needed, since I don't have any satellite dish nowadays.
> > 
> 
> That's said, if all the issues are the ones listed above, I can try
> to address them on the next months, to put it into a better
> shape. That's said, I don't think we should have a single maintainer
> for it: there are too many DTV standards already, and probably
> nobody with enough time has access to all of those (DVB-T, DVB-T2,
> DVB-S, DVB-S2, ISDB-T, ISDB-S, ATSC, DSS, ...).  So, I think we need
> a team of volunteers that will try to help with the standards they
> have access.

I was not suggesting a single maintainer but I wanted to make sure
there was actual interest in maintaing and fixing these dvb things. I
don't interact much at all with DVB so all I had to go on was the wiki
page.

> That's said, I'm starting to agree with Hans: maybe the better seems
> to merge it with v4l2-apps, to get synergy in terms, at least in
> terms of packet management.
> 
> Comments?

Seems reasonable to me. I would be willing to be the merge point for
all of the various maintainers of dvb and v4l things and release
manager for making the actual tar.gz releases.

I wrote up the conversion for dvb-apps too. The merge of the two trees
conflict pretty trivially so it should be easy to clean up if we go
this route:

#	unmerged:   COPYING
#	unmerged:   INSTALL
#	unmerged:   Make.rules
#	unmerged:   Makefile
#	unmerged:   README
#	unmerged:   lib/Makefile
#	unmerged:   utils/Makefile

If you want to give it a whirl.

  git clone git://ifup.org/philips/create-v4l-utils.git
  cd create-v4l-utils/
  git checkout -b dvb-apps-too origin/dvb-apps-too
  ./convert.sh 

The result will be in step3 with the merge conflicts.

Cheers,

	Brandon
