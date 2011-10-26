Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57926 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab1JZNdW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Oct 2011 09:33:22 -0400
MIME-Version: 1.0
In-Reply-To: <1319635477-9383-1-git-send-email-vapier@gentoo.org>
References: <1319635477-9383-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 26 Oct 2011 09:33:01 -0400
Message-ID: <CAMjpGUfEtLSiJoYG+42aFLnx83Zmzd88MAU1DVYXcBxTpo3wSw@mail.gmail.com>
Subject: Re: [PATCH] [media] v4l2: punt generated pdf files
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 26, 2011 at 09:24, Mike Frysinger wrote:
> These don't belong in the tree, and we have a .gitignore on them already
> (not sure how these slipped in), so punt the compiled files.

hrm, i thought default git send-email/format-patch didn't include
binary updates when deleting in the diff.  not sure what's going on
here.  i can resend if people want with the -D flag.
-mike
