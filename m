Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:58090 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250Ab2D3X1F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 19:27:05 -0400
Date: Mon, 30 Apr 2012 17:27:03 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Drake <dsd@laptop.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] via-camera: specify XO-1.5 camera clock speed
Message-ID: <20120430172703.3052d3a0@lwn.net>
In-Reply-To: <20120430220627.B4C339D401E@zog.reactivated.net>
References: <20120430220627.B4C339D401E@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 30 Apr 2012 23:06:27 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> For the ov7670 camera to return images at the requested frame rate,
> it needs to make calculations based on the clock speed, which is
> a completely external factor (depends on the wiring of the system).
> 
> On the XO-1.5, which is the only known via-camera user, the camera
> is clocked at 90MHz.
> 
> Pass this information to the ov7670 driver, to fix an issue where
> a framerate of 3x the requested amount was being provided.

This is big-time weird...this problem has been solved before.  The reason
ov7670 *has* a clock speed parameter is because the XO 1.5 - the second
user - clocked it so fast.  I'm going to have to go digging through some
history to try to figure out where this fix went...

Meanwhile, this looks fine.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
