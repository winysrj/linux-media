Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:34520 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757789Ab2I2TUe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 15:20:34 -0400
Date: Sat, 29 Sep 2012 13:20:32 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, rusty@rustcorp.com.au, dsd@laptop.org,
	mchehab@infradead.org, hdegoede@redhat.com
Subject: Re: [PATCH v2 0/5] media: ov7670: driver cleanup and support for
 ov7674.
Message-ID: <20120929132032.7ce66793@hpe.lwn.net>
In-Reply-To: <1348760305-7481-1-git-send-email-javier.martin@vista-silicon.com>
References: <1348760305-7481-1-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 Sep 2012 17:38:20 +0200
Javier Martin <javier.martin@vista-silicon.com> wrote:

> The following series includes all the changes discussed in [1] that
> don't affect either bridge drivers that use ov7670 or soc-camera framework
> For this reason they are considered non controversial and sent separately.
> At least 1 more series will follow in order to implement all features
> described in [1].

I'd have preferred to avoid the unrelated white space changes in #1,
but so be it; you can put my Acked-by on the whole set.

Thanks,

jon
