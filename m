Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52856 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750737AbdE0TxQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 May 2017 15:53:16 -0400
Date: Sat, 27 May 2017 22:53:12 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Subject: Re: [PATCH 1/1] [media] i2c: add support for OV13858 sensor
Message-ID: <20170527195312.GX29527@valkosipuli.retiisi.org.uk>
References: <1495583908-2479-1-git-send-email-hyungwoo.yang@intel.com>
 <20170524125111.GJ29527@valkosipuli.retiisi.org.uk>
 <7A4F467111FEF64486F40DFE7DF3500A03E99242@ORSMSX111.amr.corp.intel.com>
 <20170526215003.GS29527@valkosipuli.retiisi.org.uk>
 <7A4F467111FEF64486F40DFE7DF3500A03E998E5@ORSMSX111.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A4F467111FEF64486F40DFE7DF3500A03E998E5@ORSMSX111.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 26, 2017 at 10:53:30PM +0000, Yang, Hyungwoo wrote:
> Hi Sakari,
> 
> I've submitted V2 yesterday. If possible, can you review that one also ?
> I'm learning many things from your review comments.
> 
> I think in V2, I've addressed most of comments except raw bayer format.
> 
> For ray bayer format, for now, I intentionally don't support crop since it
> requires more complexity to meet request from _set_pad_format() while
> keeping FOV for the resolutions with the same ratio(4:3 or 16:9). Yes, it
> is hacky but I thought it's OK unless there's a need to support crop.
> Hm..... I'm thinking drop "bayer order change" since it is not that
> meaningful. Should I ?

If you don't need to support other bayer orders, that'd be an easy solution.
The support can always be added later on.

> 
> For VBLANK, I realized I made wrong comments just after I send it. Yeas,
> it shouldn't be read-only. So you can see that VBLANK I added in V2 is NOT
> read-only.

Ack, I'll check that, most likely on Monday.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
