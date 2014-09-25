Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:50344 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbaIYQCF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 12:02:05 -0400
Date: Thu, 25 Sep 2014 18:01:34 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140925160134.GA6207@linuxtv.org>
References: <20140925125353.GA5129@linuxtv.org>
 <54241C81.60301@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54241C81.60301@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Thu, Sep 25, 2014 at 07:45:37AM -0600, Shuah Khan wrote:
> On 09/25/2014 06:53 AM, Johannes Stezenbach wrote:
> > ever since your patchset which implements suspend/resume
> > for em28xx, hibernating the system breaks the Hauppauge WinTV HVR 930C driver.
> > In v3.15.y and v3.16.y it throws a request_firmware warning
> > during hibernate + resume, and the /dev/dvb/ device nodes disappears after
> > resume.  In current git v3.17-rc6-247-g005f800, it hangs
> > after resume.  I bisected the hang in qemu to
> > b89193e0b06f "media: em28xx - remove reset_resume interface",
> > the hang is fixed if I revert this commit on top of v3.17-rc6-247-g005f800.
> > 
> > Regarding the request_firmware issue. I think a possible
> > fix would be:

I think you should take a closer look at the code you snipped.
Maybe this fixes the root of the issue you worked around
with the DVB_FE_DEVICE_RESUME thing, namely calling
fe->ops.tuner_ops.init from wrong context.

> The request_firmware has been fixed. I ran into this on
> Hauppauge WinTV HVR 950Q device. The fix is in xc5000
> driver to not release firmware as soon as it loads.
> With this fix firmware is cached and available in
> resume path.
> 
> These patches are pulled into linux-media git couple
> of days ago.
> 
> http://patchwork.linuxtv.org/patch/26073/
> http://patchwork.linuxtv.org/patch/25345/

The second patch does not apply to current git master (v3.17-rc6-247-g005f800).
Maybe some other patch I need?

> The reset_resume and this request firmware problem
> might be related. Could you please try with the
> above two patches and see if the problems goes away.
> i.e without reverting
> 
> b89193e0b06f "media: em28xx - remove reset_resume interface"
> 
> Please let me know even if it works. If it doesn't could
> you please send me full dmesg. I am curious if usb bus
> is reset i.e looses power during hibernate. If it does,
> it has to go through disconnect sequence. The reason
> I removed the reset_resume is because it is a simple
> resume routine that can't handle power loss to the bus.

I tested in qemu, but my real use case is "echo shutdown >/sys/power/disk"
which causes USB power to drop during hibernate on my PC.  Additionally
I'm usually turning off the power completely by physical switch
on the multiple socket outlet.

You can check the dmesg included in my first mail, it shows

[  240.487577]  [<ffffffff81416da4>] em28xx_usb_disconnect+0x57/0x6a
[  240.489331]  [<ffffffff8136ec49>] usb_unbind_interface+0x75/0x1fd
[  240.491037]  [<ffffffff81315190>] __device_release_driver+0x84/0xde
[  240.492792]  [<ffffffff813151ff>] device_release_driver+0x15/0x21
[  240.494371]  [<ffffffff8136ee14>] usb_driver_release_interface+0x43/0x78
[  240.496276]  [<ffffffff813621ca>] ? usb_for_each_dev+0x2b/0x2b
[  240.497788]  [<ffffffff8136ee67>] usb_forced_unbind_intf+0x1e/0x25
[  240.499477]  [<ffffffff8136eea6>] unbind_marked_interfaces.isra.9+0x38/0x42
[  240.501365]  [<ffffffff8136eef8>] usb_resume+0x48/0x5b


Thanks,
Johannes
