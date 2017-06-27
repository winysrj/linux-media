Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:34104 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752335AbdF0KJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 06:09:31 -0400
Date: Tue, 27 Jun 2017 03:09:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jyri Sarha <jsarha@ti.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/8] arm: omap4: enable CEC pin for Pandaboard A4 and ES
Message-ID: <20170627100926.GB3730@atomide.com>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-2-hverkuil@xs4all.nl>
 <4355dab4-9c70-77f7-f89b-9a1cf24976cf@ti.com>
 <20170626110711.GW3730@atomide.com>
 <701dbbfa-000a-2b93-405b-246aa90b6dd6@xs4all.nl>
 <20170627091421.GZ3730@atomide.com>
 <1d970218-d24a-d460-7d95-b31102d735f2@xs4all.nl>
 <a6f7c3d6-f4a6-1dba-2da0-b36ea2dd8803@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6f7c3d6-f4a6-1dba-2da0-b36ea2dd8803@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Jyri Sarha <jsarha@ti.com> [170627 02:47]:
> There is no real volume on HDMI audio output as it is a digital
> interface, but it should be possible to provide some volume control
> using TV's volume trough CEC.

OK great!

Tony
