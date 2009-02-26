Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:52500 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbZBZLKM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 06:10:12 -0500
Date: Thu, 26 Feb 2009 12:01:32 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Auke Kok <auke@foo-projects.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, rossi.f@inwind.it,
	linux-media@vger.kernel.org
Subject: Re: zc3xx: "Creative Webcam Live!" never worked with in-tree driver
Message-ID: <20090226120132.409a1026@free.fr>
In-Reply-To: <49A65827.9040306@foo-projects.org>
References: <49A4616A.10207@foo-projects.org>
	<49A48A3B.4090509@foo-projects.org>
	<20090224211916.249e15cf@pedra.chehab.org>
	<20090226092058.35ab847c@free.fr>
	<49A65827.9040306@foo-projects.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 26 Feb 2009 00:51:51 -0800
Auke Kok <auke@foo-projects.org> wrote:

> > Eventually, the v4l library is needed when using any v4l2 driver,
> > not only gspca. Hopefully, many popular applications now use it
> > natively, as vlc 0.9.x.  
> 
> interesting, but I can't get vlc to understand either tv:// or 
> /dev/video0... any hints?

You may find the command line syntax opening the device/file/network
flow with the GUI. For webcams, I found:

	vlc v4l2:// :v4l2-dev=/dev/video0 :v4l2-standard=0

You may also start the webcam from a playlist with:

	#EXTINF:0,webcam
	#EXTVLCOPT:v4l2-dev=/dev/video0
	#EXTVLCOPT:v4l2-standard=0
	v4l2://

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
