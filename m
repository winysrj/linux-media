Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:37297 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbZB0NWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 08:22:23 -0500
Received: from mail-in-10-z2.arcor-online.net (mail-in-10-z2.arcor-online.net [151.189.8.27])
	by mx.arcor.de (Postfix) with ESMTP id 3357F39A7F0
	for <linux-media@vger.kernel.org>; Fri, 27 Feb 2009 14:22:16 +0100 (CET)
Received: from mail-in-12.arcor-online.net (mail-in-12.arcor-online.net [151.189.21.52])
	by mail-in-10-z2.arcor-online.net (Postfix) with ESMTP id 12DC223D30E
	for <linux-media@vger.kernel.org>; Fri, 27 Feb 2009 14:22:16 +0100 (CET)
Received: from webmail14.arcor-online.net (webmail14.arcor-online.net [151.189.8.67])
	by mail-in-12.arcor-online.net (Postfix) with ESMTP id DF0301B3A26
	for <linux-media@vger.kernel.org>; Fri, 27 Feb 2009 14:22:15 +0100 (CET)
Message-ID: <32779969.1235740935861.JavaMail.ngmail@webmail14.arcor-online.net>
Date: Fri, 27 Feb 2009 14:22:15 +0100 (CET)
From: schollsky@arcor.de
To: linux-media@vger.kernel.org
Subject: W.: v4l-dvb won't compile with new version
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
References: <12645682.1235740797539.JavaMail.ngmail@webmail10.arcor-online.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

this I get when trying to compile latest mercurial .tar.gz:

/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c: In function 'tvmixer_ioctl':
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:78: error: storage size of 'va' isn't known
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:114: error: 'VIDIOCGAUDIO' undeclared (first use in this function)
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:114: error: (Each undeclared identifier is reported only once
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:114: error: for each function it appears in.)
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:129: error: 'VIDEO_AUDIO_BASS' undeclared (first use in this function)
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:131: error: 'VIDEO_AUDIO_TREBLE' undeclared (first use in this function)
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:142: error: 'VIDEO_AUDIO_MUTE' undeclared (first use in this function)
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:143: error: 'VIDIOCSAUDIO' undeclared (first use in this function)
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:147: warning: type defaults to 'int' in declaration of '_min1'
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:149: warning: type defaults to 'int' in declaration of '_min1'
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:149: warning: comparison of distinct pointer types lacks a cast
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:78: warning: unused variable 'va'
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c: In function 'tvmixer_clients':
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:254: error: storage size of 'va' isn't known
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:286: error: 'VIDIOCGAUDIO' undeclared (first use in this function)
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:288: error: 'VIDEO_AUDIO_VOLUME' undeclared (first use in this function)
/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.c:254: warning: unused variable 'va'
make[3]: *** [/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l/tvmixer.o] Error 1
make[2]: *** [_module_/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.29-desktop-0.rc6.1.1mnb'
make[1]: *** [default] Fehler 2
make[1]: Leaving directory `/home/stefan/Linux/v4l-dvb-60389ff5e931/v4l'
make: *** [all] Fehler 2

Any hints please?

