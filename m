Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40042 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1JZAK6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Oct 2011 20:10:58 -0400
Received: by iaby12 with SMTP id y12so1121518iab.19
        for <linux-media@vger.kernel.org>; Tue, 25 Oct 2011 17:10:57 -0700 (PDT)
Message-ID: <4EA75010.3030806@gmail.com>
Date: Tue, 25 Oct 2011 19:10:56 -0500
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: Adding PCTV80e support to linuxtv.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

Since my repository isn't under the linuxtv.org banner, I'm not sure how
to create an actual patch or pull request for the code.  It needs some
cleanup work, but essentially the code works (for the ATSC portion, but
possibly not the QAM portion).

The repository is located at https://github.com/patrickdickey52761/PCTV80e

so I'd imagine that either git clone
git://github.com/patrickdickey52761/PCTV80e or git remote add
git://github.com/patrickdickey52761/PCTV80e will pull the code in for
you (it's a public repository).

If this doesn't work, I'm asking for assistance in getting the code into
a repository that can be pulled in (or assistance in how to prepare a
patch/pull request from my current repository).

If this does work, then I'm asking for assistance in cleanup of the
code--and specifics on what I need to do to clean up the code (breaking
lines up into fewer than 80 columns, whitespace, etc).  One thing to
note is that I haven't removed the trailing whitespace from the
drxj_map.h file, as it was an automatically generated file. I wasn't
sure what implications could arise from altering the file.

Thank you, and have a great day:)
Patrick.
