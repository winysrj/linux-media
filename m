Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:48096 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186AbaFCN7d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Jun 2014 09:59:33 -0400
Date: Tue, 3 Jun 2014 15:59:30 +0200
From: Antonio Ospite <ao2@ao2.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ao2@ao2.it>, Gregor Jasny <gjasny@googlemail.com>
Subject: Re: [PATCH] libv4lconvert: Fix a regression when converting from
 Y10B
Message-Id: <20140603155930.f72e14f4aab39ec49bdb1b71@ao2.it>
In-Reply-To: <1401803326-31942-1-git-send-email-ao2@ao2.it>
References: <1401803326-31942-1-git-send-email-ao2@ao2.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue,  3 Jun 2014 15:48:46 +0200
Antonio Ospite <ao2@ao2.it> wrote:

> Fix a regression introduced in commit
> efc29f1764a30808ebf7b3e1d9bfa27b909bf641 (libv4lconvert: Reject too
> short source buffer before accessing it).
> 
> The old code:
> 
> case V4L2_PIX_FMT_Y10BPACK:
> 	...
> 	if (result == 0 && src_size < (width * height * 10 / 8)) {
> 		V4LCONVERT_ERR("short y10b data frame\n");
> 		errno = EPIPE;
> 		result = -1;
> 	}
> 	...
> 
> meant to say "If the conversion was *successful* _but_ the frame size
> was invalid, then take the error path", but in
> efc29f1764a30808ebf7b3e1d9bfa27b909bf641 this (maybe weird) logic was
> misunderstood and the v4lconvert_convert_pixfmt() was made to return an
                    ^^^
Dear committer, you can remove this "the", if you feel like it :)

Thanks,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
