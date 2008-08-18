Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KUsBd-0002cy-Av
	for linux-dvb@linuxtv.org; Mon, 18 Aug 2008 02:01:30 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	8B32C180030C
	for <linux-dvb@linuxtv.org>; Mon, 18 Aug 2008 00:00:53 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: "Robert Golding" <robert.golding@gmail.com>
Date: Mon, 18 Aug 2008 10:00:53 +1000
Message-Id: <20080818000053.793B8BE4078@ws1-9.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
 H - DVB Only support
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


> It seems that kernel 2.6.27 (what I was using) is different enough
> that the modules and fw from Stephens downloads won't work properly.

> I went back to 2.6.25 and it worked there, so I tried 2.6.26 and it
> worked there as well.

> These are the steps I had to do so it would load properly;
> 1) Compile kernel WITHOUT 'multimedia'
> i.e. #
> # Multimedia devices
> #
> 
> #
> # Multimedia core support
> #
> # CONFIG_VIDEO_DEV is not set
> # CONFIG_DVB_CORE is not set
> # CONFIG_VIDEO_MEDIA is not set

> #
> # Multimedia drivers
> #
> # CONFIG_DAB is not set

> & reboot with new kernel (if it was the kernel you were already booted
> too, don't bother)

> 2) Download Stephens latest media patches
> #> wget http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.bz2
> extract to current dir, then;
> #> make all
> #> make install

> 3) Download Stephens firmware and follow instructions in
> /Documentation/video4linux/extract_xc3028.pl

> 4) Reboot machine to load all the correct modules and fw, then open
> favourite tuner prog (I use Me-TV) and enjoy the viewing.

> --
> Regards,	Robert

Robert,

I'm glad you got it working.

The v4l-dvb drivers will not work against a kernel that has the video/multimedia drivers compiled in to the kernel.  
When you compile your kernel you select the above options, which you disabled, as modules and this will also allow the v4l-dvb drivers to be compiled as modules and overwrite the older drivers.

If the kernel you were using, that it didn't work against, was part of a distro, perhaps a bug report to them about their kernel config should be sent...

Regards,

Stephen.


-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
