Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56460 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755407AbaGIQBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jul 2014 12:01:30 -0400
Date: Wed, 9 Jul 2014 19:01:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>
Subject: Re: [PATCH 2/2] libv4lcontrol: sync control strings/flags with the
 kernel
Message-ID: <20140709160125.GD16460@valkosipuli.retiisi.org.uk>
References: <53BBD0EF.1050104@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BBD0EF.1050104@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 08, 2014 at 01:07:27PM +0200, Hans Verkuil wrote:
> Hans,
> 
> I'd like your opinion on this. I really don't think the (sw) suffix serves
> any purpose and is just confusing to the end-user.
> 
> If you think that it is important that apps/users know that a control is emulated,
> then I would propose adding a V4L2_CTRL_FLAG_EMULATED and setting it in
> libv4lcontrol. Similar to the FMT_FLAG_EMULATED.

IMHO it'd be important to know whether something is emulated or not, as
emulation such as flipping carries often a significant CPU overhead. Format
conversions are "easy" in this respect since not performing the conversion
obviously avoids the overhead.

I'm not sure if the information that a control is emulated is useful as
such. For instance, how do you tell which choice of an emulated flipping
control would avoid the overhead, if the sensor is mounted upside down? In
this case the "default", "unflipped" configuration actually is implemented
in software. This looks like another field next to default, min, max and
step for QUERY_EXT_CTRL to me.

Just my 5 euro cents.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
