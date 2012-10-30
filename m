Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:46395 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab2J3Ta2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 15:30:28 -0400
Date: Tue, 30 Oct 2012 13:31:55 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, mchehab@redhat.com
Subject: Re: [PATCH] media: ov7670: Allow 32x maximum gain for yuv422.
Message-ID: <20121030133155.78069467@lwn.net>
In-Reply-To: <1351613063-19076-1-git-send-email-javier.martin@vista-silicon.com>
References: <1351613063-19076-1-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 30 Oct 2012 17:04:23 +0100
Javier Martin <javier.martin@vista-silicon.com> wrote:

> 4x gain ceiling is not enough to capture a decent image in conditions
> of total darkness and only a LED light source. Allow a maximum gain
> of 32x instead.

The initial number surely came from OmniVision and was never really
thought about.  I can't test this at the moment, but I see no reason not
to take your word that it doesn't affect normal-light operation.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
