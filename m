Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:40944 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758012AbZJLUvB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 16:51:01 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MxRqZ-0008S5-Se
	for linux-media@vger.kernel.org; Mon, 12 Oct 2009 22:50:24 +0200
Received: from host147-107-dynamic.51-82-r.retail.telecomitalia.it ([82.51.107.147])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 22:50:23 +0200
Received: from gborzi by host147-107-dynamic.51-82-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 22:50:23 +0200
To: linux-media@vger.kernel.org
From: Giuseppe Borzi <gborzi@gmail.com>
Subject: Re: Dazzle TV Hybrid USB and em28xx
Date: Mon, 12 Oct 2009 20:49:57 +0000 (UTC)
Message-ID: <loom.20091012T223603-551@post.gmane.org>
References: <loom.20091011T180513-771@post.gmane.org> <829197380910111218q5739eb5ex9a87f19899a13e98@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller <dheitmueller <at> kernellabs.com> writes:

> 
> Hello Giuseppe,
> 
> 
> Make sure you have the latest v4l-dvb code installed.  The changes for
> that board went in relatively recently (make sure you do *not* specify
> a card= modprobe parameter).
> 
> http://linuxtv.org/repo
> 
> > But analog TV has no audio (I've tried sox/arecord-aplay),
> 
> Make sure you have the correct standard selected.  This sort of thing
> often occurs when you are in an area with PAL support but you have the
> device configured for NTSC.
> 
> > teletext doesn't work (mtt segfaults) and DVB doesn't work too.
> 
> Teletext is not supported currently - I did the NTSC VBI support and
> am planning on doing the PAL support in the next couple of weeks.
> 
> > With me-tv I
> > get an error message like "Failed to tune to channel" and sometimes a
> > "timeout".
> 
> A fix for this was done this week (but hasn't been checked in yet).
> Check the linux-media archive for the PCTV 320e thread.
> 
> Devin
> 

Thanks for your prompt reply. I've downloaded v4l-dvb-5578cc977a13.tar.bz2, but
it fails to compile when it reaches firedtv-1394.c. The first part of the error
message is

/home/gborzi/v4l-dvb-5578cc977a13/v4l/firedtv-1394.c:21:17: error: dma.h: No 
such file or directory
/home/gborzi/v4l-dvb-5578cc977a13/v4l/firedtv-1394.c:22:21: error: csr1212.h: 
No such file or directory
/home/gborzi/v4l-dvb-5578cc977a13/v4l/firedtv-1394.c:23:23: error: highlevel.h: 
No such file or directory
/home/gborzi/v4l-dvb-5578cc977a13/v4l/firedtv-1394.c:24:19: error: hosts.h: No 
such file or directory
/home/gborzi/v4l-dvb-5578cc977a13/v4l/firedtv-1394.c:25:22: error: ieee1394.h: 
No such file or directory
/home/gborzi/v4l-dvb-5578cc977a13/v4l/firedtv-1394.c:26:17: error: iso.h: No 
such file or directory
/home/gborzi/v4l-dvb-5578cc977a13/v4l/firedtv-1394.c:27:21: error: nodemgr.h: 
No such file or directory

what follows are several warning and error messages about implicit declarations
and "dereferencing pointer to incomplete type" related to the lack of the above
include files.
I'll try again after configuring the compilation to avoid that error message, 
i.e. by compiling only the modules I need for em28xx.



