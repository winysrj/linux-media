Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:4574 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab3HEHpN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 03:45:13 -0400
From: =?ISO-8859-1?Q?B=E5rd?= Eirik Winther <bwinther@cisco.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH 3/5] qv4l2: add ALSA stream to qv4l2
Date: Mon, 05 Aug 2013 09:45:09 +0200
Message-ID: <7603707.i76nSb2kXK@bwinther>
In-Reply-To: <51FC308A.1080406@googlemail.com>
References: <1375445137-19443-1-git-send-email-bwinther@cisco.com> <228d662aff38f8798b8bd23f1e8e4515b67dc03b.1375445112.git.bwinther@cisco.com> <51FC308A.1080406@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday, August 03, 2013 12:19:54 AM you wrote:
> Hello,
> 
> > diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
> > index 22d4c17..eed25b0 100644
> > --- a/utils/qv4l2/Makefile.am
> > +++ b/utils/qv4l2/Makefile.am
> > @@ -4,7 +4,8 @@ qv4l2_SOURCES = qv4l2.cpp general-tab.cpp ctrl-tab.cpp vbi-tab.cpp v4l2-api.cpp
> >     capture-win-qt.cpp capture-win-qt.h capture-win-gl.cpp capture-win-gl.h \
> >     raw2sliced.cpp qv4l2.h capture-win.h general-tab.h vbi-tab.h v4l2-api.h raw2sliced.h
> >   nodist_qv4l2_SOURCES = moc_qv4l2.cpp moc_general-tab.cpp moc_capture-win.cpp moc_vbi-tab.cpp qrc_qv4l2.cpp
> > -qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../libv4l2util/libv4l2util.la
> > +qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../libv4l2util/libv4l2util.la \
> > +  ../libmedia_dev/libmedia_dev.la
> >
> >   if WITH_QV4L2_GL
> >   qv4l2_CPPFLAGS = $(QTGL_CFLAGS) -DENABLE_GL
> > @@ -14,6 +15,12 @@ qv4l2_CPPFLAGS = $(QT_CFLAGS)
> >   qv4l2_LDFLAGS = $(QT_LIBS)
> >   endif
> >
> > +if WITH_QV4L2_ALSA
> > +qv4l2_CPPFLAGS += $(ALSA_CFLAGS) -DENABLE_ALSA
> 
> I would prefer if you don't add another define to the command line. To 
> check for ALSA support please include config.h and use the flag provided 
> there.

That is fine for me. However, this design was to make the alsa code not compile in when not required.

While I am at it, should I do the same for OpenGL, that is, remove WITH_QV4L2_GL with a config.h define)? The patch series has already been patched in, but I do have another series that adds features and fixes to the first OpenGL patches. It should not be a problem to change OpenGL accordingly as well.

B.

> 
> Thanks,
> Gregor
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
