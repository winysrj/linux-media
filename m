Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:55244 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbaIOXxa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 19:53:30 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBY00ML9VP5PR30@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 19:53:29 -0400 (EDT)
Date: Mon, 15 Sep 2014 20:53:24 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: v4l2 ioctls
Message-id: <20140915205324.1eb58ca8.m.chehab@samsung.com>
In-reply-to: <54177328.1050007@osg.samsung.com>
References: <54124BDC.3000306@osg.samsung.com> <5412A9DB.8080701@xs4all.nl>
 <20140912121950.7edfee4e.m.chehab@samsung.com>
 <541391B9.4070708@osg.samsung.com>
 <20140915085458.1faea714.m.chehab@samsung.com>
 <54177328.1050007@osg.samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 15 Sep 2014 17:15:52 -0600
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 09/15/2014 05:54 AM, Mauro Carvalho Chehab wrote:
> > Hi Shuah,
> > 
> > Em Fri, 12 Sep 2014 18:37:13 -0600
> > Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> > 
> >> Mauro/Hans,
> >>
> >> Thanks for both for your replies. I finally have it working with
> >> the following:
> > 
> > One additional info: While in DVB mode, opening the device in
> > readonly mode should not take the tuner locking.
> 
> That's what the code does for dvb. It gets the tuner lock in
> dvb_frontend_start() which is called from dvb_frontend_open()
> when dvb is opened in R/W mode.

Yeah, I think that the FE kthread is only started in R/W mode, 
but it doesn't hurt to double-check it and to do some tests to
avoid regressions.

> > 
> > If you need/want to test it, please use:
> > 	$ dvb-fe-tool --femon
> > 
> > I implemented this functionality this weekend, so you'll need
> > to update your v4l-utils tool to be able to test it.
> > 
> 
> ok - I will update v4l-utils on my system.
> 
> -- Shuah
> 
> 
