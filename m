Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38730 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964868Ab3BMVOt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 16:14:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1U5jfT-0006rC-VY
	for linux-media@vger.kernel.org; Wed, 13 Feb 2013 22:15:06 +0100
Received: from 63-192-50-82.ded.pbi.net ([63-192-50-82.ded.pbi.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2013 22:15:03 +0100
Received: from lgirlea by 63-192-50-82.ded.pbi.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2013 22:15:03 +0100
To: linux-media@vger.kernel.org
From: Lucian <lgirlea@netzero.com>
Subject: Re: Chipset change for =?utf-8?b?Q1g4OF9CT0FSRF9QSU5OQUNMRV9QQ1RWX0hEXzgwMGk=?=
Date: Wed, 13 Feb 2013 19:38:10 +0000 (UTC)
Message-ID: <loom.20130213T201540-715@post.gmane.org>
References: <4FE24132.4090705@gmail.com> <CAGoCfixL-tEFq4SpjxChH7uc0aDZGtdoO6EqrEH3tzPzoTqK8w@mail.gmail.com> <4FE3A3A6.5050500@gmail.com> <CAGoCfiympaYxeypnq0uuX_azsHhk3OFuLu-=r0yEvOz51Eznqw@mail.gmail.com> <4FE4956D.6040206@gmail.com> <CAGoCfix-kx89NgTue_ypr=yEiXSu1SzNZHQXn0vxjo9GYKPM1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller <dheitmueller <at> kernellabs.com> writes:

> 
> On Fri, Jun 22, 2012 at 11:55 AM, Mack Stanley <mcs1937 <at> gmail.com> wrote:
> > So, keeping all of the configuration settings exactly the same and
> > simply using s5h1411_attach instead of s5h1409_attach works perfectly.
> > Maybe the easiest path is just to have the driver try one, if it fails,
> > try the other.
> 
> I actually don't have a sample of the new board, so if you wanted to
> submit a patch upstream which does the following, that would be great:
> 
> 1.  in cx88-dvb.c, do the dvb_attach() call against the s5h1409 just
> as it was before
> 2.  If the dvb_attach() call returns NULL for the 1409, make the
> attach call against the s5h1411.
> 
> Submit it to the linux-media mailing list to to solicit people willing
> to test.  This is mostly to make sure that it doesn't break the 1409
> based boards.  By doing the 1409 attach first, there is a high
> likelihood that it won't cause a regression (if you did the 1411
> attach first, there is greater risk that you will cause breakage for
> the 1409 boards).
> 
> Be sure to include the "Signed-Off-By" line which is a requirement for
> it to be accepted upstream.  I'll eyeball the patch and put a
> "Reviewed-by" line on it.
> 
> Devin
> 

Hi,

Was there any progress on including the support for PCTV 800i S5H1411 based?

I have two such boards, both using S5H1411 and up until recently I was patching
the driver as instructed here:
http://forums.fedoraforum.org/showpost.php?s=3e6dd6214edd1145b5df6336d10ff941&p=1586999&postcount=9
A week ago, openSUSE 12.2 updated the kernel to 3.4.28-2.20 and now building the
v4l drivers from git results in kernel panic.(I had to restore the system from
an image backup).

Even before, there was always a problem with building from source; when doing
that the kernel reports /lib/modules/3.x.x-desktop is inconsistent and this
prevents other drivers from installing (i.e. nvidia). 
This happens on a few different systems when using the instructions from here:
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

Any suggestion appreciated.

Thank you,
Lucian


