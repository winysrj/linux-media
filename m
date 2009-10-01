Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:54187 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204AbZJAKmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2009 06:42:10 -0400
Date: Thu, 1 Oct 2009 12:42:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: =?UTF-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Cc: "Andy Walls" <awalls@radix.net>, linux-kernel@vger.kernel.org,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [2.6.31] ir-kbd-i2c oops.
Message-ID: <20091001124210.4be1dd71@hyperion.delvare>
In-Reply-To: <op.u039i6wbzu3k57@pawels.alatek.krakow.pl>
References: <200909160300.28382.pluto@agmk.net>
	<200909161003.33090.pluto@agmk.net>
	<20090929161629.2a5c8d30@hyperion.delvare>
	<200909301016.15327.pluto@agmk.net>
	<20090930125737.704413c8@hyperion.delvare>
	<1254354167.4771.7.camel@palomino.walls.org>
	<20091001120609.50327134@hyperion.delvare>
	<op.u039i6wbzu3k57@pawels.alatek.krakow.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 01 Oct 2009 12:17:20 +0200, Paweł Sikora wrote:
> Dnia 01-10-2009 o 12:06:09 Jean Delvare <khali@linux-fr.org> napisał(a):
> 
> >> I'm not sure if it is the problem here, but it may be prudent to check
> >> that there's no mismatch between the module and the structure
> >> definitions being pulled in via "#include"  (maybe by stopping gcc after
> >> the preprocessing with -E ).
> >
> > Thanks for the hint. As far as I can see, this change is new in kernel
> > 2.6.32-rc1. In 2.6.31, which is where Pawel reported the issue, we
> > still have IR_KEYTAB_TYPE.
> >
> > Pawel, are you by any chance mixing kernel drivers of different
> > sources?
> 
> everything is under control. i've two separated builds:
> - 2.6.31 from git with debugging patch.
> - vendor kernel from rpms.
> both kernels have separated initrd images for easy booting/testing.

And both have the problem you reported?

-- 
Jean Delvare
