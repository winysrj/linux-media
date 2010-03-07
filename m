Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2352 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab0CGPtw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 10:49:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Daily build: added git support
Date: Sun, 7 Mar 2010 16:50:02 +0100
Cc: =?iso-8859-1?q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003071650.02137.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

It took longer than I intended, but I finally added git support to the daily
build process. Note that I am only building the drivers/media subdirectory and
not a full kernel build as that takes too long.

Also note that I am building against the media-master branch. I think that is
sufficient, but if not, then let me know.

I also made some other changes:

The sparse build is now only done for the git tree and no longer for the last
stable build.

The powerpc git build will be done with CONFIG_PM set to n. This way we also
have a build that tests against that particular configuration.

The spec is now also made for the git tree. However, the documentation that
I upload to my xs4all website is from the hg build only. If there is enough
interest, then I might upload the git version as well. Unfortunately, there
does not seem to be a way to get a single html version when building from git,
and I dislike the version with a zillion html files.

It seems to work well based on my local tests, but I will have to wait and
see what the daily build delivers. I may still have to tweak something based
on the results.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
