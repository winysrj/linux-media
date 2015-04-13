Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:59113 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932824AbbDMPnV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 11:43:21 -0400
Date: Mon, 13 Apr 2015 17:43:16 +0200
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv3 00/22] marvell-ccic: drop and fix formats
Message-ID: <20150413174316.3dcfcdfe@lwn.net>
In-Reply-To: <551FFB32.2020309@xs4all.nl>
References: <1426333621-21474-1-git-send-email-hverkuil@xs4all.nl>
	<551FFB32.2020309@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 04 Apr 2015 16:54:42 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Jon, ping!
> 
> Patch 18 is merged and I have your Ack for patch 19, but I'd like your Ack
> as well for patches 20-22, if possible.

Sorry, I'm traveling and dealing with a bunch of stuff...lots of balls
falling all over the floor.

You can add my ack to those patches, but let me just toss out my thoughts
for consideration.  At one point, the "RGB444" format was what the OLPC
XO was going to use for performance reasons.  As I recall, when you
looked recently, that was no longer the case.  So that makes it safe to
fix things without worrying that somebody might just be crazy enough to
put a 4.x kernel on an XO and have their video be messed up.

If, however, we're going to do that, we could also just fix RGB444 to
actually return RGB.  I'd have to go back and look (and I'm far from the
manual at the moment), but I believe it was a pretty simple tweak to flip
the nibbles around.

jon
