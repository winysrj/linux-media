Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50888 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754446AbZEZM6g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 08:58:36 -0400
Date: Tue, 26 May 2009 14:58:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans de Goede <hdegoede@redhat.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	moinejf@free.fr
Subject: Re: gspca: Logitech QuickCam Messenger worked last with external
 gspcav1-20071224
In-Reply-To: <4A1BE040.8020707@redhat.com>
Message-ID: <Pine.LNX.4.64.0905261457380.4810@axis700.grange>
References: <Pine.LNX.4.64.0905261335050.4810@axis700.grange>
 <4A1BD76E.4020603@redhat.com> <Pine.LNX.4.64.0905261404290.4810@axis700.grange>
 <4A1BE040.8020707@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 26 May 2009, Hans de Goede wrote:

> 
> 
> On 05/26/2009 02:08 PM, Guennadi Liakhovetski wrote:
> > On Tue, 26 May 2009, Hans de Goede wrote:
> > 
> > > First of all, which app are you using to test the cam ? And are you using
> > > that
> > > app in combination with libv4l ?
> > 
> > xawtv, no, it doesn't use libv4l, but it works with the old
> > gspcav1-20071224. Ok, maybe it used a different v4l version, but I have
> > v4l1_compat loaded.
> > 
> 
> xawtv has known bugs making it not work with gspca (or many other
> properly implemented v4l drivers that is). Now those bugs are fixed in
> some distro's but this might very well be the cause. Try using ekiga
> (together with LD_PRELOAD=..../v4l1compat.so)

Coooooool! Loading the driver without parameters and using

LD_LIBRARY_PATH="v4l2-apps/libv4l/libv4l1/:v4l2-apps/libv4l/libv4l2/:v4l2-apps/libv4l/libv4lconvert/" \
LD_PRELOAD=v4l2-apps/libv4l/libv4l1/v4l1compat.so mplayer tv:// -tv \
driver=v4l:device=/dev/video0 -vo x11

started the video! Thanks a million, Hans!

Cheers
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
