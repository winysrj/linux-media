Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:41999 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998Ab0JHVNH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Oct 2010 17:13:07 -0400
Date: Fri, 8 Oct 2010 15:13:05 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Drake <dsd@laptop.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] ov7670: disable QVGA mode
Message-ID: <20101008151305.68f3897a@bike.lwn.net>
In-Reply-To: <20101008210418.2B1809D401C@zog.reactivated.net>
References: <20101008210418.2B1809D401C@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri,  8 Oct 2010 22:04:18 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> Capturing at this resolution results in an ugly green horizontal line
> at the left side of the image. Disable until fixed.

A problem like that will be at the controller level, not the sensor
level.  Given that this is an XO-1 report, I'd assume something
requires tweaking in the cafe_ccic driver.  I wasn't aware of this; I
know it worked once upon a time.

Again, given that ov7670 sensors can appear elsewhere, I'd be inclined
not to turn off this functionality because of this problem.

jon
