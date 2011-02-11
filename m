Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:39224 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757368Ab1BKVyS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Feb 2011 16:54:18 -0500
Date: Fri, 11 Feb 2011 14:54:16 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Drake <dsd@laptop.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	dilinger@queued.net
Subject: Re: [PATCH] via-camera: Add suspend/resume support
Message-ID: <20110211145416.6e0b63cf@bike.lwn.net>
In-Reply-To: <20110211211502.D6D8E9D401D@zog.reactivated.net>
References: <20110211211502.D6D8E9D401D@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 11 Feb 2011 21:15:02 +0000 (GMT)
Daniel Drake <dsd@laptop.org> wrote:

> Add suspend/resume support to the via-camera driver, so that the video
> continues streaming over a suspend-resume cycle.

Seems good.  Sorry I've been so scattered and you've had to marshal this
stuff.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
