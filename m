Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:32994 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbZHEVvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 17:51:13 -0400
Received: by yxe5 with SMTP id 5so516802yxe.33
        for <linux-media@vger.kernel.org>; Wed, 05 Aug 2009 14:51:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A79FC43.6000402@iol.it>
References: <4A6F8AA5.3040900@iol.it> <4A79320B.7090401@iol.it>
	 <829197380908050627u892b526wc5fb8ef1f6be6b53@mail.gmail.com>
	 <4A79CEBD.1050909@iol.it>
	 <829197380908051134x5fda787fx5bf9adf786aa739e@mail.gmail.com>
	 <4A79E07F.1000301@iol.it>
	 <829197380908051251x6996414ek951d259373401dd7@mail.gmail.com>
	 <4A79E6B7.5090408@iol.it>
	 <829197380908051322r1382d97dtd5e7a78f99438cc9@mail.gmail.com>
	 <4A79FC43.6000402@iol.it>
Date: Wed, 5 Aug 2009 17:51:14 -0400
Message-ID: <829197380908051451j6590db20l7268d34bd4b8342a@mail.gmail.com>
Subject: Re: Terratec Cinergy HibridT XS
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: efa@iol.it
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 5, 2009 at 5:40 PM, Valerio Messina<efa@iol.it> wrote:
> 1 - On/off button on the IR as now, send a command to the desktop to start
> the shutdown, reboot, suspend or hybernate window. To me should send
> something to the active window only, like an ALT+F4 to close the windows
> (for example Kaffeine).

This is typically controlled by your application or the desktop
environment.  The on/off is mapped the same across all remote
controls.

> 2 - is there a simple (like a configuration text file) method to assign
> functions to unused buttons on the remote IR, like start an executable or
> send dbus messages?

The map that I committed in does have all the keys mapped to input
event codes.  You would need to reconfigure your input subsystem to
point the event codes to some other function.

> 3 - the TVtuner remain ON, also when user applications are all OFF. It
> become hot specially in summer. That tuner is not well designed in the
> thermal aspect, and when ON stay at 50°C, where blocky video and noisy audio
> happen. I made same holes on the two narrow side of the case and now is
> better. Is there a method to swith OFF, on put on standby the tuner (like on
> Windows) when it is unused?

The power management on these devices could certainly use some work.
I thought the power management was working on that board since it has
an xc3028 tuner chip, but I would have to look at the code to be sure.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
