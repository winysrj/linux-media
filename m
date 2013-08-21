Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53750 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab3HUN1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 09:27:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: width and height of JPEG compressed images
Date: Wed, 21 Aug 2013 15:28:51 +0200
Message-ID: <2547877.KEf7cs3vQZ@avalon>
In-Reply-To: <20130821131736.GE20717@valkosipuli.retiisi.org.uk>
References: <51D876DF.90507@gmail.com> <A683633ABCE53E43AFB0344442BF0F054C632C1D@server10.irisys.local> <20130821131736.GE20717@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wednesday 21 August 2013 16:17:37 Sakari Ailus wrote:
> On Wed, Aug 07, 2013 at 05:43:56PM +0000, Thomas Vajzovic wrote:
> > It defines the exact size of the physical frame.  The JPEG data is padded
> > to this size. The size of the JPEG before it was padded is also written
> > into the last word of the physical frame.

That would require either using a custom pixel format and have userspace 
reading the size from the buffer, or mapping the buffer in kernel space and 
reading the size there. The latter is easier for userspace, but might it 
hinder performances ?

> In that case, I think the issue is much lesser than we thought originally:
> the image may still well be smaller than the buffer even if the buffer is
> e.g. page aligned.

-- 
Regards,

Laurent Pinchart

