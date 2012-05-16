Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:51287 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973Ab2EPVMy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 17:12:54 -0400
Date: Wed, 16 May 2012 15:12:53 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Drake <dsd@laptop.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] mmp-camera: specify XO-1.75 clock speed
Message-ID: <20120516151253.24d12245@lwn.net>
In-Reply-To: <20120515194331.77C519D401E@zog.reactivated.net>
References: <20120515194331.77C519D401E@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 15 May 2012 20:43:31 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> Jon, is it OK to assume that XO-1.75 is the only mmp-camera user?

It's the only one I know of at the moment, certainly.

Even so, I think it would be a lot better to put this parameter into the
mmp_camera_platform_data structure instead of wiring it into the driver
source; it could then be set in olpc-xo-1-75.c with the other relevant
parameters.  I won't oppose the inclusion of this patch, but...any chance
it could be done that way?

Thanks,

jon
