Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59187 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934734AbbLQOIf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 09:08:35 -0500
Date: Thu, 17 Dec 2015 12:08:30 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Mason <slash.tmp@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: Automatic device driver back-porting with media_build
Message-ID: <20151217120830.0fc27f01@recife.lan>
In-Reply-To: <5672BE15.9070006@free.fr>
References: <5672A6F0.6070003@free.fr>
	<20151217105543.13599560@recife.lan>
	<5672BE15.9070006@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Dec 2015 14:52:21 +0100
Mason <slash.tmp@free.fr> escreveu:

> Hello Mauro,
> 
> On 17/12/2015 13:55, Mauro Carvalho Chehab wrote:
> 
> > Mason wrote:
> > 
> >> I have a TechnoTrend TT-TVStick CT2-4400v2 USB tuner, as described here:
> >> http://linuxtv.org/wiki/index.php/TechnoTrend_TT-TVStick_CT2-4400
> >>
> >> According to the article, the device is supported since kernel 3.19
> >> and indeed, if I use a 4.1 kernel, I can pick CONFIG_DVB_USB_DVBSKY
> >> and everything seems to work.
> >>
> >> Unfortunately (for me), I've been asked to make this driver work on
> >> an ancient 3.4 kernel.
> >>
> >> The linuxtv article mentions:
> >>
> >> "Drivers are included in kernel 3.17 (for version 1) and 3.19 (for version 2).
> >> They can be built with media_build for older kernels."
> >> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >>
> >> This seems to imply that I can use the media_build framework to
> >> automatically (??) back-port a 3.19 driver to a 3.4 kernel?
> > 
> > "automatically" is a complex word ;)
> 
> If I get it working, I think you can even say "auto-magically" ;-)
> 
> >> This sounds too good to be true...
> >> How far back can I go?
> > 
> > The goal is to allow compilation since 2.6.32, but please notice that
> > not all drivers will go that far. Basically, when the backport seems too
> > complex, we just remove the driver from the list of drivers that are
> > compiled for a given legacy version.
> > 
> > Se the file v4l/versions.txt to double-check if the drivers you need
> > have such restrictions. I suspect that, in the specific case of
> > DVB_USB_DVBSKY, it should compile.
> 
> That is great news.
> 
> > That doesn't mean that it was tested there. We don't test those
> > backports to check against regressions. We only work, at best
> > effort basis, to make them to build. So, use it with your own
> > risk. If you find any problems, feel free to send us patches
> > fixing it.
> 
> My first problem is that compilation fails on the first file ;-)
> See attached log.
> 
> My steps are:
> 
> cd media_build/linux
> make tar DIR=/tmp/sandbox/media_tree
> make untar
> cd ..
> make release DIR=/tmp/sandbox/custom-linux-3.4
> make
> 
> I will investigate and report back.

Then I guess you're not using vanilla 3.4 Kernel, but some heavily
modified version. You're on your own here.

Regards,
Mauro
