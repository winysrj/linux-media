Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:37000 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbbJOHbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2015 03:31:25 -0400
Date: Thu, 15 Oct 2015 08:31:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv9 06/15] rc: Add HDMI CEC protocol handling
Message-ID: <20151015073107.GT32532@n2100.arm.linux.org.uk>
References: <cover.1441633456.git.hansverk@cisco.com>
 <345aeebe5561f8f6540f477ae160c5cbf1b0f6d5.1441633456.git.hansverk@cisco.com>
 <20151006180540.GR21513@n2100.arm.linux.org.uk>
 <561B9E97.4050909@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <561B9E97.4050909@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 12, 2015 at 01:50:47PM +0200, Hans Verkuil wrote:
> > Yet the rc-cec is a module in the filesystem, but it doesn't seem to
> > be loaded automatically - even after the system has booted, the module
> > hasn't been loaded.
> > 
> > It looks like it _should_ be loaded, but this plainly isn't working:
> > 
> >         map = seek_rc_map(name);
> > #ifdef MODULE

This is the problem.  MODULE is only set when _this_ file is built as a
module.  If this is built in, but your rc maps are modules, then they
won't get loaded because this symbol will not be defined.

It needs to be CONFIG_MODULES - and when it is, the rc-cec module is
automatically loaded.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
