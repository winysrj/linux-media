Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63702 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0BWQqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 11:46:36 -0500
Received: by bwz1 with SMTP id 1so1139040bwz.21
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 08:46:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B837790.6060007@linuxstation.net>
References: <20091007101142.3b83dbf2@glory.loctelecom.ru>
	 <200912160849.17005.hverkuil@xs4all.nl>
	 <20100112172209.464e88cd@glory.loctelecom.ru>
	 <201001130838.23949.hverkuil@xs4all.nl>
	 <20100127143637.26465503@glory.loctelecom.ru>
	 <4B83076A.3010409@ctecworld.com>
	 <829197381002221452k793be9d2l8f7ec3638233ecd0@mail.gmail.com>
	 <4B837790.6060007@linuxstation.net>
Date: Tue, 23 Feb 2010 11:46:33 -0500
Message-ID: <829197381002230846m4ad70c46o2ec9b9935d9b8bc3@mail.gmail.com>
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

On Tue, Feb 23, 2010 at 1:37 AM, Dean <red1@linuxstation.net> wrote:
> Hi,
>
> I have the KWorld DVB-T 305U, an em28xx device.  Only the video works for me under Linux, no audio.  In case anyone wants to see it, I have attached the full dmesg text, solely from this device.
>
> Cheers,
> Dean

Hi Dean,

How are you testing the audio, and under what video standard are you
trying to use the device (NTSC/PAL/SECAM)?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
