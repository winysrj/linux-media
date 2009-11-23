Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:62146 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392AbZKWMeE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 07:34:04 -0500
Subject: Re: cx18: Reprise of YUV frame alignment improvements
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
In-Reply-To: <1258978370.3058.25.camel@palomino.walls.org>
References: <1257913905.28958.32.camel@palomino.walls.org>
	 <829197380911221904uedc18e5qbc9a37cfcee23b5d@mail.gmail.com>
	 <1258978370.3058.25.camel@palomino.walls.org>
Content-Type: text/plain
Date: Mon, 23 Nov 2009 07:32:47 -0500
Message-Id: <1258979567.3058.30.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-11-23 at 07:12 -0500, Andy Walls wrote:
> On Sun, 2009-11-22 at 22:04 -0500, Devin Heitmueller wrote:
> > On Tue, Nov 10, 2009 at 11:31 PM, Andy Walls <awalls@radix.net> wrote:
> > > OK, here's my second attempt at getting rid of cx18 YUV frame alignment
> > > and tearing issues.
> > >
> > >        http://linuxtv.org/hg/~awalls/cx18-yuv2
> > 
> > Hi Andy,
> > 
> > I did some testing of your tree, using the following command
> > 
> > mplayer /dev/video32 -demuxer rawvideo -rawvideo w=720:h=480:format=hm12:ntsc
> > 
> > and then in parallel run a series of make commands of the v4l-dvb tree
> > 
> > make -j2 && make unload && make -j2 && make unload && make -j2 && make
> > unload && make -j2 && make unload
> > 
> > I was definitely seeing the corruption by doing this test before your
> > patches (both frame alignment and colorspace problems as PCI frames
> > were being dropped).  After your change, I no longer see those
> > problems.  The picture never became misaligned.
> 
> Great.  Thanks for the test.
> 
> 
> >  However, it would
> > appear that some sort of regression may have been introduced with the
> > buffer handling.
> > 
> > I was seeing a continuous reporting of the following in dmesg, even
> > *after* I stopped generating the load by running the make commands.
> > 
> > [ 5175.703811] cx18-0: Could not find MDL 106 for stream encoder YUV
> > [ 5175.737380] cx18-0: Could not find MDL 111 for stream encoder YUV
> > [ 5175.804317] cx18-0: Skipped encoder YUV, MDL 96, 3 times - it must
> > have dropped out of rotation
> > [ 5175.804324] cx18-0: Skipped encoder YUV, MDL 101, 3 times - it must
> > have dropped out of rotation
> > [ 5175.904500] cx18-0: Skipped encoder YUV, MDL 96, 2 times - it must
> > have dropped out of rotation
> > [ 5176.204507] cx18-0: Skipped encoder YUV, MDL 101, 1 times - it must
> > have dropped out of rotation
> > [ 5176.204513] cx18-0: Skipped encoder YUV, MDL 96, 1 times - it must
> > have dropped out of rotation
> > [ 5176.204518] cx18-0: Could not find MDL 111 for stream encoder YUV
> 
> Congratulations, you're seeing my buffer notification consistency check
> and sweep-up code in action.
> 
> In the early days of cx18 maintenance by me, the driver would stop
> "capturing" a stream after anywhere from an hour to an hour and a half -
> black screen in MythTV.  The original (current?) problem had a few
> components:
> 
> 1. There is only *one* CPU2EPU mailbox and all DMA_DONE notifications
> come through it.
> 
> 2. The CX23418 firmware does not wait long, at all, for you to pick up
> and acknowledge the CPU2EPU mailbox.  It is a shorter window when you
> have multiple streams running.
> 
> 3. If you cleanly miss an MDL notification, you don't know which MDL you
> missed and you don't know how many bytes were used in it.  You drop it.
> 
> 4. If you get a half written mailbox, like in your MDL 111 message
> above, then you have a mailbox consistency problem which is logged, but
> you also drop the MDL.
> 
> 5. If you don't give an MDL back to the firmware, it never uses it
> again.  That's why you see the sweep-up log messages.  As soon as an MDL
> is skipped *on the order of the depth* of q_busy times, when looking for
> the currently DMA_DONE'd MDL, that skipped MDL must have been dropped.
> It is picked up and put back into rotation then.
> 
> 
> I will note that skipping an MDL 1 time and sweeping it up indicates the
> CX23418 firmware (q_busy) doesn't have a lot of MDLs to work with for
> that stream.  You need to devote more memory to that stream or have the
> application read them off faster (so the MDL goes from q_full to q_free
> to q_busy).
> 
> 
> 
> > I would expect to see frame drops while the system was under high
> > load, but I would expect that the errors would stop once the load fell
> > back to something reasonable.  However, they continue to accumulate
> > even after the make commands stop and the only thing running on the
> > system is mplayer (with a CPU load of around 10%).
> 
> You likely have:
> 
> 1. a system-level interrupt handler latency problem
> 
> and/or
> 
> 2. the cx18-NN-out/M workrer threads aren't being woken up often enough
> to give MDL's back to the CX23418 firmware fast enough.

One other possibility:

3. Once mplayer got behind, it stayed behind to render frames on a
smooth timeline.  That means more MDLs are intentionally being held on
q_full by the application.


> For #1, if there is a linux driver sharing the CX23418 interrupt line
> (as shown by cat /proc/interrupts) then try unloading that driver,
> moving the CX23418 to another PCI slot, or somehow else keeping some
> other linux device driver from masking the CX23418's IRQ line for too
> long.  The ahci disk controller driver is a known culprit with a time
> consuming error path in the top half of its IRQ handler.
> 
> The easy solution to #2 is give enough memory for a few more MDLs for
> that stream with module parameters.


For number 3, for the YUV stream, we can make the assumption we can
steal the 2nd MDL from the front of q_full and give it back to q_busy in
low depth of q_busy situations.  That will result in a forceably dropped
old frame for the application.

Regards,
Andy

> > I think this tree is definitely on the right track, but it looks like
> > some edge case has been missed.
> 
> What you see is normal.  I can take a look at things, but it's generally
> a system level issue.  One thing that can be done in the cx18 driver is
> to optimize the paths called by the out_work_handler, so that MDLs get
> back to the firmware with a minimum of delay. 
> 
> It's never been a big deal, with lots of MDLs for a stream, to have one
> or two MDLs tied up.  With YUV only having very few MDLs, having an MDL
> tied up, not being given back to the firmware promptly, could ba a
> problem.
> 
> Regards,
> Andy
> 
> > Devin
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

