Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36108 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbdIXJEd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 05:04:33 -0400
Received: by mail-pg0-f67.google.com with SMTP id d8so3219448pgt.3
        for <linux-media@vger.kernel.org>; Sun, 24 Sep 2017 02:04:32 -0700 (PDT)
Date: Sun, 24 Sep 2017 19:04:19 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-media <linux-media@vger.kernel.org>
Subject: Re: f26: dvb_usb_rtl28xxu not tuning "Leadtek Winfast DTV2000 DS
 PLUS TV"
Message-ID: <20170924090417.GA24153@ubuntu.windy>
References: <00ad85dd-2fe3-5f15-6c0c-47fcf580f541@eyal.emu.id.au>
 <3f0c2037-4a84-68a9-228f-015034e27900@eyal.emu.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f0c2037-4a84-68a9-228f-015034e27900@eyal.emu.id.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 23, 2017 at 10:48:34PM +1000, Eyal Lebedinsky wrote:
> On 18/09/17 14:26, Eyal Lebedinsky wrote:
> >I have just upgraded to f24. I am now using the standard dvb_usb_rtl28xxu fe
> 
> I have upgraded to f26 and this driver still fails to tune the "Leadtek Winfast DTV2000 DS PLUS TV".
> 
> >which logs messages suggesting all is well (I get the /dev/dvb/adapter? etc.)
> >but I get no channels tuned when I run mythfrontend or scandvb.
> >
> >Is anyone using this combination?
> >Is this the correct way to use this tuner?
> 
> Is this the wrong list? If so then please suggest a more suitable one.

It's the right list. The problem is nobody seems to care.
I have one of these too, I was able to get it tune at one time
but there were some problems that I never ended up running down.

I was planning to dig it out and have a play with it again.

Just to confirm - you're building the media_build git tree on f26
and those drivers are the ones that are not working, yes?
If not, you need to try that to get any help here.
Have a look at https://git.linuxtv.org/media_build.git/about/
and let me know if you need further help with that.

It may be possible to get the driver into debug mode and get more
information logged. I'm not sure this will work but give it a go.

First set up the dynamic debug filesystem (may already be there)
# cat >> /etc/fstab
debugfs /sys/kernel/debug debugfs defaults 0 0
^D
# mount -av

Turn on debug printing for the modules of interest
# echo 'module rtl2832 +p' > /sys/kernel/debug/dynamic_debug/control
# echo 'module dvb_usb_rtl28xxu +p' > /sys/kernel/debug/dynamic_debug/control


Vince
