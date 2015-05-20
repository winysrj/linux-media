Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60633 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbbETU4A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 16:56:00 -0400
Date: Wed, 20 May 2015 21:55:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Enrico Weigelt, metux IT consult" <weigelt@melag.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: imx53 IPU support on 4.0.4
Message-ID: <20150520205554.GY2067@n2100.arm.linux.org.uk>
References: <555C86A5.2030007@melag.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555C86A5.2030007@melag.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 20, 2015 at 03:05:41PM +0200, Enrico Weigelt, metux IT consult wrote:
> I've rebased the IPUv3 patches from ptx folks onto 4.0.4,
> working good for me. (now gst plays h264 @25fps on imx53)
> 
> https://github.com/metux/linux/commits/submit-4.0-imx53-ipuv3
> 
> (Haven't 4.1rc* yet, as it broke some other things for me.)

While it's useful to broadcast your work, please have some consideration
for the forum(s) you're doing that to.

The way kernel development works is that patches are sent to mailing
lists for review.  Kernel developers review the patches and provide
comments back.  The comments are discussed and actioned, and a new
set of patches posted for further review.  This cycle repeats.

When everyone is happy, the patches can be applied, or pulled from
a non-github git tree.  (Kernel people generally don't like github.)

This is so that upstream kernel developers don't get too overloaded
with work that really should be done by downstream folk (imagine if
they had to rewrite every patch that came their way...)

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
