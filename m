Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:60630 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbZC0PBR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 11:01:17 -0400
Date: Fri, 27 Mar 2009 16:00:58 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [ADMIN] linuxtv.org is moving
Message-ID: <20090327150058.GA28572@linuxtv.org>
References: <20090325162541.GB22582@linuxtv.org> <20090326185729.GA10352@linuxtv.org> <49CC1BEA.20305@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CC1BEA.20305@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 27, 2009 at 02:20:58AM +0200, Antti Palosaari wrote:
>
> [crope@localhost v4l-dvb]$ hg push  
> ssh://anttip@linuxtv.org/hg/~anttip/af9015
> pushing to ssh://anttip@linuxtv.org/hg/~anttip/af9015
> searching for changes
> remote: abort: No space left on device
> [crope@localhost v4l-dvb]$ host linuxtv.org
> linuxtv.org has address 217.160.6.122
>
> I removed 5-6 my old devel trees, still no space :o

This issue should be resolved now, /tmp had insufficient space.

BTW: it is faster and uses less disk space to use hg-menu to
clone the v4l-dvb tree on the server (hg then uses hardlinks),
and push your changes on top of it.

  ssh -t anttip@linuxtv.org hg-menu

Johannes
