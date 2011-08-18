Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4-vm0.bt.bullet.mail.ukl.yahoo.com ([217.146.182.229]:27361
	"HELO nm4-vm0.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751293Ab1HRUCb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 16:02:31 -0400
Message-ID: <4E4D6E72.5070509@yahoo.com>
Date: Thu, 18 Aug 2011 20:56:34 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] Latest version of em28xx / em28xx-dvb patch for PCTV
 290e
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com>
In-Reply-To: <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/08/11 19:43, Devin Heitmueller wrote:
> You would be well served to break this into a patch series, as it tends to be 
> difficult to review a whole series of changes in a single patch. You seem to 
> be mixed in a bunch of "useless" changes alongside functional changes. For 
> example, if you're trying to add in a missing goto inside an exception block, 
> doing that at the same time as renaming instances of "errCode" to "retval" 
> just creates confusion.

Actually, those two particular changes go together because I'm replacing "return 
errCode" with a goto to "return retval". Ultimately, errCode becomes an unused 
variable.

> And finally, the mutex structure used for the modules is somewhat complicated 
> due to to the need to keep the analog side of the board locked while 
> initializing the digital side. This code was added specifically to prevent 
> race conditions that were seen during initialization as things like udev and 
> dbus attempted to connect to the newly created V4L device while the em28xx-dvb 
> module was still coming up.

OK, thanks. I've been tackling this problem from the "We must always take lock A 
before lock B, and never vice versa" point of view. So the order is:

- take device mutex
- enter em28xx_init_dev()
- enter em28xx_init_extension()
- take device list mutex
- call init() function for every extension with this device

Since dvb_init() is the init() function for the em28xx-dvb extension, it follows 
that it cannot take the device's mutex again. The problem is therefore moved to 
em28xx_dvb_register(), which takes the device list mutex and yet MUST not take 
the mutex for any device in the list.

Combining em28xx_add_into_devlist() with em28xx_init_extension() (and similarly 
em28xx_remove_from_devlist() with em28xx_close_extension()) means that the 
device list must always contain a list of devices that has been initialised 
against every extension in the extension list.

I can probably factor out the simpler patches first, such as using the bit 
operations on em28xx_devused, and the memory leak in em28xx_v4l2_close(). And 
the spelling fixes...

Cheers,
Chris

