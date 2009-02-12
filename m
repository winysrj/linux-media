Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:42337 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757901AbZBLS6l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2009 13:58:41 -0500
Date: Thu, 12 Feb 2009 19:42:42 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: video4linux-list@redhat.com
Cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: v4l2 and skype
Message-ID: <20090212194242.17ae6abb@free.fr>
In-Reply-To: <36c518800902111042j2fd8db53q58d7e3960d26120c@mail.gmail.com>
References: <36c518800902111042j2fd8db53q58d7e3960d26120c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Feb 2009 20:42:07 +0200
vasaka@gmail.com wrote:

> hello, I am writing v4l2 loopback driver and now it is at working
> stage. for now it can feed mplayer and luvcview, but silently fails
> with skype it just shows green screen while buffer rotation is going
> on. can you help me with debug? I think I missing small and obvious
> detail. Is there something special about skype way of working with
> v4l2?

Hello Vasily,

I think skype is not v4l2. Also, I don't know about the frames you send
to it, but I know it does not understand JPEG.

> loopback is here:
> http://code.google.com/p/v4l2loopback/source/checkout
> I am feeding it with this app
> http://code.google.com/p/v4lsink/source/checkout
> this is the simple gstreamer app which takes data from /dev/video0 and
> puts it to /dev/video1 which should be my loopback device.

I did not look at your code, but it may be interesting for usermode
drivers...

BTW, don't use the video4linux-list@redhat.com mailing list. The new
list is in the Cc: field.

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
