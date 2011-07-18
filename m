Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38801 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab1GROt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 10:49:57 -0400
Received: by vws1 with SMTP id 1so2186210vws.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jul 2011 07:49:56 -0700 (PDT)
References: <CAHiZ1abKhmOJt9BS6yghmwPSMooiX2GoF8HsSB9gs2jt9xW8Tw@mail.gmail.com>
In-Reply-To: <CAHiZ1abKhmOJt9BS6yghmwPSMooiX2GoF8HsSB9gs2jt9xW8Tw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <6F22EB15-4C4F-4D0E-A640-B503499C2EE8@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: linux-media@vger.kernel.org
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Happuage HDPVR 0 byte files.
Date: Mon, 18 Jul 2011 10:49:36 -0400
To: Greg Williamson <cheeseboy16@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Jul 18, 2011, at 6:49 AM, Greg Williamson wrote:

> Hi,  I'm on Archlinux running 2.6.39-ARCH.  When I plug in my hdpvr I
> see it registers.
> 
> Here is the dmesg output:
> [  778.518866] hdpvr 1-3:1.0: firmware version 0x15 dated Jun 17 2010 09:26:53
> [  778.704965] hdpvr 1-3:1.0: device now attached to video0
> [  778.705006] usbcore: registered new interface driver hdpvr
> 
> 
> However 'cat /dev/video0 > test.ts' creates 0 byte files every time.

What audio input do you have wired up, and has the driver been told to
use the right one? You'll get 0-byte files if there's no audio on the
selected audio input (default is rear RCA). Can alter the default with
a modparam (default_audio_input=2 for spdif), or change it on the fly
using v4l-utils.

-- 
Jarod Wilson
jarod@wilsonet.com



