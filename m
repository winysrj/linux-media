Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40220 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726052AbeIDUJ4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Sep 2018 16:09:56 -0400
Date: Tue, 4 Sep 2018 18:44:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 1/3] uapi/linux/media.h: add property support
Message-ID: <20180904154415.yv3zk6ucqxw2ydds@valkosipuli.retiisi.org.uk>
References: <20180807102847.13200-1-hverkuil@xs4all.nl>
 <20180807102847.13200-2-hverkuil@xs4all.nl>
 <20180904130107.habwc3cti53eodqb@valkosipuli.retiisi.org.uk>
 <5a2e9988-6e9e-cfcb-ab35-9d2c7e734683@cisco.com>
 <20180904154320.xlbsrfxp4ex5nj47@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180904154320.xlbsrfxp4ex5nj47@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 04, 2018 at 06:43:20PM +0300, Sakari Ailus wrote:
> media_v2_prop, called e.g. payload_length. I also think we should have the
> size (and length) of the property in a specific unit, such as bytes, so the
> parser does not have to know a given property type to determine it
> correctly.

Ah, please ignore this. I see you ended up to the same conclusion yourself
already.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
