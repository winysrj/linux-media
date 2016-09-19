Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55507 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932237AbcISSWd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 14:22:33 -0400
Date: Mon, 19 Sep 2016 21:20:33 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Marty Plummer <netz.kernel@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: TW2866 i2c driver and solo6x10
Message-ID: <20160919182033.qaom5ji4k43jsu24@acer>
References: <25e70ffb-147a-33f4-76cf-3435ab555520@gmail.com>
 <75985f71-e1d6-cf22-91c0-6429955156e6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75985f71-e1d6-cf22-91c0-6429955156e6@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm going to have quite constrained time for participation in this
driver development, but still I think this is perspective project which
is in line with trend of exposing internal details of complex media
hardware for configuration by V4L2 framework. Also tw286x are used in
both tw5864 and solo6x10 boards, and in both cases it could be
controlled better from userspace.
I think first thing to do is expose tw286x chips as i2c- (or more
precisely SMBus-) controllable devices. I have accomplished that in some
way for tw5864, and hopefully I'll manage that for solo6x10.
But beyond that, I currently don't know.
A senior mentor would be very appreciated :)
