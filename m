Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:38730 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbaIZHlQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 03:41:16 -0400
Date: Fri, 26 Sep 2014 09:41:03 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140926074103.GA31491@linuxtv.org>
References: <20140925125353.GA5129@linuxtv.org>
 <54241C81.60301@osg.samsung.com>
 <20140925160134.GA6207@linuxtv.org>
 <5424539D.8090503@osg.samsung.com>
 <20140925181747.GA21522@linuxtv.org>
 <542462C4.7020907@osg.samsung.com>
 <54246702.6000907@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54246702.6000907@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Thu, Sep 25, 2014 at 01:03:30PM -0600, Shuah Khan wrote:
> On 09/25/2014 12:45 PM, Shuah Khan wrote:
> 
> > ok now I know why the second path didn't
> > apply. It depends on another change that added resume
> > function
> > 
> > 7ab1c07614b984778a808dc22f84b682fedefea1
> > 
> > You don't need the second patch. The first patch applied
> > to 3.17 and fails on 3.16
> > 
> > http://patchwork.linuxtv.org/patch/26073/
> > 
> > I am working on 3.16 back-port for the first one to 3.16
> > and send one shortly for you to test.
> > 
> 
> The first patch depends the work done in 3.17, I don't
> see it meeting the stable rules to go into 3.16.
> 
> Johannes! Do you need the request_firmware patch for
> 3.16?? Are you seeing problems there. 3.16 doesn't
> have b89193e0b06f

3.16.3 has two issues:

- 6eb5e3399e8 "em28xx-dvb - fix em28xx_dvb_resume() to not unregister i2c and dvb"
  is not in 3.16.3
- the request_firmware issue

Locally I applied 6eb5e3399e8 and my dvb_frontend_resume() change,
which improves it but it is not fully working.  After the
frontend device is opened:

Sep 26 08:29:31 abc kernel: xc5000: I2C read failed
Sep 26 08:29:31 abc kernel: xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
Sep 26 08:29:31 abc kernel: xc5000: firmware read 12401 bytes.
Sep 26 08:29:31 abc kernel: xc5000: firmware uploading...
Sep 26 08:29:31 abc kernel: xc5000: I2C write failed (len=3)
Sep 26 08:29:31 abc kernel: xc5000: firmware upload failed...
Sep 26 08:29:31 abc kernel: xc5000: Unable to initialise tuner
Sep 26 08:29:31 abc kernel: drxk: i2c read error at addr 0x29
Sep 26 08:29:31 abc kernel: drxk: Error -6 on get_dvbt_lock_status
Sep 26 08:29:31 abc kernel: drxk: i2c read error at addr 0x29
Sep 26 08:29:31 abc kernel: drxk: i2c read error at addr 0x29
Sep 26 08:29:31 abc kernel: drxk: Error -6 on get_dvbt_lock_status
Sep 26 08:29:31 abc kernel: drxk: i2c read error at addr 0x29
Sep 26 08:29:31 abc kernel: drxk: i2c read error at addr 0x29
Sep 26 08:29:31 abc kernel: drxk: Error -6 on get_dvbt_lock_status
Sep 26 08:29:31 abc kernel: drxk: i2c read error at addr 0x29
Sep 26 08:29:31 abc kernel: xc5000: I2C read failed
Sep 26 08:29:31 abc kernel: xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
Sep 26 08:29:31 abc kernel: xc5000: firmware read 12401 bytes.
Sep 26 08:29:31 abc kernel: xc5000: firmware uploading...
Sep 26 08:29:31 abc kernel: xc5000: I2C write failed (len=3)
Sep 26 08:29:31 abc kernel: xc5000: firmware upload failed...
Sep 26 08:29:31 abc kernel: drxk: i2c read error at addr 0x29
Sep 26 08:29:31 abc kernel: drxk: Error -6 on mpegts_stop
Sep 26 08:29:31 abc kernel: drxk: Error -6 on start
Sep 26 08:29:31 abc kernel: drxk: i2c read error at addr 0x29
Sep 26 08:29:31 abc kernel: drxk: Error -6 on get_dvbt_lock_status
...

I have to unload and reload the em28xx modules to recover.
So it would be good to have an xc5000 patch backport from
you instead of my dvb_frontend_resume() change.


Johannes
