Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:44307 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752331AbbBYDpx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 22:45:53 -0500
Message-ID: <1424835950.11070.5.camel@perches.com>
Subject: Re: [PATCH] media: em28xx replace printk in dprintk macros
From: Joe Perches <joe@perches.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Feb 2015 19:45:50 -0800
In-Reply-To: <54ED0C0D.10704@osg.samsung.com>
References: <1424804027-7790-1-git-send-email-shuahkh@osg.samsung.com>
	 <20150224190315.124b71f3@recife.lan> <54ED0C0D.10704@osg.samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2015-02-24 at 16:41 -0700, Shuah Khan wrote:
> On 02/24/2015 03:03 PM, Mauro Carvalho Chehab wrote:
> > Em Tue, 24 Feb 2015 11:53:47 -0700 Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> >> Replace printk macro in dprintk macros in em28xx audio, dvb,
> >> and input files with pr_* equivalent routines.
[]
> >> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
[]
> >>  #define dprintk(fmt, arg...) \
> >>  	if (ir_debug) { \
> >> -		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
> >> +		pr_debug("%s/ir: " fmt, ir->name, ## arg); \
> > 
> > NACK.
> > 
> > This is the worse of two words, as it would require both to enable
> > each debug line via dynamic printk setting and to enable ir_debug.
> Ah. I missed that. Sorry for the noise.

It's
At some point, I'm going to propose a standard mechanism
similar to netif_<level> that does bitmap matching for
dynamic_debug and generic debugging.



