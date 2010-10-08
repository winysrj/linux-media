Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:42004 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932797Ab0JHVOX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Oct 2010 17:14:23 -0400
Date: Fri, 8 Oct 2010 15:14:21 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Drake <dsd@laptop.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] ov7670: Support customization of clock speed
Message-ID: <20101008151421.6d2b9280@bike.lwn.net>
In-Reply-To: <20101008210433.126649D401B@zog.reactivated.net>
References: <20101008210433.126649D401B@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri,  8 Oct 2010 22:04:32 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> Add a module parameter so that the user can specify this information.
> And add DMI detection for appropriate clock speeds on the OLPC XO-1 and
> XO-1.5 laptops. If specified, the module parameter wins over whatever we
> might have set through the DMI table.

This certainly seems better than my hack.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
