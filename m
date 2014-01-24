Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53261 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752728AbaAXPog (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 10:44:36 -0500
Date: Fri, 24 Jan 2014 17:44:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, t.stanislaws@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 06/21] v4l2-ctrls: add support for complex types.
Message-ID: <20140124154431.GD13820@valkosipuli.retiisi.org.uk>
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
 <1390221974-28194-7-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390221974-28194-7-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Jan 20, 2014 at 01:45:59PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch implements initial support for complex types.
> 
> For the most part the changes are fairly obvious (basic support for is_ptr
> types, the type_is_int function is replaced by a is_int bitfield, and
> v4l2_query_ext_ctrl is added), but one change needs more explanation:
> 
> The v4l2_ctrl struct adds a 'new' field and a 'stores' array at the end
> of the struct. This is in preparation for future patches where each control
> can have multiple configuration stores. The idea is that stores[0] is the current
> control value, stores[1] etc. are the control values for each configuration store
> and the 'new' value can be accessed through 'stores[-1]', i.e. the 'new' field.
> However, for now only stores[-1] and stores[0] is used.

Could we use zero or positive indices only, e.g. the new being zero and
current 1, or the other way? Or make the "new" value special, i.e. using a
different field name.

I think accessing the previous struct member by index -1 looks a little bit
hackish.

> These new fields use the v4l2_ctrl_ptr union, which is a pointer to a control
> value.
> 
> Note that these two new fields are not yet actually used.

Should they be then added yet in the first place? :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
