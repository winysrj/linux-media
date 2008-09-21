Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vanessaezekowitz@gmail.com>) id 1KhI1S-00020a-A5
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 08:02:20 +0200
Received: by yx-out-2324.google.com with SMTP id 8so157454yxg.41
	for <linux-dvb@linuxtv.org>; Sat, 20 Sep 2008 23:02:14 -0700 (PDT)
Content-Disposition: inline
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: "linux-dvb" <linux-dvb@linuxtv.org>
Date: Sun, 21 Sep 2008 01:02:26 -0500
MIME-Version: 1.0
Message-Id: <200809210102.26182.vanessaezekowitz@gmail.com>
Subject: Re: [linux-dvb] Kworld PlusTV HD PCI 120 (ATSC 120)
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

Fourth in the thread...

----- Text Import Begin -----

Subject: Re: Kworld PlusTV HD PCI 120 (ATSC 120)
Date: Saturday 20 September 2008
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: Curt Blank <Curt.Blank@curtronics.com>

On Saturday 20 September 2008 6:28:08 pm, Curt Blank wrote:

> I've got the new computer built, with the 2.6.26.5 kernel, v4l not gen'd
> in and using the latest from the repository.
>
> Using Kradio I still can only listen to it via the Line Out on the 120's
> board.
>
> When I run kaffeine I get a pop up window with this:
>
> No plugin found to handle this resource (/dev/video)
>
> 17:59:33: xine: couldn't find demux for >file:///dev/video<
>
> 17:59:33: xine: found input plugin : file input plugin
>
>
> When I run xawtv I get this:
>
> # xawtv
> This is xawtv-3.95, running on Linux/x86_64 (2.6.26.5-touch)
> xinerama 0: 1024x768+0+0
> /dev/video0 [v4l2]: no overlay support
> v4l-conf had some trouble, trying to continue anyway
> ioctl: VIDIOC_REQBUFS(count=2;type=VIDEO_CAPTURE;memory=MMAP): Success
> ioctl: VIDIOC_REQBUFS(count=2;type=VIDEO_CAPTURE;memory=MMAP): Resource
> temporarily unavailable
>
>
> And I still get the "Unable to grab video." pop up form kdetv.
>
> Ideas? Am I missing something?
>
> I blacklisted cx8800, cx8802, cx88-alsa, & cx88-dvb on boot, then moved
> the blacklist file then only modprobed cx8800. That and cx88xx are the
> only ones loaded.
>
> I have this in my modprobe.d/tv file:
>
> alias char-major-81 videodev
> options i2c-algo-bit bit_test=1
>
> alias char-major-81-0 cx8800
> alias char-major-81-1 off
> alias char-major-81-2 off
> alias char-major-81-3 off
>
> Thanks.

Something odd is happening then - there should be a fair number of other 
modules that got brought in with cx8800, like tuner_xc2028, tuner, 
v4l2_common, videodev, and others.

Can you copy&paste dmesg and lsmod outputs as they look after a fresh reboot 
and having loaded the modules?

I also have a feeling I'm wrong about cx88-alsa not being needed...

V4l team:  Is or is not cx88-alsa still part of the usual modules that must be 
loaded (either manually or automatically)?  If it is, did something merely 
break recently that made it disappear from the output of the build?

/me is confused.

----- Text Import End -----

-- 
"Life is full of positive and negative events.  Spend
your time considering the former, not the latter."
Vanessa Ezekowitz <vanessaezekowitz@gmail.com>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
