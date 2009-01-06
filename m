Return-path: <video4linux-list-bounces@redhat.com>
From: Andy Walls <awalls@radix.net>
To: Dale Pontius <DEPontius@edgehp.net>
In-Reply-To: <49616EC6.30702@edgehp.net>
References: <495E7328.6080600@edgehp.net>
	<1231092492.3125.25.camel@palomino.walls.org>
	<49616EC6.30702@edgehp.net>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 20:19:14 -0500
Message-Id: <1231204754.3110.39.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: cx18 short-term resource available
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-01-04 at 21:21 -0500, Dale Pontius wrote:
> Andy Walls wrote:
> > On Fri, 2009-01-02 at 15:03 -0500, Dale Pontius wrote:

> > 
> > Well, I haven't moved on making the IR blaster work better at all.
> > Users have reported that the modified lirc_pvr150 module and stock
> > lirc_pvr150 "firmware" image work.  It doesn't have the latest STB codes
> > though.
> > 
> Where do I get this modified lirc_pvr150?

You get the latest lirc_pvr150 and hope this old patch works:

--- lirc/drivers/lirc_pvr150/lirc_pvr150.c.orig	2008-06-22 20:04:23.000000000 -0400
+++ lirc/drivers/lirc_pvr150/lirc_pvr150.c	2008-06-22 20:25:49.000000000 -0400
@@ -67,6 +67,7 @@
 /* We need to be able to reset the crappy IR chip by talking to the ivtv driver */
 struct ivtv;
 void ivtv_reset_ir_gpio(struct ivtv *itv);
