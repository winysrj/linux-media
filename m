Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38294 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbaI1M5h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 08:57:37 -0400
Date: Sun, 28 Sep 2014 09:57:31 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140928095731.6eb384cb@recife.lan>
In-Reply-To: <20140928115405.GA30490@linuxtv.org>
References: <20140926122721.GA11597@linuxtv.org>
	<20140926101222.778ebcaf@recife.lan>
	<20140926132513.GA30084@linuxtv.org>
	<20140926142543.GA3806@linuxtv.org>
	<54257888.90802@osg.samsung.com>
	<20140926150602.GA15766@linuxtv.org>
	<20140926152228.GA21876@linuxtv.org>
	<20140926124309.558c8682@recife.lan>
	<20140928105540.GA28748@linuxtv.org>
	<20140928081211.4b26aa18@recife.lan>
	<20140928115405.GA30490@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 28 Sep 2014 13:54:05 +0200
Johannes Stezenbach <js@linuxtv.org> escreveu:

> On Sun, Sep 28, 2014 at 08:12:11AM -0300, Mauro Carvalho Chehab wrote:
> > Em Sun, 28 Sep 2014 12:55:40 +0200
> > Johannes Stezenbach <js@linuxtv.org> escreveu:
> > 
> > > I tried again both with and without the patch.  The issue above
> > > odesn't reproduce, but after hibernate it fails to tune
> > > (while it works after suspend-to-ram).  Restarting dvbv5-zap
> > > does not fix it.  All I get is:
> > > 
> > > [  500.299216] drxk: Error -22 on dvbt_sc_command
> > > [  500.301012] drxk: Error -22 on set_dvbt
> > > [  500.301967] drxk: Error -22 on start

I suspect that this is probably because em28xx didn't initialize the GPIOs
after power down. Please try the enclosed (untested) hack.

Regards,
Mauro


diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 9682c52d67d1..3403e775bf43 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1745,6 +1745,10 @@ static int em28xx_dvb_resume(struct em28xx *dev)
 	if (!dev->board.has_dvb)
 		return 0;
 
+
+/* HACK */
+hauppauge_hvr930c_init(dev);
+
 	em28xx_info("Resuming DVB extension");
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
