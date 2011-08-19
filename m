Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab1HSBBp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 21:01:45 -0400
Message-ID: <4E4DB5EE.7040107@redhat.com>
Date: Thu, 18 Aug 2011 18:01:34 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] Latest version of em28xx / em28xx-dvb patch for PCTV
 290e
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com> <4E4D6E72.5070509@yahoo.com>
In-Reply-To: <4E4D6E72.5070509@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-08-2011 12:56, Chris Rankin escreveu:
> On 18/08/11 19:43, Devin Heitmueller wrote:
>> You would be well served to break this into a patch series, as it tends to be difficult to review a whole series of changes in a single patch. You seem to be mixed in a bunch of "useless" changes alongside functional changes. For example, if you're trying to add in a missing goto inside an exception block, doing that at the same time as renaming instances of "errCode" to "retval" just creates confusion.
> 
> Actually, those two particular changes go together because I'm replacing "return errCode" with a goto to "return retval". Ultimately, errCode becomes an unused variable.
> 
>> And finally, the mutex structure used for the modules is somewhat complicated due to to the need to keep the analog side of the board locked while initializing the digital side. This code was added specifically to prevent race conditions that were seen during initialization as things like udev and dbus attempted to connect to the newly created V4L device while the em28xx-dvb module was still coming up.
> 
> OK, thanks. I've been tackling this problem from the "We must always take lock A before lock B, and never vice versa" point of view. So the order is:
> 
> - take device mutex
> - enter em28xx_init_dev()
> - enter em28xx_init_extension()
> - take device list mutex
> - call init() function for every extension with this device
> 
> Since dvb_init() is the init() function for the em28xx-dvb extension, it follows that it cannot take the device's mutex again. The problem is therefore moved to em28xx_dvb_register(), which takes the device list mutex and yet MUST not take the mutex for any device in the list.
> 
> Combining em28xx_add_into_devlist() with em28xx_init_extension() (and similarly em28xx_remove_from_devlist() with em28xx_close_extension()) means that the device list must always contain a list of devices that has been initialised against every extension in the extension list.
> 
> I can probably factor out the simpler patches first, such as using the bit operations on em28xx_devused, and the memory leak in em28xx_v4l2_close(). And the spelling fixes...

I agree with Devin: please break it into one patch with just the mutex
fixes, and another one(s) with the cleanups. The basic rule is one patch
per logic change. 

For the mutex patch, please add:
"Cc: stable@kernel.org" at the line before your signed-off-by, as such
patch should be backported to stable kernels.

With respect to return errCode, maybe the better would be to
rename it as just "rc". It is very common to call the return
code as that on several places, and it is smaller.

PS.: I didn't make a full review of your patches yet. I'll probably
do it by the next week, after returning from LinuxCon.

Thanks!
Mauro
