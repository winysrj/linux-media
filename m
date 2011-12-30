Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:51965 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab1L3VdG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 16:33:06 -0500
Date: Fri, 30 Dec 2011 23:33:01 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: v4l: how to get blanking clock count?
Message-ID: <20111230213301.GA3677@valkosipuli.localdomain>
References: <CAHG8p1Ao8UDuCytunFjvGZ1Ugd_xVU9cf_iXv6YjcRD41aMYtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHG8p1Ao8UDuCytunFjvGZ1Ugd_xVU9cf_iXv6YjcRD41aMYtw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Scott,

On Fri, Dec 30, 2011 at 03:20:43PM +0800, Scott Jiang wrote:
> Hi Hans and Guennadi,
> 
> Our bridge driver needs to know line clock count including active
> lines and blanking area.
> I can compute active clock count according to pixel format, but how
> can I get this in blanking area in current framework?

Such information is not available currently over the V4L2 subdev interface.
Please see this patchset:

<URL:http://www.spinics.net/lists/linux-media/msg41765.html>

Patches 7 and 8 are probably the most interesting for you. This is an RFC
patchset so the final implementation could well still change.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
