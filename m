Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:32804 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759678Ab0JHVLM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Oct 2010 17:11:12 -0400
Date: Fri, 8 Oct 2010 15:11:10 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Drake <dsd@laptop.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] ov7670: remove QCIF mode
Message-ID: <20101008151110.127a62fe@bike.lwn.net>
In-Reply-To: <20101008210412.E85769D401B@zog.reactivated.net>
References: <20101008210412.E85769D401B@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri,  8 Oct 2010 22:04:12 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> This super-low-resolution mode only captures from a small portion of
> the sensor FOV, making it a bit useless.

I'm certainly not attached to this mode, but...does it harm anybody if
it's there?

ov7670 sensors appear in settings other than OLPC, so I'd be reluctant
to take this out unless there's some real reason to.

jon
