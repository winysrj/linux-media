Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726Ab0BWBMK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 20:12:10 -0500
Message-ID: <4B832B61.30909@redhat.com>
Date: Mon, 22 Feb 2010 22:12:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Brandon Philips <brandon@ifup.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>,
	christophpfister@gmail.com
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <4B5B30E4.7030909@redhat.com> <20100222225426.GC4013@jenkins.home.ifup.org> <201002230026.59712.hverkuil@xs4all.nl> <20100222233808.GD4013@jenkins.home.ifup.org> <4B83242E.40703@infradead.org>
In-Reply-To: <4B83242E.40703@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
>> According to the wiki[1] these tools are without a maintainer. So, if
>> no one cares about them enough to make releases why merge them and
>> clutter up the git tree with dead code?
>>
>> [1] http://www.linuxtv.org/wiki/index.php/LinuxTV_dvb-apps
> 
> That's weird. I've recently added support for ISDB-T on it:
> 	http://linuxtv.org/hg/~mchehab/dvb-apps-isdbt2/
> 
> and we've got some comments at the mailing list. Btw, the patches
> I added there also adds DVB-S2 support to szap/scan, but tests
> are needed, since I don't have any satellite dish nowadays.
> 

Hmm... this got changed on Jun, 2009:

http://www.linuxtv.org/wiki/index.php?title=LinuxTV_dvb-apps&diff=prev&oldid=23404

Let me comment the "TODO" list:

    * Start numbering the versions. Yes, with a repo every commit is a kind of version, but in the real world of 
      distros and end users you need to define version numbers as easy reference points.
    * Tag versioned releases and make src tarballs for the distros.

By merging with v4l2-apps, those to will be easily handled.

    * Add ChangeLog and TODO files (and keep them up to date of course).

ChangeLog? Git history is better than it. A TODO file is useful only when there
are missing features.

    * Review the names of the apps and change where necessary. Perhaps scan is too ambiguous a name in a
 	general-purpose system where all sorts of things can be scanned 
	(with scanners, fax machines, barcode readers, etc.).

I agree. All distros I know renamed scan to dvbscan. This is a trivial patch through.

    * Implement API version 5 scanning and zapping for DVB-S2 channels. See S2API, scan-s2 and szap-s2.

It is done on my tree: http://linuxtv.org/hg/~mchehab/dvb-apps-isdbt2/
I still need to review Manu's comments on it. My intention is to do it after
the next merge window. Also, there are some DVB-S2 parameters that aren't present
at the channels.conf format. Nothing more complex than adding printf/scanf lines on
some files.

    * Improve the channels.conf file format so that one file can represent all the channels. Need to
          o (a) identify the source (S13.0E, S19.2E, Terrestrial, etc)
          o (b) identify the delivery system (DVB-S, DVB-S2, DVB-T etc)
          o (c) be able to represent all the parameters required for all the delivery systems
		 in a unified way. For example DVB-S2 has some new paramters (e.g. rolloff). 
		The "VDR" format was expanded for this, but in a messy way. 
    * Make sure there is one true format -- no "zap" versus "VDR" format confusion.
    * Merge all the *zap programs. You unified the channels.conf file so this is next. 

Changing the channels.conf format is easy. I had to do it for ISDB-T. The hard part is that
channels.conf is used on several DTV applications (mplayer, VDR, kaffeine, ...). So, any format
change will require changes on all applications that use channels.conf. This will be needed 
anyway, in order to add all features that are present on DVB-S2, and to
add ISDB-T format to the players. So, maybe someone can propose a "version 3" format (assuming
that VDR and ZAP are versions 1 and 2) that will be used by all applications.

That's said, if all the issues are the ones listed above, I can try to address them on the next
months, to put it into a better shape. That's said, I don't think we should have a single
maintainer for it: there are too many DTV standards already, and probably nobody with enough
time has access to all of those (DVB-T, DVB-T2, DVB-S, DVB-S2, ISDB-T, ISDB-S, ATSC, DSS, ...).
So, I think we need a team of volunteers that will try to help with the standards they have
access.

For the channels/transponders list, Christopher (kaffeine maintainer) is doing a really great
job. Maybe he could help with the last TODO items (e. g. helping to define the better format
for the channels.conf output).

That's said, I'm starting to agree with Hans: maybe the better seems to merge it with
v4l2-apps, to get synergy in terms, at least in terms of packet management.

Comments?

Cheers,
Mauro
