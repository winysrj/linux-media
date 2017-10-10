Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60059 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751402AbdJJXmy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 19:42:54 -0400
Date: Wed, 11 Oct 2017 10:42:50 +1100
From: "Tobin C. Harding" <me@tobin.cc>
To: Branislav Radocaj <branislav@radocaj.org>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        hans.verkuil@cisco.com, devel@driverdev.osuosl.org,
        nikola.jelic83@gmail.com, ran.algawi@gmail.com,
        linux-kernel@vger.kernel.org, jb@abbadie.fr, shilpapri@gmail.com,
        aquannie@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] Staging: bcm2048 fix bare use of 'unsigned' in
 radio-bcm2048.c
Message-ID: <20171010234250.GC2049@eros>
References: <20171010132919.18428-1-branislav@radocaj.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171010132919.18428-1-branislav@radocaj.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Branislav,

On Tue, Oct 10, 2017 at 03:29:19PM +0200, Branislav Radocaj wrote:
> This is a patch to the radio-bcm2048.c file that fixes up
> a warning found by the checkpatch.pl tool.
> 
> Signed-off-by: Branislav Radocaj <branislav@radocaj.org>

Nice work, a few git log nit picks for you to ensure your future kernel development success.

You can read all this in Documentaton/process/submitting-patches.rst (section 2).

- You can use imperative mood, i.e 'Fix foo by doing bar' instead of 'This patch ...'
- We don't need to mention the file (either in the summary or in the body), people can see this from
  the diff.

This is one way of writing the git log message for checkpatch fixes

	checkpatch emits WARNING: EXPORT_SYMBOL(foo); should immediately follow
	its function/variable.

	Move EXPORT_SYMBOL macro call to immediately follow function definition.


Good work, hope this helps.

Tobin
