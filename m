Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KTQmd-0004ZA-NE
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 02:33:45 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K5K00G7VEV8EKD0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 13 Aug 2008 20:33:09 -0400 (EDT)
Date: Wed, 13 Aug 2008 20:33:08 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <8fcafd2c0808131723l21031daej9e9ae3eeabfa57f7@mail.gmail.com>
To: James Lucas <orbus42@gmail.com>
Message-id: <48A37D44.7090808@linuxtv.org>
MIME-version: 1.0
References: <8fcafd2c0808131723l21031daej9e9ae3eeabfa57f7@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Digital tuning failing on Pinnacle 800i with dmesg
 output
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

James Lucas wrote:
> Hello - first time poster here.  I'm running Ubuntu Hardy, stock kernel 
> 2.6.24-19-generic.  Compiled the v4l tree from repository and installed 
> the modules.  Also grabbed firmware found on the dvb-wiki page  Analog 
> tuning works.  Trying to run dvbscan or scan results in either no 
> channels found or a hang on the attempt to tune the first channel.

Welcome!


> 
> Output of dmesg contains errors like this:
> 
> [  576.298553] i2c-adapter i2c-2: sendbytes: error - bailout.
> [  577.098249] xc5000: I2C write failed (len=4)
> [  577.098259] xc5000: Unable to initialise tuner
> [  583.499754] s5h1409_writereg: writereg error (reg == 0xf3, val == 
> 0x0000, ret == -121)
> [  589.897260] s5h1409_writereg: writereg error (reg == 0xf5, val == 
> 0x0000, ret == -121)
> [  596.294758] s5h1409_writereg: writereg error (reg == 0xf5, val == 
> 0x0001, ret == -121)
> [  602.692260] s5h1409_writereg: writereg error (reg == 0xf4, val == 
> 0x0001, ret == -121)
> [  609.089760] s5h1409_writereg: writereg error (reg == 0x85, val == 
> 0x0110, ret == -121)
> [  615.487264] s5h1409_writereg: writereg error (reg == 0xf5, val == 
> 0x0000, ret == -121)
> [  621.884765] s5h1409_writereg: writereg error (reg == 0xf5, val == 
> 0x0001, ret == -121)
> [  628.386227] s5h1409_writereg: writereg error (reg == 0xf3, val == 
> 0x0001, ret == -121)

Looks i2c dead during xc5000 initialization, does the hardware work 
under windows?

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
