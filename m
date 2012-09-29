Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:34541 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757644Ab2I2TZ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 15:25:58 -0400
Date: Sat, 29 Sep 2012 13:25:56 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, rusty@rustcorp.com.au, dsd@laptop.org,
	mchehab@infradead.org, hdegoede@redhat.com
Subject: Re: [PATCH v3 0/4] ov7670: migrate this sensor and its users to
 ctrl framework.
Message-ID: <20120929132556.22c48312@hpe.lwn.net>
In-Reply-To: <1348831603-18007-1-git-send-email-javier.martin@vista-silicon.com>
References: <1348831603-18007-1-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 28 Sep 2012 13:26:39 +0200
Javier Martin <javier.martin@vista-silicon.com> wrote:

> The following series migrate ov7670 sensor and current users to ctrl framework
> as  discussed in [1]. This has been tested against mx2_camera soc-camera bridge,
> so tests or acks will be required from people using cam-core and via-camera out
> there.

Looking over the code, I can't really find much to get grumpy about.
Certainly I like how it removes more code than it adds.  I'm not really
up on the control framework, though.  What's really needed is to see
this code actually work on the relevant systems.  I will *try* to do
that testing, but it's going to take a little while; I don't think I
can do it by the 3.7 merge window.  Mauro willing, perhaps it can go in
this time around anyway with the idea that we can sort out any little
difficulties after -rc1.

jon
