Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59754 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753847AbdIDQ32 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 12:29:28 -0400
Date: Mon, 4 Sep 2017 19:29:26 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v7 14/18] dt: bindings: Add lens-focus binding for image
 sensors
Message-ID: <20170904162925.hxtzy5jagv5ylq4c@valkosipuli.retiisi.org.uk>
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
 <20170903174958.27058-15-sakari.ailus@linux.intel.com>
 <96371574-0205-fd0e-452e-d001695bd69e@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96371574-0205-fd0e-452e-d001695bd69e@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Sep 04, 2017 at 04:37:29PM +0200, Hans Verkuil wrote:
> On 09/03/2017 07:49 PM, Sakari Ailus wrote:
> > The lens-focus property contains a phandle to the lens voice coil driver
> > that is associated to the sensor; typically both are contained in the same
> > camera module.
> 
> Just to be certain: this lens-focus phandle should also work fine for a motor
> driver, right?

Yes; the commit message specifies what this is used right now but nothing
prevents using this for different lens control technologies either. The
property itself does not mention voice coil modules.

> 
> We (Cisco) also have a camera that has an iris motor, but since nothing upstream
> uses that I'm not sure if we should bother adding that as well.

Do you have one for focussing only or for zooming as well?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
