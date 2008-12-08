Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jeffd@i2k.com>) id 1L9XJ9-00014z-BE
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 05:01:20 +0100
Date: Sun, 7 Dec 2008 23:00:40 -0500
From: Jeff DeFouw <jeffd@i2k.com>
To: Josh Borke <joshborke@gmail.com>
Message-ID: <20081208040040.GA7855@blorp.plorb.com>
References: <7d91b3760812071828w57ba50d6h979d9d0f703d3080@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7d91b3760812071828w57ba50d6h979d9d0f703d3080@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1800 Analog issues
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

On Sun, Dec 07, 2008 at 09:28:17PM -0500, Josh Borke wrote:
> I recently upgraded to Fedora 10 and decided to try to get my Hauppauge
> HVR-1800 working. I thought everything was working fine and well because I
> could run 'tvtime -d /dev/video0' and 'cat /dev/video1 > /tmp/test.mpg' and
> things worked but then I rebooted and it all went to pot. Now when I run
> 'cat /dev/video1 > /tmp/test.mpg' the output of tvtime becomes wavy and
> distorted. I tried loading both cx25840 and cx23885 with debug=1 but that
> didn't help.  I also tried with the latest v4l-dvb sources
> (v4l-dvb-7100e78482d7) with the same result.
> 
> I've attached the dmesg in hopes of being some help.
> 
> To recap, I can 'tvtime -d /dev/video0' and I get a great picture. As soon
> as I 'cat /dev/video1 > /tmp/test.mpg' the picture goes wavy.

I found the same thing while testing the analog tuner support (which I 
don't normally use).  It only happened the first time after boot.  
Unloading all of the modules (run "make rmmod" in the v4l-dvb sources) 
and reloading them always fixed it for me.  Also, make sure the tuner 
module is loaded after that.  Mine doesn't auto-load for some reason.

-- 
Jeff DeFouw <jeffd@i2k.com>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
