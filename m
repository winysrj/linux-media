Return-path: <mchehab@pedra>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:42044 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752869Ab1EZDKa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 23:10:30 -0400
Date: Wed, 25 May 2011 20:10:27 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3] [media] DocBook: Add rules to auto-generate some
 media docbook
Message-Id: <20110525201027.57e2acc4.rdunlap@xenotime.net>
In-Reply-To: <20110525122642.7b4f381f@pedra>
References: <96c3a1277523b929bd27f5d68d5f40e2a0e5bdf3.1306337174.git.mchehab@redhat.com>
	<20110525122642.7b4f381f@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 25 May 2011 12:26:42 -0300 Mauro Carvalho Chehab wrote:

> Auto-generate the videodev2.h.xml,frontend.h.xml and the indexes.
> 
> Some logic at the Makefile helps us to identify when a symbol is missing,
> like for example:
> 
> Error: no ID for constraint linkend: V4L2-PIX-FMT-JPGL.


a.  Still get that message..  is that OK?

b.  In the generated index.html file, "media" is listed first, but it should be
listed in alphabetical order, not first.

c.  The generated files are (hidden) in .tmpmedia/

d.  The link from the top-level index.html file to "media" is to
media/index.html, but the file is actually in .tmpmedia/media/index.html

e.  patches 1/3 and 2/3 are OK.


Please build docs with and without using "O=builddir" and test that.

I'm looking over the generated output now and will let you know if I see
any other problems.



> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  delete mode 100644 Documentation/DocBook/dvb/frontend.h.xml
>  delete mode 100644 Documentation/DocBook/media-indices.tmpl
>  delete mode 100644 Documentation/DocBook/v4l/videodev2.h.xml

diffstat:
 Documentation/DocBook/Makefile            |  279 ++
 Documentation/DocBook/dvb/frontend.h.xml  |  428 ----
 Documentation/DocBook/media-indices.tmpl  |   89 
 Documentation/DocBook/v4l/videodev2.h.xml | 1946 --------------------
 4 files changed, 258 insertions(+), 2484 deletions(-)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
