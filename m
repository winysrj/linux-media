Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm8-vm0.bullet.mail.ird.yahoo.com ([77.238.189.203]:28123 "HELO
	nm8-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751704Ab2GSWh3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 18:37:29 -0400
Message-ID: <1342737448.33090.YahooMailClassic@web29402.mail.ird.yahoo.com>
Date: Thu, 19 Jul 2012 23:37:28 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: patches to media_build, and a few other things
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
In-Reply-To: <50057829.206@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Tue, 17/7/12, Antti Palosaari <crope@iki.fi> wrote:

<snipped>
> > The last one, something for Antti to figure out:
> >
> > - I found that that part of
> backports/api_version.patch, which changes
> LINUX_VERSION_CODE to V4L2_VERSION in
> drivers/media/video/v4l2-ioctl.c, is relocated from line
> 930-ish in http://linux/linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2
> to
> > line 590-ish in Antti's dvb_core branch. So there are
> commits which are in
> > linux-media-LATEST.tar.bz2 and not in Antti's branch or
> vice versa. (so that's any reason who one wants to know how
> linux-media-LATEST.tar.bz2 is made).
> 
> I used Linus 3.5 development tree as a base and rebased it
> continuously 
> to latest rc. Current media_build.git seems to download some
> older 
> files. I could guess it is tar'ed from Kernel 3.4
> /drivers/media/
> 
> Patch which likely breaks backports/api_version.patch is
> that:
> http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg13388.html

No, it is not that. the diff should look like it deletes a chunk of lines around 930 and adds a similar chunk around line 590, spanning a few lines which includes LINUX_VERSION_CODE/V4L2_VERSION .

There shouldn't be any need for guess work - the regular tar ball snapshot is set up by some person, so there should be an authoritative answer...

By the way, I was doing a bit of travelling in the last few days - and got fairly good reception with just the small 5-in aerial in two places; on the 5th floor of a hotel in Brighton (a coastal city in south UK) and the 4th floor by a correct-facing window (same building one floor below interior was crap) local. So it seems that the high you go in UK (or in SE UK), the better. That probably explains why it is so bad in my place - mid-way between two transmitters, and also on the ground floor just outside floodable distance from the local river (i.e. as low in altitude as one can get...).
