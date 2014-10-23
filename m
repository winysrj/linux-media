Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43615 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaJWKBn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 06:01:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [v4l-utils RFC 0/2] libmediatext library
Date: Thu, 23 Oct 2014 13:01:41 +0300
Message-ID: <4925721.xPZdUSiM3q@avalon>
In-Reply-To: <5448CCFC.5080606@linux.intel.com>
References: <1413888015-26649-1-git-send-email-sakari.ailus@linux.intel.com> <5448CB0B.7090606@redhat.com> <5448CCFC.5080606@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 23 October 2014 12:40:12 Sakari Ailus wrote:
> Hi Hans,
> 
> Hans de Goede wrote:
> > Maybe we should merge libmediactl into v4l-utils then ? Rather then
> > v4l-utils growing an external dependency on it. Sakari ?
> 
> libmediactl is already a part of v4l-utils, but it's under utils rather
> than lib directory. Cc Laurent.

I'm fine with moving the libraries to lib, but I'm still not 100% sure the ABI 
can be considered stable.

-- 
Regards,

Laurent Pinchart

