Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40982 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaJETis (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Oct 2014 15:38:48 -0400
Received: by mail-wi0-f177.google.com with SMTP id fb4so2791618wid.16
        for <linux-media@vger.kernel.org>; Sun, 05 Oct 2014 12:38:46 -0700 (PDT)
Message-ID: <54319E45.3050906@googlemail.com>
Date: Sun, 05 Oct 2014 21:38:45 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Upcoming v4l-utils 1.6.0 release
References: <20140925213820.1bbf43c2@recife.lan>	<54269807.50109@googlemail.com>	<20140927085455.5b0baf89@recife.lan>	<542ACA32.3050403@googlemail.com>	<542ADA66.3040905@redhat.com> <20141004112245.7a5de7de@recife.lan>
In-Reply-To: <20141004112245.7a5de7de@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 04/10/14 16:22, Mauro Carvalho Chehab wrote:
> Em Tue, 30 Sep 2014 18:29:26 +0200
> Hans de Goede <hdegoede@redhat.com> escreveu:
>> About the 1.6.0 release, please do not release it until the series
>> fixing the regression in 1.4.0 with gstreamer which I've posted
>> today. A review of that series would be appreciated. If you're ok
>> with the series feel free to push it to master.

I pushed the changes to master ans built a Debian package with the
changes. The bug reported verified that it properly fixed the bug.

> From my side, I'm happy with the changes made at libdvbv5 side.
> 
> I did several changes during this week:
> 
> - Added user pages for the 4 dvbv5 tools;
> - Cleaned up all Valgrind errors;
> - Cleaned up a nasty double-free bug;
> - Solved all the issues pointed for it at Coverity.
> - Added the package version on all section 1 man pages. Those are now
>   created during ./configure.
> 
> I also did some tests here with DVB-C and ISDB-T and everything seems to
> be working fine.
> 
> So, at least from dvbv5 utils and libdvbv5, I think we're ready for
> version 1.6.

I made some changes to the man pages to silence Lintian warnings and put
the release stamp on the tree.

Thanks,
Gregor
