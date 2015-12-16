Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:35993 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbbLPUVU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 15:21:20 -0500
Received: by mail-lf0-f47.google.com with SMTP id z124so32863556lfa.3
        for <linux-media@vger.kernel.org>; Wed, 16 Dec 2015 12:21:19 -0800 (PST)
Subject: Re: [v4l-utils PATCH 1/1] Allow building static binaries
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
References: <1449587901-12784-1-git-send-email-sakari.ailus@linux.intel.com>
 <20151210132124.GK17128@valkosipuli.retiisi.org.uk>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
From: Gregor Jasny <gjasny@googlemail.com>
Message-ID: <5671C7BC.9090002@googlemail.com>
Date: Wed, 16 Dec 2015 21:21:16 +0100
MIME-Version: 1.0
In-Reply-To: <20151210132124.GK17128@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 10/12/15 14:21, Sakari Ailus wrote:
> I discussed with Hans and he thought you'd be the best person to take a look
> at this.
> 
> The case is that I'd like to build static binaries and that doesn't seem to
> work with what's in Makefile.am for libv4l1 and libv4l2 at the moment.

Sorry for the late reply. Didi not notice this email earlier. Your patch
does not do what you'd like to achieve. Both v4l1compat and v4l2convert
are libraries which only purpose is to get preloaded by the loader. So
build them statically does not make sense. Instead they should not be
built at all. To achieve this the WITH_V4L_WRAPPERS variable should
evaluate to false. This is triggered by

AM_CONDITIONAL([WITH_V4L_WRAPPERS], [test x$enable_libv4l != xno -a
x$enable_shared != xno])

So changing

LDFLAGS="--static -static" ./configure --enable-static

to

LDFLAGS="--static -static" ./configure --enable-static --disabled-shared

should do the trick. Does this help?

Thanks,
Gregor


