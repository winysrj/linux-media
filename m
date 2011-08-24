Return-path: <linux-media-owner@vger.kernel.org>
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:56219 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750951Ab1HXVnB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 17:43:01 -0400
Subject: Re: [PATCH 06/14] [media] cx18: Use current logging styles
From: Joe Perches <joe@perches.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <1314182047.2253.3.camel@palomino.walls.org>
References: <cover.1313966088.git.joe@perches.com>
	 <29abc343c4fce5d019ce56f5a3882aedaeb092bc.1313966089.git.joe@perches.com>
	 <1314182047.2253.3.camel@palomino.walls.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 14:42:55 -0700
Message-ID: <1314222175.15882.8.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2011-08-24 at 06:34 -0400, Andy Walls wrote:
> On Sun, 2011-08-21 at 15:56 -0700, Joe Perches wrote:
> > Add pr_fmt.
> > Convert printks to pr_<level>.
> > Convert printks without KERN_<level> to appropriate pr_<level>.
> > Removed embedded prefixes when pr_fmt was added.
> > Use ##__VA_ARGS__ for variadic macros.
> > Coalesce format strings.
> 1. It is important to preserve the per-card prefixes emitted by the
> driver: cx18-0, cx18-1, cx18-2, etc.  With a quick skim, I think your
> change preserves the format of all output messages (except removing
> periods).  Can you confirm this?

Here's the output diff of
strings built-in.o | grep "^<.>" | sort
new and old
$ diff -u0 cx18.old cx18.new
--- cx18.old	2011-08-24 13:18:41.000000000 -0700
+++ cx18.new	2011-08-24 14:04:10.000000000 -0700
@@ -1,2 +1,9 @@
-<3>cx18-alsa cx is NULL
-<3>cx18-alsa: %s: struct v4l2_device * is NULL
+<3>cx18_alsa: cx is NULL
+<3>cx18_alsa: %s-alsa: %s: failed to create struct snd_cx18_card
+<3>cx18_alsa: %s-alsa: %s: snd_card_create() failed with err %d
+<3>cx18_alsa: %s-alsa: %s: snd_card_register() failed with err %d
+<3>cx18_alsa: %s-alsa: %s: snd_cx18_card_create() failed with err %d
+<3>cx18_alsa: %s-alsa: %s: snd_cx18_pcm_create() failed with err %d
+<3>cx18_alsa: %s-alsa: %s: snd_cx18_pcm_create() failed with err %d
+<3>cx18_alsa: %s-alsa: %s: struct snd_cx18_card * already exists
+<3>cx18_alsa: %s: struct v4l2_device * is NULL
@@ -17,7 +23,0 @@
-<3>%s-alsa: %s: failed to create struct snd_cx18_card
-<3>%s-alsa: %s: snd_card_create() failed with err %d
-<3>%s-alsa: %s: snd_card_register() failed with err %d
-<3>%s-alsa: %s: snd_cx18_card_create() failed with err %d
-<3>%s-alsa: %s: snd_cx18_pcm_create() failed with err %d
-<3>%s-alsa: %s: snd_cx18_pcm_create() failed with err %d
-<3>%s-alsa: %s: struct snd_cx18_card * already exists
@@ -62 +62 @@
-<3>%s: Prefix your subject line with [UNKNOWN CX18 CARD].
+<3>%s: Prefix your subject line with [UNKNOWN CX18 CARD]
@@ -80 +80 @@
-<4>%s-alsa: %s: struct snd_cx18_card * is NULL
+<4>cx18_alsa: %s-alsa: %s: struct snd_cx18_card * is NULL
@@ -82 +82 @@
-<4>%s: Could not register GPIO reset controllersubdevice; proceeding anyway.
+<4>%s: Could not register GPIO reset controller subdevice; proceeding anyway.
@@ -85 +85 @@
-<4>%s: MPEG Index stream cannot be claimed directly, but something tried.
+<4>%s: MPEG Index stream cannot be claimed directly, but something tried
@@ -99,12 +99,14 @@
-<6>cx18-alsa: module loading...
-<6>cx18-alsa: module unload complete
-<6>cx18-alsa: module unloading...
-<6>cx18-alsa-pcm %s: Allocating vbuffer
-<6>cx18-alsa-pcm %s: cx18 alsa announce ptr=%p data=%p num_bytes=%zd
-<6>cx18-alsa-pcm %s: dma area was NULL - ignoring
-<6>cx18-alsa-pcm %s: freeing pcm capture region
-<6>cx18-alsa-pcm %s: runtime was NULL
-<6>cx18-alsa-pcm %s: %s called
-<6>cx18-alsa-pcm %s: %s: length was zero
-<6>cx18-alsa-pcm %s: stride is zero
-<6>cx18-alsa-pcm %s: substream was NULL
+<6>cx18_alsa: module loading...
+<6>cx18_alsa: module unload complete
+<6>cx18_alsa: module unloading...
+<6>cx18_alsa: %s: Allocating vbuffer
+<6>cx18_alsa: %s: created cx18 ALSA interface instance 
+<6>cx18_alsa: %s: cx18 alsa announce ptr=%p data=%p num_bytes=%zd
+<6>cx18_alsa: %s: dma area was NULL - ignoring
+<6>cx18_alsa: %s: freeing pcm capture region
+<6>cx18_alsa: %s: PCM stream for card is disabled - skipping
+<6>cx18_alsa: %s: runtime was NULL
+<6>cx18_alsa: %s: %s called
+<6>cx18_alsa: %s: %s: length was zero
+<6>cx18_alsa: %s: stride is zero
+<6>cx18_alsa: %s: substream was NULL
@@ -172 +174 @@
-<6>%s:  info: dualwatch: change stereo flag from 0x%x to 0x%x.
+<6>%s:  info: dualwatch: change stereo flag from 0x%x to 0x%x
@@ -188 +190 @@
-<6>%s:  info: Preparing for firmware halt.
+<6>%s:  info: Preparing for firmware halt
@@ -206 +208 @@
-<6>%s:  info: Switching standard to %llx.
+<6>%s:  info: Switching standard to %llx
@@ -236 +237,0 @@
-<6>%s: %s: created cx18 ALSA interface instance 
@@ -239 +239,0 @@
-<6>%s: %s: PCM stream for card is disabled - skipping

> 2. PLease don't add a pr_fmt() #define to exevry file.  Just put one
> where all the other CX18_*() macros are defined.  Every file picks those
> up.

It's not the first #include of every file.
printk.h has a default #define pr_fmt(fmt) fmt

