Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:64396 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416Ab0DPNAt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Apr 2010 09:00:49 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@md.metrocast.net>
To: Mark Lord <mlord@pobox.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
In-Reply-To: <4BC6A135.4070400@pobox.com>
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
	 <4BC64119.5070200@pobox.com> <1271306803.7643.67.camel@palomino.walls.org>
	 <4BC6A135.4070400@pobox.com>
Content-Type: text/plain
Date: Fri, 16 Apr 2010 08:59:26 -0400
Message-Id: <1271422766.3086.33.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-04-15 at 01:16 -0400, Mark Lord wrote:
> On 15/04/10 12:46 AM, Andy Walls wrote:
> > On Wed, 2010-04-14 at 18:26 -0400, Mark Lord wrote:
> .
> 
> Mmmm.. but it does do read-modify-write on several registers inside the IRQ handling.
> I suppose those might be "safe" groups, written to _only_ by the IRQ handler,
> but maybe not.

In the linux driver, the registers in CX23418 address range:

	0x2c40000-0x2c409ff

are only written to by the files named cx18-av-*[ch], which is mostly
ioctl() call driven.  (Those registers are logically mapped by the linux
driver code to 0x000-0x9ff to make the integrated A/V decoder look like
a CX25843 chip for convenience.)

Accesses to those are orthognal to the rest of the cx18 driver,
including the IRQ handler.  (I agree, its hard to follow things in the
driver; it's very large.)

Do note, however, that the audio standard detection microcontroller
*does* write to the registers in 0x800-0x9ff *independent* of the linux
cx18 driver.

Locking with respect to the microcontroller would mean halting and
restarting the microcontroller.  I don't know if that causes it to reset
or not, and I do not know how it affects it's internal timers.

Regards,
Andy



