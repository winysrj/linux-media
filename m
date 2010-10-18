Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:37342 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab0JRNZx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 09:25:53 -0400
Date: Mon, 18 Oct 2010 07:25:51 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH] viafb camera controller driver
Message-ID: <20101018072551.75fcda5c@bike.lwn.net>
In-Reply-To: <4CB9AC58.5020301@infradead.org>
References: <20101010162313.5caa137f@bike.lwn.net>
	<4CB9AC58.5020301@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 16 Oct 2010 10:44:56 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> Hmm... do you need BKL? Otherwise, you should be using, instead, .unlocked_ioctl.

No, that was just silly.

> Btw, the driver build is broken:

And that, it seems, indicates that I'm making my patch against the
wrong tree.  I'll try to fix that up in the next day or so, sorry for
the trouble.

Thanks,

jon

