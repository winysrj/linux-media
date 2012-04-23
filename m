Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:33694 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab2DWUQ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 16:16:27 -0400
Date: Mon, 23 Apr 2012 14:16:25 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	linux-input@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Johann Deneux <johann.deneux@gmail.comx>,
	Anssi Hannula <anssi.hannula@gmail.com>
Subject: Re: [PATCH 0/3] gspca - ov534: saturation and hue (using
 fixp-arith.h)
Message-ID: <20120423141625.0138bbeb@lwn.net>
In-Reply-To: <1335187267-27940-1-git-send-email-ospite@studenti.unina.it>
References: <1335187267-27940-1-git-send-email-ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Apr 2012 15:21:04 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> Jonathan, maybe fixp_sin() and fixp_cos() can be used in
> drivers/media/video/ov7670.c too where currently ov7670_sine() and
> ov7670_cosine() are defined, but I didn't want to send a patch I could
> not test.

Seems like a good idea.  No reason to have multiple such hacks in the
kernel; I'll look at dumping the ov7670 version when I get a chance.  That
may not be all that soon, though; life is a bit challenging at the moment.

One concern is that if we're going to add users to fixp-arith.h, some of
it should maybe go to a C file.  Otherwise we'll create duplicated copies
of the cos_table array for each user.  I'm not sure the functions need to
be inline either; nobody expects cos() to be blindingly fast.

Thanks,

jon
