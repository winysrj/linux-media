Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44240 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab0BWVWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 16:22:10 -0500
Received: by bwz1 with SMTP id 1so1418443bwz.21
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 13:22:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B8445F2.40008@linuxstation.net>
References: <20091007101142.3b83dbf2@glory.loctelecom.ru>
	 <200912160849.17005.hverkuil@xs4all.nl>
	 <20100112172209.464e88cd@glory.loctelecom.ru>
	 <201001130838.23949.hverkuil@xs4all.nl>
	 <20100127143637.26465503@glory.loctelecom.ru>
	 <4B83076A.3010409@ctecworld.com>
	 <829197381002221452k793be9d2l8f7ec3638233ecd0@mail.gmail.com>
	 <4B837790.6060007@linuxstation.net>
	 <829197381002230846m4ad70c46o2ec9b9935d9b8bc3@mail.gmail.com>
	 <4B8445F2.40008@linuxstation.net>
Date: Tue, 23 Feb 2010 16:22:05 -0500
Message-ID: <829197381002231322x71e15b46r38994dbe58b72daf@mail.gmail.com>
Subject: Re: eb1a:2860 eMPIA em28xx device to usb1 ??? usb hub problem?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Dean <red1@linuxstation.net>
Cc: j <jlafontaine@ctecworld.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 23, 2010 at 4:17 PM, Dean <red1@linuxstation.net> wrote:

> I am receiving NTSC TV signals.  I test with mplayer.  Example;
>
> mplayer tv://9 -tv driver=v4l2:alsa:immediatemode=0:adevice=hw.Em28xxAudio,0:norm=ntsc:chanlist=us-cable -vf pp=ci
>
> The above command works fine (both audio and video) with my Hauppauge HVR-850, but for the Kworld 305U I must change 'immediatemode=0' to 'immediatemode=1' otherwise the video frame rate is about 1/2 normal speed and about 1 minute later mplayer starts printing 'video buffer full - dropping frame'.
>
> According to dmesg the Kworld 305U loads the same firmware as my Hauppauge HVR-850, and (during separate test sessions) installs the same ALSA device;
>
> card 1: Em28xxAudio [Em28xx Audio], device 0: Em28xx Audio [Empia 28xx Capture]
>  Subdevices: 0/1
>  Subdevice #0: subdevice #0

Try this:  open em28xx-cards.c, and change the board profile for the
entry EM2880_BOARD_KWORLD_DVB_305U such that it includes the following
field:

.mts_firmware = 1,

Then recompile and see if it starts working.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
