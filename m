Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:26250 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdF1Pov (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Jun 2017 11:44:51 -0400
Subject: Re: [PATCH v2 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2
 driver
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Tomasz Figa <tfiga@chromium.org>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <b110a35c-7c98-0536-7a99-dca6988c608b@samsung.com>
Date: Wed, 28 Jun 2017 17:44:32 +0200
MIME-version: 1.0
In-reply-to: <20170628133156.c333lrsauageq3yt@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <1496799279-8774-1-git-send-email-yong.zhi@intel.com>
        <1496799279-8774-4-git-send-email-yong.zhi@intel.com>
        <CAAFQd5Byemom138duZRpsKOzsb5204NfbFnjEdnDTu6wfLgnrQ@mail.gmail.com>
        <20170626145105.GN12407@valkosipuli.retiisi.org.uk>
        <CAAFQd5AGEYRZye3ShEGLrLTyG67jRzSU2-dN6=wmo5DuVxvGaw@mail.gmail.com>
        <20170628133156.c333lrsauageq3yt@valkosipuli.retiisi.org.uk>
        <CGME20170628154447epcas5p28ba0ff617f6e640185fada0e955e24b0@epcas5p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/28/2017 03:31 PM, Sakari Ailus wrote:
> IMO VB2/V4L2 could better support conversion between single and
> multi-planar buffer types so that the applications could just use any and
> drivers could manage with one.
> 
> I don't have a strong opinion either way, but IMO this could be well
> addressed later on by improving the framework when (or if) the support for
> formats such as NV12 is added.

We had already conversion between single and multi-planar buffer types
in the kernel.  But for some reasons it got removed. [1] The conversion
is supposed to be done in libv4l2, which is not mandatory so it cannot
be used to ensure backward compatibility while moving driver from one
API to the other.

[1]
commit 1d0c86cad38678fa42f6d048a7b9e4057c8c16fc
[media] media: v4l: remove single to multiplane conversion

Regards,
Sylwester
