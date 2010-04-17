Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:50125 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260Ab0DQREf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Apr 2010 13:04:35 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@md.metrocast.net>
To: Mark Lord <mlord@pobox.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
In-Reply-To: <4BC9A507.3080807@pobox.com>
References: <4B8BE647.7070709@teksavvy.com> <4B8CA8DD.5030605@teksavvy.com>
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
	 <4BC6A135.4070400@pobox.com>  <4BC71F86.4020509@pobox.com>
	 <1271479406.3120.9.camel@palomino.walls.org>  <4BC9A507.3080807@pobox.com>
Content-Type: text/plain
Date: Sat, 17 Apr 2010 13:03:44 -0400
Message-Id: <1271523824.3085.9.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-04-17 at 08:09 -0400, Mark Lord wrote:
> On 17/04/10 12:43 AM, Andy Walls wrote:
> > I had to disassemble and study some of the microcontorller firmware, and
> > then reread some documents, to figure out how all the audio detection
> > "resets" must work.
> >
> > I've just pushed some microcontroller reset related changes to the
> > cx18-audio2 repo.  Please test and see if things are better or worse.
> ..
> 
> Mmm.. something is not right -- the audio is failing constantly with that change.

Crud.  I added an additional soft reset using register 0x810 with that
change; maybe that needs to be taken out.


> Perhaps if I could dump out the registers, we might see what is wrong.




> I also tried:
>       v4l2-dbg -d /dev/video1 -c type=host,chip=1 --list-registers=min=0x800,max=0x9ff
> but that fails to read any of the registers (ioctl: VIDIOC_DBG_G_REGISTER failed for 0xXXX).
> 
> I think I'll patch the driver to dump them for us.

Whatever's easiest.  As root, this should work:

# v4l2-dbg -d /dev/video0 -c host1 --list-registers=min=0x800,max=0x9ff
ioctl: VIDIOC_DBG_G_REGISTER

                00       04       08       0C       10       14       18       1C
00000800: 13248000 0000fefe 01010411 20000000 80ff0200 20140905 000031c0 478005d1 
00000820: 80002800 e084e044 007e54a8 240107f2 0186a020 00000000 24010800 0186a020 
00000840: 00000000 00801c00 00000020 00000000 00a14f72 00000030 00000000 00007800 
[...]
000009c0: 80007ffc 00000000 0000c000 00000001 02000200 00000000 00000000 00000000 
000009e0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

Or equivalently with the actual register addresses (vs. the logical remapping using host1):

#  v4l2-dbg -d /dev/video0  --list-registers=min=0x2c40800,max=0x2c409ff
ioctl: VIDIOC_DBG_G_REGISTER

                00       04       08       0C       10       14       18       1C
02c40800: 137d8000 0000fefe 01010411 20000000 80ff0200 20140905 000031c0 478005d1 
02c40820: 80002800 e084e044 007e54a8 240107f2 0186a020 00000000 24010800 0186a020 
02c40840: 00000000 00801c00 00000020 00000000 00a14f72 00000030 00000000 00007800 
[...]
02c409c0: 7ffc27cc 00000000 0000c000 00000001 02000200 00000000 00000000 00000000 
02c409e0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 

Dumps of registers might help me figure out something.


> Thank-you for your work on this.  There are many of us here  hoping
> that we can figure out and fix whatever is wrong with our cards.

No problem.  Sorry for all the shots in the dark so far.  Without a
BTSC/MTS signal source I'm just trying to guess what might be wrong.
(Most VCR's, set top boxes, and RF modulators only seem to put out the
monaural L+R sound signal and not an MTS BTSC signal with the pilot tone
and stereo L-R as well).

Regards,
Andy

