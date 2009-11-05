Return-path: <linux-media-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60424 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbZKEHsr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 02:48:47 -0500
Received: from [127.0.0.1] (really [76.79.221.75])
          by hrndva-omta02.mail.rr.com with ESMTP
          id <20091105074852700.XZEK22271@hrndva-omta02.mail.rr.com>
          for <linux-media@vger.kernel.org>; Thu, 5 Nov 2009 07:48:52 +0000
Message-ID: <4AF28359.7090409@neonixie.com>
Date: Wed, 04 Nov 2009 23:48:41 -0800
From: Moses <moses@neonixie.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: multiple apps on a single video device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am running motion (security camera software) and xawtv at the same 
time on the same device on an old FC6 install. We need to upgrade, but I 
have tried several times with newer distros and none so far will let me 
run motion and xawtv at the same time (on the same video device that 
is). I have done many internet searches and came upon this list and some 
discussions regarding letting two applications open a video device at 
the same time. This gave me a hint that maybe there was a problem and 
the developers of V4L or bttv (or ?) put in place a lock so two programs 
can't access the video device at the same time (my setup works just fine 
btw). Is my guess right? If so, is there anything I can do to get it 
working again like the old version?

Sorry I don't have version numbers of the ones I tried (haven't tried a 
new distro in a while), but the one I have that works reports bttv as 
version 0.9.17 in dmesg (I'm not even sure if this version number for 
bttv is relevant). Kernel is 2.6.22.14-72.fc6

Below is the initial message I sent to the motion mailing list with some 
more details (no responses yet).

Thank you in advance for any help!

Regards,
-Moses

Hello,

I have been running motion for several years now, along with xawtv 
displaying the video in real time on the machine. One issue.. we are 
running Fedora Core 6! Its getting time to upgrade but one small 
problem, I have yet to find a combination that supports this. Let me 
explain in more detail.

Motion starts normally on bootup. I login to X and start xawtv running 
on the SAME video device. It just runs and displays our video in real 
time on the screen (4 different video streams).
Now, I'm not sure the exact mechanism that makes this possible, I 
haven't setup any looping devices, etc.. The video in xawtv comes up 
normally and we can display several on the screen in various sized 
windows as we need. The video is in real-time, regardless of how motion 
is configured. I believe xawtv is using some sort of hardware overlay 
from the grabber device (8 chip BT878 device) to the video card (build 
in intel video). This setup is great, and uses almost no CPU power that 
I can detect.

Now the problem.. I haven't been able to duplicate this functionality on 
newer software. I have tried Fedora 11, 10, and another one possible 8 
or 9. I believe I tried another distro a while back as well, I forget 
which one. None of them had the capability of running xawtv along with 
motion on the same device. I run the same version of motion that is 
working on Fedora 6, and make sure I load the same (or what I think is 
the same) video driver that X uses, but no luck. It has been a while 
since I tried this, but I believe xawtv would not run due to the video 
device being in use. I also tried a few other tv viewer apps during 
these trials, tvtime, etc.

So the questions.. Does anyone know what mechanism is it exactly that 
allows me to just start up an xawtv session on the same device, is is 
V4L, or ? Anyone running a similar setup? If so, what distro and 
version? Did you have to do any specific configuration?

The setup I describe works very well, I don't know of any commercial DVR 
systems that even come close. I have been able to add a lot of nice 
features using this setup.. for instance I have a script that makes 
xawtv go fullscreen on a video channel that has motion (if its the only 
one with motion). I would hate to loose all the functionality this 
combination provides. Any help is appreciated.

Thanks!

Regards,
-Moses


