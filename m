Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49721 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755620Ab3GBXCd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jul 2013 19:02:33 -0400
Date: Wed, 3 Jul 2013 02:01:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Support for events with a large payload
Message-ID: <20130702230159.GO2064@valkosipuli.retiisi.org.uk>
References: <201305131414.43685.hverkuil@xs4all.nl>
 <1721198.ELRHSeN8Of@avalon>
 <20130622205800.GH2064@valkosipuli.retiisi.org.uk>
 <201306241540.14469.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306241540.14469.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 24, 2013 at 03:40:14PM +0200, Hans Verkuil wrote:
...
> Since the payloads are larger I am less concerned about speed. There is one
> problem, though: if you dequeue the event and the buffer that should receive
> the payload is too small, then you have lost that payload. You can't allocate
> a new, larger, buffer and retry. So this approach can only work if you really
> know the maximum payload size.
> 
> The advantage is also that you won't lose payloads.

Forgot to answer this one --- I think it's fair to assume the user knows the
maximum size of the payload. What we also could do in such a case is to
return the error (e.g. ENOSPC) and put the required size to the large event
size field. But first someone must come up with a variable size event
without well defined maximum size for this to make much sense.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
