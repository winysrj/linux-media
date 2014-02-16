Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49065 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752822AbaBPUOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Feb 2014 15:14:52 -0500
Date: Sun, 16 Feb 2014 22:14:15 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	ismael.luceno@corp.bluecherry.net, pete@sensoray.com
Subject: Re: [REVIEWv2 PATCH 00/34] Add support for complex controls, use in
 solo/go7007
Message-ID: <20140216201414.GS15635@valkosipuli.retiisi.org.uk>
References: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Feb 10, 2014 at 09:46:25AM +0100, Hans Verkuil wrote:
> This patch series adds support for complex controls (aka 'Properties') to

While the patchset extends the concept of extended controls by adding more
data types, they should not be called "properties" since they are not. The
defining aspect of "properties" is to be able to specify to which entity,
sub-device, pad, video buffer queue, flash led etc. object the said property
is related to. This is mostly orthogonal to what kind of data types the
property could have.

There's just a single 32-bit reserved field in struct v4l2_ext_control so
extending the current extended controls (S/G/TRY) interface is not an option
to support properties. A new ABI (but not necessarily even if probably an
API as well) would be needed in any case.

So for the time being I'd wish we continue to use the name "controls" even
if the control type is not one of the traditional ones.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
