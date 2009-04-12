Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:60888 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328AbZDLIIu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Apr 2009 04:08:50 -0400
Date: Sun, 12 Apr 2009 10:08:20 +0200
From: Janne Grunau <janne-mythtv@grunau.be>
To: Development of mythtv <mythtv-dev@mythtv.org>
Cc: linux-media@vger.kernel.org, Ian Forde <ian@duckland.org>
Subject: Re: [mythtv] current hd-pvr driver with Centos 5
Message-ID: <20090412080819.GA8892@aniel>
References: <88a5a7650904081956k1dbe25d2k553936645d5e7142@mail.gmail.com> <1239514442.1633.8.camel@y-wing.iforde.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239514442.1633.8.camel@y-wing.iforde.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 11, 2009 at 10:34:02PM -0700, Ian Forde wrote:
> On Wed, 2009-04-08 at 19:56 -0700, Ian Forde wrote:
> > (now to the dev list...)
> > 
> > So I went to upgrade my CentOS 5 myth boxes from 5.2 to 5.3. Upgrade
> > went successfully. Next step, upgrade my myth trunk installation.  Ah,
> > but I have to upgrade my hd-pvr driver. Go to the wiki page... looks
> > like the driver is now in v4l-dvb trunk. No problem - download,
> > build... bzzt.  Looks like it requires 2.6.20.  Since CentOS uses
> > 2.6.18 with a TON of backported fixes, I figured I'd give it a shot,
> > since it worked earlier. Remember that "bzzt" earlier?  Yeah - that's
> > this error:
> > 
> > [myhost v4l-dvb]# make
> > make -C /usr/local/src/myth/v4l-dvb/v4l
> > make[1]: Entering directory `/usr/local/src/myth/v4l-dvb/v4l'
> > creating symbolic links...
> > Kernel build directory is /lib/modules/2.6.18-128.1.6.el5/build
> > make -C /lib/modules/2.6.18-128.1.6.el5/build
> > SUBDIRS=/usr/local/src/myth/v4l-dvb/v4l  modules
> > make[2]: Entering directory `/usr/src/kernels/2.6.18-128.1.6.el5-x86_64'
> >  CC [M]  /usr/local/src/myth/v4l-dvb/v4l/hdpvr-video.o
> > /usr/local/src/myth/v4l-dvb/v4l/hdpvr-video.c: In function
> > 'hdpvr_alloc_buffers':
> > /usr/local/src/myth/v4l-dvb/v4l/hdpvr-video.c:158: warning: passing
> > argument 6 of 'usb_fill_bulk_urb' from incompatible pointer type
> > /usr/local/src/myth/v4l-dvb/v4l/hdpvr-video.c:282:49: error: macro
> > "INIT_WORK" requires 3 arguments, but only 2 given
> > /usr/local/src/myth/v4l-dvb/v4l/hdpvr-video.c: In function
> > 'hdpvr_start_streaming':
> > /usr/local/src/myth/v4l-dvb/v4l/hdpvr-video.c:282: error: 'INIT_WORK'
> > undeclared (first use in this function)
> > /usr/local/src/myth/v4l-dvb/v4l/hdpvr-video.c:282: error: (Each
> > undeclared identifier is reported only once
> > /usr/local/src/myth/v4l-dvb/v4l/hdpvr-video.c:282: error: for each
> > function it appears in.)
> > make[3]: *** [/usr/local/src/myth/v4l-dvb/v4l/hdpvr-video.o] Error 1
> > make[2]: *** [_module_/usr/local/src/myth/v4l-dvb/v4l] Error 2
> > make[2]: Leaving directory `/usr/src/kernels/2.6.18-128.1.6.el5-x86_64'
> > make[1]: *** [default] Error 2
> > make[1]: Leaving directory `/usr/local/src/myth/v4l-dvb/v4l'
> > make: *** [all] Error 2
> 
> Okay - looks like I figured a way out of this one.  By changing line 282
> of hdpvr-video.c to read:
> 
> INIT_WORK(&dev->worker, hdpvr_transmit_buffers, &dev->worker);

That's simple enough change to restore backward compatibility to 2.6.18.

> I was able to get it to build.  Unfortunately, SPDIF input doesn't seem
> to be doing the "right thing".  As I understand it, the driver won't
> record unless it sees a signal.  But it *is* able to record, even with
> the 'cat /dev/video4 > /tmp/1.mpg' test.  When I do a subsequent 'ffmpeg
> -i /tmp/1.mpg', it tells me that regarding audio, it's got AAC audio
> rather than AC3 5.1.

The audio encoding has to be set explititly to ac3

> Next step: trying 'v4l2-ctl --device=/dev/video4 -l' to see if I missed
> anything.  I tried 'v4l2-ctl --device=/dev/video4
> --set-ctrl=audio_encoding=4' and retried a capture.  That yields a file
> with AC3 but 2-channel audio,

Are any other audio signals beside spdif connected? Try disconnecting
them.

> and it still won't play on a frontend that
> can play AC3 and non-AC3 content without a problem.

Anything more specific on this problem would help. Are there error
messages? Is it playable in other players?

> I suppose my question is: Is this the correct place to ask questions
> regarding the hd-pvr driver itself?

No, linux-media@vger.kernel.org is (cc-ed).

Janne
