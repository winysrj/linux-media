Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4715 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0IVUUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 16:20:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] V4L documentation fixes
Date: Wed, 22 Sep 2010 22:19:40 +0200
Cc: linux-media@vger.kernel.org
References: <201009150923.50132.hverkuil@xs4all.nl> <4C9A5C0B.3040506@redhat.com> <201009222206.11694.hverkuil@xs4all.nl>
In-Reply-To: <201009222206.11694.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009222219.41034.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, September 22, 2010 22:06:11 Hans Verkuil wrote:
> On Wednesday, September 22, 2010 21:42:03 Mauro Carvalho Chehab wrote:
> > Em 15-09-2010 04:23, Hans Verkuil escreveu:
> > > The following changes since commit 57fef3eb74a04716a8dd18af0ac510ec4f71bc05:
> > >   Richard Zidlicky (1):
> > >         V4L/DVB: dvb: fix smscore_getbuffer() logic
> > > 
> > > are available in the git repository at:
> > > 
> > >   ssh://linuxtv.org/git/hverkuil/v4l-dvb.git misc2
> > > 
> > > Hans Verkuil (6):
> > >       V4L Doc: removed duplicate link
> > 
> > This doesn't seem right. the entry for V4L2-PIX-FMT-BGR666 seems to be duplicated.
> > We should remove the duplication, instead of just dropping the ID.
> 
> No, this patch is correct. This section really duplicates the formats due to
> confusion about the byte order in memory. But only one of these format tables
> should have a valid ID.
> 
> See table 2.4 and 2.5 here:
> 
> http://www.xs4all.nl/~hverkuil/spec/media.html#packed-rgb
> 
> As you can see here there is no BGR666 entry in either table since the docbook
> generation has been failing on this docbook error for some time now.

FYI: for the daily build I make a nochunks version of the docs like this:

make DOCBOOKS=media.xml htmldocs
xmlto html-nochunks -m Documentation/DocBook/stylesheet.xsl -o Documentation/DocBook/media Documentation/DocBook/media.xml

The second step finds some docbook bugs that the first step doesn't.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
