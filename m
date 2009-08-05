Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out9.libero.it ([212.52.84.109]:50012 "EHLO
	cp-out9.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbZHEVkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 17:40:21 -0400
Received: from [192.168.1.21] (151.59.219.5) by cp-out9.libero.it (8.5.107) (authenticated as efa@iol.it)
        id 4A76C648003BE669 for linux-media@vger.kernel.org; Wed, 5 Aug 2009 23:40:20 +0200
Message-ID: <4A79FC43.6000402@iol.it>
Date: Wed, 05 Aug 2009 23:40:19 +0200
From: Valerio Messina <efa@iol.it>
Reply-To: efa@iol.it
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy HibridT XS
References: <4A6F8AA5.3040900@iol.it> <4A739DD6.8030504@iol.it>	 <829197380908032002v196384c9oa0aff78627959db@mail.gmail.com>	 <4A79320B.7090401@iol.it>	 <829197380908050627u892b526wc5fb8ef1f6be6b53@mail.gmail.com>	 <4A79CEBD.1050909@iol.it>	 <829197380908051134x5fda787fx5bf9adf786aa739e@mail.gmail.com>	 <4A79E07F.1000301@iol.it>	 <829197380908051251x6996414ek951d259373401dd7@mail.gmail.com>	 <4A79E6B7.5090408@iol.it> <829197380908051322r1382d97dtd5e7a78f99438cc9@mail.gmail.com>
In-Reply-To: <829197380908051322r1382d97dtd5e7a78f99438cc9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller ha scritto:
> Great.  I'll get a PULL request issued so this can get into the
> mainline.  Thanks for testing.

I have three more request for this driver tuner, but are low priority.

1 - On/off button on the IR as now, send a command to the desktop to 
start the shutdown, reboot, suspend or hybernate window. To me should 
send something to the active window only, like an ALT+F4 to close the 
windows (for example Kaffeine).

2 - is there a simple (like a configuration text file) method to assign 
functions to unused buttons on the remote IR, like start an executable 
or send dbus messages?

3 - the TVtuner remain ON, also when user applications are all OFF. It 
become hot specially in summer. That tuner is not well designed in the 
thermal aspect, and when ON stay at 50°C, where blocky video and noisy 
audio happen. I made same holes on the two narrow side of the case and 
now is better. Is there a method to swith OFF, on put on standby the 
tuner (like on Windows) when it is unused?

thanks,
Valerio


