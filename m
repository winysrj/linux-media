Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:58802 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab0BWVSA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 16:18:00 -0500
Message-ID: <4B8445F2.40008@linuxstation.net>
Date: Tue, 23 Feb 2010 13:17:38 -0800
From: Dean <red1@linuxstation.net>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Dean <red1@linuxstation.net>, j <jlafontaine@ctecworld.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: eb1a:2860 eMPIA em28xx device to usb1 ??? usb hub problem?
References: <20091007101142.3b83dbf2@glory.loctelecom.ru>	 <200912160849.17005.hverkuil@xs4all.nl>	 <20100112172209.464e88cd@glory.loctelecom.ru>	 <201001130838.23949.hverkuil@xs4all.nl>	 <20100127143637.26465503@glory.loctelecom.ru>	 <4B83076A.3010409@ctecworld.com>	 <829197381002221452k793be9d2l8f7ec3638233ecd0@mail.gmail.com>	 <4B837790.6060007@linuxstation.net> <829197381002230846m4ad70c46o2ec9b9935d9b8bc3@mail.gmail.com>
In-Reply-To: <829197381002230846m4ad70c46o2ec9b9935d9b8bc3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Tue, Feb 23, 2010 at 1:37 AM, Dean <red1@linuxstation.net> wrote:
>> Hi,
>>
>> I have the KWorld DVB-T 305U, an em28xx device.  Only the video works for me under Linux, no audio.  In case anyone wants to see it, I have attached the full dmesg text, solely from this device.
>>
>> Cheers,
>> Dean
> 
> Hi Dean,
> 
> How are you testing the audio, and under what video standard are you
> trying to use the device (NTSC/PAL/SECAM)?
> 
> Devin
>

Devin

I am receiving NTSC TV signals.  I test with mplayer.  Example;

mplayer tv://9 -tv driver=v4l2:alsa:immediatemode=0:adevice=hw.Em28xxAudio,0:norm=ntsc:chanlist=us-cable -vf pp=ci

The above command works fine (both audio and video) with my Hauppauge HVR-850, but for the Kworld 305U I must change 'immediatemode=0' to 'immediatemode=1' otherwise the video frame rate is about 1/2 normal speed and about 1 minute later mplayer starts printing 'video buffer full - dropping frame'.

According to dmesg the Kworld 305U loads the same firmware as my Hauppauge HVR-850, and (during separate test sessions) installs the same ALSA device;

card 1: Em28xxAudio [Em28xx Audio], device 0: Em28xx Audio [Empia 28xx Capture]
  Subdevices: 0/1
  Subdevice #0: subdevice #0


Dean
