Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34778 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaI3OoF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 10:44:05 -0400
Message-ID: <542AC1AC.9050802@iki.fi>
Date: Tue, 30 Sep 2014 17:43:56 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Johannes Stezenbach <js@linuxtv.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/6] some fixes and cleanups for the em28xx-based HVR-930C
References: <cover.1411956856.git.mchehab@osg.samsung.com>	<20140929174430.GA18967@linuxtv.org>	<20140929153018.2f701689@recife.lan>	<20140929184428.GA447@linuxtv.org>	<20140930073810.GA9128@linuxtv.org> <20140930061418.101be1ff@concha.lan>
In-Reply-To: <20140930061418.101be1ff@concha.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/30/2014 12:14 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 30 Sep 2014 09:38:10 +0200
> Johannes Stezenbach <js@linuxtv.org> escreveu:
>
>> On Mon, Sep 29, 2014 at 08:44:28PM +0200, Johannes Stezenbach wrote:
>>> On Mon, Sep 29, 2014 at 03:30:18PM -0300, Mauro Carvalho Chehab wrote:

>>> Ah, OK.  I'll try to test with power removed tomorrow.
>>
>> I test again in qemu, but this time rmmod and blacklist em28xx
>> on the host, and unplug HVR-930C during hibernate.  As you
>> said, it breaks.  Log fter resume:
>>
>> [   83.308267] usb 1-1: reset high-speed USB device number 2 using ehci-pci
>> [   83.598182] em2884 #0: Resuming extensions
>> [   83.599187] em2884 #0: Resuming video extensionem2884 #0: Resuming DVB extension
>> [   83.604115] xc5000: I2C read failed
>> [   83.607091] xc5000: I2C write failed (len=3)
>> [   83.607985] xc5000: firmware upload failed...
>> [   83.608766]  - too many retries. Giving up
>> [   83.609553] em2884 #0: fe0 resume -22
>> [   83.615533] PM: restore of devices complete after 937.567 msecs
>> [   83.617278] PM: Image restored successfully.
>> [   83.618262] PM: Basic memory bitmaps freed
>> [   83.619097] Restarting tasks ... done.
>> [   83.622320] xc5000: I2C read failed
>> [   83.623197] xc5000: I2C write failed (len=3)
>> [   83.623198] xc5000: firmware upload failed...
>> [   83.623198]  - too many retries. Giving up
>> [   83.624071] drxk: i2c read error at addr 0x29
>> [   83.624072] drxk: Error -6 on mpegts_stop
>> [   83.624073] drxk: Error -6 on start
>> [   84.621531] drxk: i2c read error at addr 0x29
>> [   84.623426] drxk: Error -6 on get_dvbt_lock_status
>> [   84.625477] drxk: Error -6 on get_lock_status
>
> Yeah, this is what I was expecting. I have already a patch that would fix
> the issue with xc5000 (the issue is actually at em28xx, that needs to do
> a full initialization of the device), but something else is needed to put
> drxk into a reliable state.

As a general level, we have to get rid of all kind of hacks we have used 
in our DTV drivers in order to make things properly and reliable in a 
long term. There is far away too many hacks, which leads all the time 
that kind of problems when some new functionality is added.

That means:
* get rid of I2C gate control and use I2C mux instead
* get rid of homemade clock configs and use clock framework
* get rid of homemade GPIO things and use kernel GPIO framework
* get rid of all hackish solutions to enable HW power and reset, likely 
using regulator framework
* get rid of homemade DVB driver and use I2C/SPI etc models offered by 
core kernel

Basically we should replace all the interfaces drivers needs something 
well known and standard. Individual driver should not be aware, nor need 
to know any HW connections behind busses it uses - it should trust it 
gets all the things when it needs. When it access I2C bus, bus must be 
there fully operational. When it wakes up from sleep and request power 
and clock, those should be delivered without any knowledge about 
underlying connections - it is up to framework to offer those.

Implementing things properly using well known internal APIs / 
frameworks, without own hacks, is only way to get things work properly 
in a long ran. (PS. I haven't followed that discussion, but these kind 
of issues looks just like a coming from hacks I mentioned.).

Amen.
Antti

-- 
http://palosaari.fi/
