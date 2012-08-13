Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2720 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2HMSf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 14:35:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] DocBook validation fixes
Date: Mon, 13 Aug 2012 20:35:50 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201208121402.37719.hverkuil@xs4all.nl> <5029414E.7000809@redhat.com>
In-Reply-To: <5029414E.7000809@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208132035.50308.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon August 13 2012 20:02:54 Mauro Carvalho Chehab wrote:
> Em 12-08-2012 09:02, Hans Verkuil escreveu:
> > More validation fixes as reported by xmllint.
> > 
> > There are still three xmllint errors remaining after this patch regarding SVG file support.
> 
> How are you running xmllint? It could be useful to have a make target
> (if it doesn't have it yet), in order for developers (and for me, when
> checking patches) to run it.

I use this script to build the documentation:

====== gitdocs.sh ==========
#!/bin/sh

make DOCBOOKS=media_api.xml htmldocs
xmllint --noent --postvalid "/home/hans/work/src/v4l/media-git/Documentation/DocBook/media_api.xml" >/tmp/x.xml 2>/dev/null
xmllint --noent --postvalid --noout /tmp/x.xml
xmlto html-nochunks -m Documentation/DocBook/stylesheet.xsl -o Documentation/DocBook/media Documentation/DocBook/media_api.xml --skip-validation

echo file:///home/hans/work/src/v4l/media-git/Documentation/DocBook/media/media_api.html
====== gitdocs.sh ==========

I use this to build the documentation in one large file (that's what the daily
build does as well). I prefer that to the 'chunky' version and the validation works
better as well.

If you run xmlto without the --skip-validation at the end, then xmlto will run
xmllint by itself. Unfortunately, the file and line numbers it report are all out
of sync and they make it next to impossible to track down where an error occurs.

So I finally figured out this weekend how to run xmllint separately in such a way
that I can related the line numbers to actual docbook code.

That's why you see the first xmllint call generating a /tmp/x.xml file, and the
second is parsing it.

The last 'echo' is just to print where the generated doc is so I can easily open
it with my browser :-)

Regards,

	Hans
