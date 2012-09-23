Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab2IWUEM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 16:04:12 -0400
Date: Sun, 23 Sep 2012 17:03:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: volokh@telros.ru
Cc: Adam Rosi-Kessel <adam@rosi-kessel.org>,
	linux-media@vger.kernel.org, volokh84@gmail.com
Subject: Re: go7007 question
Message-ID: <20120923170313.318f3731@redhat.com>
In-Reply-To: <20120907141831.GA12333@VPir.telros.ru>
References: <5044F8DC.20509@rosi-kessel.org>
	<20120906191014.GA2540@VPir.Home>
	<20120907141831.GA12333@VPir.telros.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 7 Sep 2012 18:18:31 +0400
volokh@telros.ru escreveu:

> On Thu, Sep 06, 2012 at 11:10:14PM +0400, Volokh Konstantin wrote:
> > On Mon, Sep 03, 2012 at 02:37:16PM -0400, Adam Rosi-Kessel wrote:
> > > 
> > > [469.928881] wis-saa7115: initializing SAA7115 at address 32 on WIS
> > > GO7007SB EZ-USB
> > > 
> > > [469.989083] go7007: probing for module i2c:wis_saa7115 failed
> > > 
> > > [470.004785] wis-uda1342: initializing UDA1342 at address 26 on WIS
> > > GO7007SB EZ-USB
> > > 
> > > [470.005454] go7007: probing for module i2c:wis_uda1342 failed
> > > 
> > > [470.011659] wis-sony-tuner: initializing tuner at address 96 on WIS
> > > GO7007SB EZ-USB
> Hi, I generated patchs, that u may in your own go7007/ folder
> It contains go7007 initialization and i2c_subdev fixing
> 
> It was checked for 3.6 branch (compile only)

Sorry, but I don't know what do you intend with this post. 

I can't merge this patch upstream for a number of reasons:

	- There's no Signed-off-by: on this patch;
	- There's no description explaining what is there
	  at the patch;
	- the patch looks too complex - it is hard to believe
	  that this is a single functional change. Merging
	  lots of stuff into the same patch makes hard for it
	  to be reviewed, so please break it into a proper,
	  well-described patch series;
	- scripts/checkpatch.pl also didn't like the patch:
		ERROR: Missing Signed-off-by: line(s)
		total: 5 errors, 44 warnings, 393 lines checked

Please fix it.

Thanks!
Mauro
