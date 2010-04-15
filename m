Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:15960 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569Ab0DOErL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 00:47:11 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@md.metrocast.net>
To: Mark Lord <mlord@pobox.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
In-Reply-To: <4BC64119.5070200@pobox.com>
References: <4B8BE647.7070709@teksavvy.com>
	 <1267493641.4035.17.camel@palomino.walls.org>
	 <4B8CA8DD.5030605@teksavvy.com>
	 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
	 <1268653884.3209.32.camel@palomino.walls.org>  <4BC0FB79.7080601@pobox.com>
	 <1270940043.3100.43.camel@palomino.walls.org>  <4BC1401F.9080203@pobox.com>
	 <1270961760.5365.14.camel@palomino.walls.org>
	 <1270986453.3077.4.camel@palomino.walls.org>  <4BC1CDA2.7070003@pobox.com>
	 <1271012464.24325.34.camel@palomino.walls.org> <4BC37DB2.3070107@pobox.com>
	 <1271107061.3246.52.camel@palomino.walls.org> <4BC3D578.9060107@pobox.com>
	 <4BC3D73D.5030106@pobox.com>  <4BC3D81E.9060808@pobox.com>
	 <1271154932.3077.7.camel@palomino.walls.org>  <4BC466A1.3070403@pobox.com>
	 <1271209520.4102.18.camel@palomino.walls.org> <4BC54569.7020301@pobox.com>
	 <4BC64119.5070200@pobox.com>
Content-Type: text/plain
Date: Thu, 15 Apr 2010 00:46:43 -0400
Message-Id: <1271306803.7643.67.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-04-14 at 18:26 -0400, Mark Lord wrote:
> On 14/04/10 12:32 AM, Mark Lord wrote:
> ..
> > The syslog shows the usual "fallback" messages,
> > but the audio consisted of very loud static, the kind
> > of noise one gets when the sample bits are all reversed.
> >
> > While it was failing, I tried retuning, stopping/starting
> > the recording, etc.. nothing mattered. It wanted a reload
> > of the cx18 driver to cure it.
> ..
> 
> Since all of this happens rather randomly,
> I'm beginning to more strongly suspect a race condition
> somewhere in the driver.
> 
> Now, it's a rather large driver -- lots of complexity in that chip
> -- so it will take me a while to sort through things.

You can at least logically break it into components:

cx18-av-*      : the integrated A/V decoder subdevice (very much like a CX25843)

cx18-gpio*     : logical subdevices for functions controlled by GPIO
cx18-alsa*     : the ALSA interface presented to userspace
cx18-fileops*, cx18-ioctl*, cx18-contorls* : The V4L2 interface
cx18-dvb*      : The DTV interface
cx18-streams*  : main streams management, and empty DMA buffer handover
cx18-queue*    : queue routines used for all queues for all streams
cx18-mailbox*, cx18-scb* : driver-firmware API, main body of hard irq handler for incoming DMA, and workhandler for incoming DMA
cx18-io*       : Insanity to handle CX23418 PCI MMIO quirks
cx18-irq*      : The hard irq handler
cx18-driver*   : main driver probe and shutdown
cx18-cards*    : specifics on each supported card
cx18-firmware* : Bridge and MPEG encoder firmware load and init, but not A/V core firmware
cx18-i2c*      : I2C master setup, bus driving, and device registration
cx18-audio*    : Top level audio routing functions
cx18-video*    : Top level video routing functions
cx18-vbi*      : VBI data extraction


> But at first blush, I don't see any obvious locking around
> the various read-modify-write sequences for the audio registers.

The ioctl handling in the driver does it:

$ grep serialize_lock *

The serialize_lock is a bit overloaded, but it's frequent operational
use is ioctl() serialization.  The A/V core is almost exclusively
manipulated by ioctl()s.  The timer I added for fallback is an
exception.


> And a quick "grep spin *.[ch]" shows a few spin_lock/spin_unlock
> calls in cx18-queue.c and cx18-stream.c (as well as the alsa code,
> which shouldn't be in play in this scenario).

Correct.

What is involved are the three "reset" processes in the cx18-av-* files:

1. Stopping and restarting the microcontroller via register 803
2. Soft reset (of what exactly?) via register 0x810
3. Format detection loop restart via register 0x9cc

I have no idea if 2 & 3 above reset hardware and registers, or simply
set a flag for the microcontroller firmware to notice, or both.

So I've wondered about the exact sequencing of stopping the
microcontoller, peforming the other 2 resets, and restarting the
microcontroller.


> Oddly, none of those spinlocks use _irq or _irq_save/restore,
> which means they aren't providing any sort of mutual exclusion
> against the interrupt handler.

There is no need.  The hard irq handler only really deals with firmware
mailbox ack and firmware mailbox ready notifications.  It sucks off the
mailbox contents and shoves it over to the cx18-NN-in workhandler via
work orders placed on a workqueue.  The work handler does grab the
spinlocks, but it is from a non-irq context.


> But like I said, I'm only just beginning to look more closely now.

Look at the publicly available CX25843 datasheet:

	http://dl.ivtvdriver.org/

pages 107-116 and Section 5.7.  In figure 3.30 we've got SIF coming in
from the analog tuner and the microcontoller is represented by the "Auto
Std/Mode Detection" block.  In figure 3-38 the output of the "source
select" block is what then gets fed to the baseband processing chain as
digital audio from the tuner.



For reference, you may want to also grab FCC docment OET60 (Rev A from
1996?), which technically describes the BTSC audio subcarriers.  Then
Google for a nice pciture of the MTS/BTSC spectrum.

This app note has a good picture in figure 1:
	http://assets.fluke.com/appnotes/it_products/Anbtsc.pdf
although it is missing the "PRO" channel that is above SAP at 6fh IIRC.

I don't know what part of the BTSC spectrum the Conexant microcontroller
is keying off of, but I guessing the pilot for sure is part of the
decision process.

Regards,
Andy

