Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:47746 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab1HBP6z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 11:58:55 -0400
Received: from epcpsbgm2.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LPB00AIX5Q0C080@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Aug 2011 00:58:53 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LPB00JNU5Q2KH@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Aug 2011 00:58:54 +0900 (KST)
Date: Tue, 02 Aug 2011 17:58:48 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH] v4l2: Fix documentation of the codec device controls
In-reply-to: <20110802083126.413c07ee.rdunlap@xenotime.net>
To: 'Randy Dunlap' <rdunlap@xenotime.net>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	jaeryul.oh@samsung.com, mchehab@infradead.org
Message-id: <001201cc512d$13e86fc0$3bb94f40$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-language: en-gb
Content-transfer-encoding: 7BIT
References: <1312210299-8040-1-git-send-email-k.debski@samsung.com>
 <20110801102346.0b2b9126.rdunlap@xenotime.net>
 <002401cc50e9$d348d6f0$79da84d0$%debski@samsung.com>
 <20110802083126.413c07ee.rdunlap@xenotime.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Randy Dunlap [mailto:rdunlap@xenotime.net]
> 
> On Tue, 02 Aug 2011 09:57:23 +0200 Kamil Debski wrote:
> 
> > Hi,
> >
> > I am sorry, I did run "make htmldocs" and got no errors. So I have to be
> > doing something wrong building the docs. Could you tell me how do you
> build
> > the documentation? Knowing this I could check the next patch to make sure
> it
> > is error free.
> 
> I'm just running "make htmldocs".  I expect the differences are in what
> versions of tools (or xml reference files etc.) we have installed.
> I'm using fedora 11 (which is fairly old).
> 
> You have done what you should do, so I'll just ignore the warnings etc.
> (and move off of fedora 11 one day).
> 

It just bothers me that I did not get those errors and I think it was important
to correct them. I am using Ubuntu 9.10 and I also feel it might be the time to
upgrade ;)

I have send a second version of the patch so all of the errors should be fixed
now.

Thanks,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

