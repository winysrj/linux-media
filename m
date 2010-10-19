Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:37759 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab0JSNFV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 09:05:21 -0400
Date: Tue, 19 Oct 2010 07:05:19 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Drake <dsd@laptop.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] ov7670: fix QVGA visible area
Message-ID: <20101019070519.46eca972@bike.lwn.net>
In-Reply-To: <20101018210736.D41009D401B@zog.reactivated.net>
References: <20101018210736.D41009D401B@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 18 Oct 2010 22:07:36 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> The QVGA mode has a green horizontal line on the left hand side, and a red
> (or sometimes blue) vertical line at the bottom. Tweak the visible area
> to remove them.

Looks good to me - lots better than removing the mode!

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
