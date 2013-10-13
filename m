Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58281 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754238Ab3JMLDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Oct 2013 07:03:46 -0400
Date: Sun, 13 Oct 2013 14:03:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sylwester.nawrocki@gmail.com,
	a.hajda@samsung.com
Subject: Re: [PATCH v2.1 1/4] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
Message-ID: <20131013110313.GC7584@valkosipuli.retiisi.org.uk>
References: <524DEC22.5090107@gmail.com>
 <1381661924-26365-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381661924-26365-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 13, 2013 at 01:58:43PM +0300, Sakari Ailus wrote:
> Pads that set this flag must be connected by an active link for the entity
> to stream.

Oh --- btw. what has changed since v2:

- Rmoved the last sentence of MEDIA_PAD_FL_MUST_CONNECT documentation. The
  sentence was about the flag having no effect on pads w/o links.

- Change Sylwester's e-mail address

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
