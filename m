Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36339
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754667AbdFXUEp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 16:04:45 -0400
Date: Sat, 24 Jun 2017 17:04:37 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, tfiga@chromium.org, yong.zhi@intel.com
Subject: Re: [RFC 1/2] v4l: Add support for V4L2_BUF_TYPE_META_OUTPUT
Message-ID: <20170624170437.53b9c642@vento.lan>
In-Reply-To: <8e4c6805-324b-da67-8658-c9251d50b67b@xs4all.nl>
References: <1497626061-2129-1-git-send-email-sakari.ailus@linux.intel.com>
        <1497626061-2129-2-git-send-email-sakari.ailus@linux.intel.com>
        <8e4c6805-324b-da67-8658-c9251d50b67b@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 16 Jun 2017 17:48:44 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 06/16/2017 05:14 PM, Sakari Ailus wrote:
> > The V4L2_BUF_TYPE_META_OUTPUT mirrors the V4L2_BUF_TYPE_META_CAPTURE with
> > the exception that it is an OUTPUT type. The use case for this is to pass
> > buffers to the device that are not image data but metadata. The formats,
> > just as the metadata capture formats, are typically device specific and
> > highly structured.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>  
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Looks OK to me too.

Thanks,
Mauro
