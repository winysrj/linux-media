Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:57865 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750745AbdA2Wf2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Jan 2017 17:35:28 -0500
Date: Sun, 29 Jan 2017 22:35:10 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/9] Teach lirc how to send and receive scancodes
Message-ID: <20170129223509.GA3940@gofer.mess.org>
References: <cover.1483706563.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1483706563.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 06, 2017 at 12:49:03PM +0000, Sean Young wrote:
> This patch series introduces a new lirc mode, LIRC_MODE_SCANCODE. This
> allows scancodes to be sent and received. This depends on earlier
> series which introduces IR encoders.

I've been testing these patches further and I've discovered some bugs,
the biggest issue is some nasty use-after-frees with unplug. It would
be much better if lirc used proper kobject reference counting, so I will
first focus on that and then revisit these patches.


Thanks

Sean
