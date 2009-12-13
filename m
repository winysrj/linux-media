Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out8.libero.it ([212.52.84.108]:36534 "HELO
	cp-out8.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751892AbZLMJrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2009 04:47:21 -0500
Subject: Re: Adding support for Benq DC E300 camera
From: Francesco Lavra <francescolavra@interfree.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Linux media <linux-media@vger.kernel.org>
In-Reply-To: <20091213094806.239b3b9d@tele>
References: <1260646884.23354.22.camel@localhost>
	 <20091213094806.239b3b9d@tele>
Content-Type: multipart/mixed; boundary="=-Cp4hg59gkzsOxqZ1Pp3E"
Date: Sun, 13 Dec 2009 10:47:15 +0100
Message-Id: <1260697635.23354.31.camel@localhost>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-Cp4hg59gkzsOxqZ1Pp3E
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2009-12-13 at 09:48 +0100, Jean-Francois Moine wrote:
> On Sat, 12 Dec 2009 20:41:24 +0100
> Francesco Lavra <francescolavra@interfree.it> wrote:
> > I'm trying to get my Benq DC E300 camera to work under Linux.
> > It has an Atmel AT76C113 chip. I don't know how many Linux users would
> > benefit from a driver supporting this camera (and possibly other
> > models, too), so my question is: if/when such a driver will be
> > written, is there someone willing to review it and finally get it
> > merged? If the answer is yes, I will try to write something working.
> > 
> > This camera USB interface has 10 alternate settings, and altsetting 5
> > is used to stream data; it uses two isochronous endpoints to transfer
> > an AVI-formatted video stream (320x240) to the USB host.
> > It would be great if someone could give me some information to make
> > writing the driver easier: so far, I have only USB sniffer capture
> > logs from the Windows driver.
> 
> Hi Francesco,
> 
> gspca already handles some cameras and some Benq webcams. From a USB
> snoop, it may be easy to write a new gspca subdriver.
> 
> I join the tcl script I use to extract the important information from
> raw snoop traces. May you send me the result with your logs? Then, I
> could see if an existing subdriver could be used or if a new one has to
> be created.

Hi Jean-Francois, thanks for your interest.
In attachment my log from a video streaming session. As you can see, it
uses altsetting 5 for streaming, while all altsettings from 0 to 9 have
the same isoc endpoints. I have already tried to write a gspca subdriver
for it, but the main gspca driver sets altsetting to 9 for streaming,
which is not appropriate for this device.
But of course I may be missing something, so your help would be very
much appreciated.
Francesco


--=-Cp4hg59gkzsOxqZ1Pp3E
Content-Disposition: attachment; filename=dc_e300.log
Content-Type: text/x-log; name=dc_e300.log; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

<GET 06 0100 0000 12 01 10 01 00 00 00 08 a5 04 35 30 00 00 00 00
<		  00 01
<GET 06 0200 0000 09 02 ef 00 01 01 00 c0 32 09 04 00 00 02 0a ff
<		  00 00 07 05 83 01 40 00 01 07 05 82 01 40 00 01
<		  09 04 00 01 02 0a ff 00 00 07 05 83 01 40 00 01
<		  07 05 82 01 40 00 01 09 04 00 02 02 0a ff 00 00
<GET 06 0200 0000 09 02 ef 00 01 01 00 c0 32 09 04 00 00 02 0a ff
<		  00 00 07 05 83 01 40 00 01 07 05 82 01 40 00 01
<		  09 04 00 01 02 0a ff 00 00 07 05 83 01 40 00 01
<		  07 05 82 01 40 00 01 09 04 00 02 02 0a ff 00 00
<		  07 05 83 01 40 00 01 07 05 82 01 40 00 01 09 04
<		  00 03 02 0a ff 00 00 07 05 83 01 40 00 01 07 05
<		  82 01 40 00 01 09 04 00 04 02 0a ff 00 00 07 05
<		  83 01 40 00 01 07 05 82 01 40 00 01 09 04 00 05
<		  02 0a ff 00 00 07 05 83 01 40 00 01 07 05 82 01
<		  40 00 01 09 04 00 06 02 0a ff 00 00 07 05 83 01
<		  40 00 01 07 05 82 01 40 00 01 09 04 00 07 02 0a
<		  ff 00 00 07 05 83 01 40 00 01 07 05 82 01 40 00
<		  01 09 04 00 08 02 0a ff 00 00 07 05 83 01 40 00
<		  01 07 05 82 01 40 00 01 09 04 00 09 02 0a ff 00
<		  00 07 05 83 01 40 00 01 07 05 82 01 00 00 01
<GET 03 0000 0001 0c 00
<GET 03 0000 0003 3c 00
<GET 03 0000 0004 3c 00
<GET 03 0000 0005 3c 00
<GET 03 0000 0006 3c 00
<GET 03 0000 0007 3c 00
== +14112 ms
== [14200 ms]
 SET 02 0003 0002 
 intf 00 alt 05
== +45 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +4 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +4 ms
1004 isoc
<isoc [32] l:512
<isoc [32] l:576
<isoc [32] l:0
<isoc [32] l:0
4 isoc
 SET 02 003c 0003 
 SET 02 003c 0004 
 SET 02 003c 0005 
 SET 02 003c 0006 
 SET 02 003c 0007 
 intf 00 alt 09
== +15 ms
 SET 02 0003 0002 
 intf 00 alt 05
== +453 ms
== [23029 ms]
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +4 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +20 ms
360 isoc
<isoc [32] l:1536
<isoc [32] l:1600
<isoc [32] l:0
<isoc [32] l:0
4 isoc
== [26691 ms]
 SET 02 003c 0003 
 SET 02 003c 0004 
 SET 02 003c 0005 
 SET 02 003c 0006 
 SET 02 003c 0007 
 intf 00 alt 09
== +127 ms
 SET 02 0003 0002 
 intf 00 alt 05
== +21 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
<isoc [32] l:2048
<isoc [32] l:2048
== +3 ms
== +4 ms
284 isoc
<isoc [32] l:512
<isoc [32] l:576
<isoc [32] l:0
3 isoc
<isoc [32] l:0
1 isoc
 SET 02 003c 0003 
 SET 02 003c 0004 
 SET 02 003c 0005 
 SET 02 003c 0006 
 SET 02 003c 0007 
 intf 00 alt 09

--=-Cp4hg59gkzsOxqZ1Pp3E--

