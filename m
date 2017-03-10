Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35630 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934659AbdCJKmZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 05:42:25 -0500
Date: Fri, 10 Mar 2017 12:41:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 05/15] ov7670: add devicetree support
Message-ID: <20170310104151.GX3220@valkosipuli.retiisi.org.uk>
References: <20170306145616.38485-1-hverkuil@xs4all.nl>
 <20170306145616.38485-6-hverkuil@xs4all.nl>
 <20170309204516.GR3220@valkosipuli.retiisi.org.uk>
 <90dee828-1f06-59f8-adb6-1b4442abaf2d@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90dee828-1f06-59f8-adb6-1b4442abaf2d@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 10, 2017 at 10:32:41AM +0100, Hans Verkuil wrote:
> On 09/03/17 21:45, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Mon, Mar 06, 2017 at 03:56:06PM +0100, Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Add DT support. Use it to get the reset and pwdn pins (if there are any).
> >> Tested with one sensor requiring reset/pwdn and one sensor that doesn't
> >> have reset/pwdn pins.
> > 
> > If I read the datasheet right, lifting the reset signal up will reset the
> > sensor but the patch doesn't make use of that, it only ensures the reset
> > signal stays low. Should you lift it up for a while as well? The datasheet
> > doesn't say for how long that should be done, but that it should be usable
> > after 1 ms since pulling reset down.
> 
> There does not seem to be any need for that. This sensor also comes in two
> models: one with separate pwdn and reset pins, and one where it is just hardwired.
> 
> If the hardwired variant doesn't need a reset pulse, then neither does the
> variant with pins. It works, and I am not really willing to experiment with this.

Fine with me.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