+void cx18_reset_ir_gpio(void *data);
 
 struct IR 
 {
@@ -197,7 +198,12 @@ static int add_to_buf(struct IR *ir)
 			printk(KERN_ERR "lirc_pvr150: polling the IR receiver "
 			                "chip failed, trying reset\n");
 			
-			ivtv_reset_ir_gpio(i2c_get_adapdata(ir->c_rx.adapter));
+			if (strncmp(ir->c_rx.name, "cx18", 4)) 
+				ivtv_reset_ir_gpio(
+					i2c_get_adapdata(ir->c_rx.adapter));
+			else
+				cx18_reset_ir_gpio(
+					i2c_get_adapdata(ir->c_rx.adapter));
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule_timeout((100 * HZ + 999) / 1000);
 			ir->need_boot = 1;
@@ -983,7 +989,12 @@ static ssize_t write(struct file *filep,
 				up(&ir->lock);
 				return ret;
 			}
-			ivtv_reset_ir_gpio(i2c_get_adapdata(ir->c_tx.adapter));
+			if (strncmp(ir->c_tx.name, "cx18", 4)) 
+				ivtv_reset_ir_gpio(
+					i2c_get_adapdata(ir->c_tx.adapter));
+			else
+				cx18_reset_ir_gpio(
+					i2c_get_adapdata(ir->c_tx.adapter));
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule_timeout((100 * HZ + 999) / 1000);
 			ir->need_boot = 1;
@@ -1434,6 +1445,7 @@ int init_module(void)
 {
 	init_MUTEX(&tx_data_lock);
 	request_module("ivtv");
+	request_module("cx18");
 	request_module("firmware_class");
 	i2c_add_driver(&driver);
 	return 0;





>   I'm running Gentoo, and have 
> looked in the packages for lirc and ivtv-utils, and haven't found any 
> traces of lirc_pvr150, let alone a tweaked version.

Mark's braindump:

http://www.blushingpenguin.com/mark/blog/?p=24


>   I've also fetched 
> lirc-0.8.4a source, and only find references to the pvr150 in lirc_i2c.

lirc_i2c only supports IR receive.  lirc_pvr150 does both IR Rx and Tx.

>   I found an STB list on the web for lirc_pvr150, and while my STB isn't 
> specifically listed, similar models are, and there's an entry for "Comcast."
> 
> > There was some email on one of the lists about 4-5 months ago for what
> > it would take to snoop off the new codes from the Zilog API in the
> > HVR-1600 Windows driver.  That would allow the lirc_pvr150 module to
> > support the newer STBs with the HVR-1600.
> > 
> I've seen references to that, but no new exchanges on the topic.  I 
> guess I figured the work hadn't gotten off the ground, yet.
> 
> > Ultimately, I want to get rid of the Zilog firmare in the blaster chip
> > and replace it with some home grown stuff.  I still have a ways to go on
> > that.
> > 
> I'll hold off on that, if you please.  Fear of my skill, not yours.  I 
> don't want to brick my card, and charging in with all 10 thumbs is 
> likely to do that, for me.

Sorry.  I wasn't suggesting that.  I'll be the only one bricking cards
until I get the process nailed down. :)


> Still, is there any way I can help any of this with a semi-dedicated 
> dual-boot system?  

In this message, a quote reply from Mark gives the short outline of what
needs to be done to sniff out the newest codes:

http://ivtvdriver.org/pipermail/ivtv-users/2008-July/008487.html

You'll probably want to examine the whole thread.

> I'm doing nothing immediately because of the cold 
> weather and accompanying static, but it's due to warm up this week, and 
> it'll be time to move.  It's been up into the balmy teens yesterday and 
> today, before that it was in single digits plus/minus.  Tomorrow it's 
> supposed to warm to around freezing.  Even with a pot of water on the 
> woodstove, it's been pretty shocking around here, at times.

Wow.  I was out in Iowa once when the overnight temp was -15F in
October.  Where I live rarely gets below 0F even in the worst winters.


>  
> >
> > Try to use the best signal possible:
> > 
> Is there any sort of Linux utility to measure signal strength?  In some 
> of my queries I've seen 100% signal, and I've seen references to a 
> Windows signal strength utility.  I've got a booster/splitter, and right 
> now the gain is at minimum for 100% signal strength on NTSC capture. 
> But I suppose it's possible that 100% means "full limiting" or "AGC 
> engaged", and doesn't necessarily mean anything better than minimum 
> fully usable signal.  I don't know, and until I know more I'm reluctant 
> to move the gain up.  It's entirely possible/likely that this is all 
> Comcast policy.

The mxl5005s digital tuner on the HVR-1600 should be able to support a
signal indication I think.  But the driver doesn't provide anything
right now.  I was hoping Devin H. could get a datasheet from MaxLinear,
so we could get that added.


> > http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality
> > 
> Of course I'm doing pretty much everything wrong.  As I change pieces of 
> infrastructure, I'll take steps to do it the right way.

> > (I need to update that page to take into considerations for avoiding a
> > ground loop with the cable company, but that won't matter for OTA ATSC)

Just remember to not ground the cable company's shield to your earth
ground lest you create a ground loop, from your house to the cable
company, that introduces noise.  According to wikipedia:

http://en.wikipedia.org/wiki/Ground_loop_(electricity)

one would want an isolation transformer (with a frequency response wide
enoguh to cover the entire band) and leave the cable company's coax
shield unterminated (not to your earth ground).  Then on your side of
the isolation transformer, it would be OK to ground the shield for EMI
reduction & lightning protection.


 
> > I don't know about the PixelPro, but the HVR-1600 is performing MPEG
> > compression (using hardware in the CX23418).  You may want to play with
> > the controls and view the results with mplayer until you're happy.
> > 
> The PixelPro is a software card, so MythTV is saving RTJPEG.
> 
> > To list all the controls:
> > 
> > $ v4l2-ctl -d /dev/video0 -L
> > 
> > To get more help on maipulating the controls
> > 
> > $ v4l2-ctl --help
> > 
> Is there some decent one-or-two stop shopping for what the controls 
> mean?  The v4l2-ctl will tell me what the controls are and how to tweak 
> them, but not what most of those names are.  Some of the terms are 
> familiar from following the list, and some are familiar from transcoding 
> prompts.  But that still doesn't educate me about how to tweak them.


Maybe the V4L2 API spec will help you figure out some of them:

http://linuxtv.org/docs.php


But in general:

1.  higher bitrates mean less compression, low bitrates mean more
compression.

2. Constant bit rate means compression is not allowed to burst above
that fixed ceiling to preserve quality.  Variable bitrate means the
engine is allowed to burst higher from time to time to preserve quality.

3. MPEG-1 and MPEG-2 are video encoding specifications.  You'll want
MPEG-2.  Use the PS for stored captures, use the TS for captures you
want to stream over a network.

4. MPEG Layer II refers to audio encoding for MPEG-1 or MPEG-2.  Use
this for now as Dolby AC-3 support for the CX23418 is not complete.

5. The various filters give various effects to the compressed video to
try and remove artifacts while saving space.

> Since I've got 2 HVR-1600 cards, I need to capture a show using MythTV 
> on one, and cat'ing /dev/video2 to a file on the other.  Then transcode 
> the mpeg out of Myth, and I've got 3 versions to compare - in-Myth, 
> direct captured, and exported from Myth.  That should give me some 
> better information.  Right now I suspect it's the way MythTV scales 
> MPEG2 vs RTJPEG to fullscreen.


Transcoding will look crappy.  Just use mplayer to play the file Myth
stores under /var/video/ (or wherever on your system)
 

Have fun.  Stay warm.

Regards,
Andy

> Thanks,
> Dale

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
