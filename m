Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45812 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751609AbdF1P4q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Jun 2017 11:56:46 -0400
Date: Wed, 28 Jun 2017 18:56:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tfiga@chromium.org>, Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Subject: Re: [PATCH v2 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20170628155607.lljvnhzyquzqxloy@valkosipuli.retiisi.org.uk>
References: <1496799279-8774-1-git-send-email-yong.zhi@intel.com>
 <1496799279-8774-4-git-send-email-yong.zhi@intel.com>
 <CAAFQd5Byemom138duZRpsKOzsb5204NfbFnjEdnDTu6wfLgnrQ@mail.gmail.com>
 <20170626145105.GN12407@valkosipuli.retiisi.org.uk>
 <CAAFQd5AGEYRZye3ShEGLrLTyG67jRzSU2-dN6=wmo5DuVxvGaw@mail.gmail.com>
 <20170628133156.c333lrsauageq3yt@valkosipuli.retiisi.org.uk>
 <CGME20170628154447epcas5p28ba0ff617f6e640185fada0e955e24b0@epcas5p2.samsung.com>
 <b110a35c-7c98-0536-7a99-dca6988c608b@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b110a35c-7c98-0536-7a99-dca6988c608b@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wed, Jun 28, 2017 at 05:44:32PM +0200, Sylwester Nawrocki wrote:
> Hi,
> 
> On 06/28/2017 03:31 PM, Sakari Ailus wrote:
> > IMO VB2/V4L2 could better support conversion between single and
> > multi-planar buffer types so that the applications could just use any and
> > drivers could manage with one.
> > 
> > I don't have a strong opinion either way, but IMO this could be well
> > addressed later on by improving the framework when (or if) the support for
> > formats such as NV12 is added.
> 
> We had already conversion between single and multi-planar buffer types
> in the kernel.  But for some reasons it got removed. [1] The conversion
> is supposed to be done in libv4l2, which is not mandatory so it cannot
> be used to ensure backward compatibility while moving driver from one
> API to the other.
> 
> [1]
> commit 1d0c86cad38678fa42f6d048a7b9e4057c8c16fc
> [media] media: v4l: remove single to multiplane conversion

Thanks for the pointer. I had missed this back then.

Not all applications will be using libv4l2. This is something that would
make sense to do in the kernel IMO. The changes seem pretty minimal to me,
based on the patch.

There is now at least one difference between single-planar and multi-planar
cases; the data_offset field is only present in struct v4l2_plane. That
should be easy to address by adding the field to the single-planar case,
too. (We'll need new buffer structs in the near future anyway, there's no
really a way around that.)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
