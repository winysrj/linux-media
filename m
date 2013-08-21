Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54788 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751499Ab3HUNSM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 09:18:12 -0400
Date: Wed, 21 Aug 2013 16:17:37 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: width and height of JPEG compressed images
Message-ID: <20130821131736.GE20717@valkosipuli.retiisi.org.uk>
References: <51D876DF.90507@gmail.com>
 <20130719202842.GC11823@valkosipuli.retiisi.org.uk>
 <51EC46BA.4050203@gmail.com>
 <20130723222106.GB12281@valkosipuli.retiisi.org.uk>
 <A683633ABCE53E43AFB0344442BF0F053616A13A@server10.irisys.local>
 <51EF92AF.7040205@samsung.com>
 <20130726090646.GJ12281@valkosipuli.retiisi.org.uk>
 <A683633ABCE53E43AFB0344442BF0F054C632A50@server10.irisys.local>
 <20130807093554.GE16719@valkosipuli.retiisi.org.uk>
 <A683633ABCE53E43AFB0344442BF0F054C632C1D@server10.irisys.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A683633ABCE53E43AFB0344442BF0F054C632C1D@server10.irisys.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On Wed, Aug 07, 2013 at 05:43:56PM +0000, Thomas Vajzovic wrote:
> It defines the exact size of the physical frame.  The JPEG data is padded
> to this size. The size of the JPEG before it was padded is also written
> into the last word of the physical frame.

In that case, I think the issue is much lesser than we thought originally:
the image may still well be smaller than the buffer even if the buffer is
e.g. page aligned.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
