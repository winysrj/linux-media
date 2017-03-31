Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50897
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753338AbdCaKFQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 06:05:16 -0400
Date: Fri, 31 Mar 2017 07:05:08 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Helen Koike <helen.koike@collabora.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH] vidioc-enumin/output.rst: improve documentation
Message-ID: <20170331070508.7a8eae16@vento.lan>
In-Reply-To: <dfd64830-b66d-044d-2a40-82210a32c18a@xs4all.nl>
References: <dfd64830-b66d-044d-2a40-82210a32c18a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 31 Mar 2017 10:58:39 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> The V4L2_INPUT_TYPE_CAMERA and V4L2_OUTPUT_TYPE_ANALOG descriptions were
> hopelessly out of date. Fix this, and also fix a few style issues in these
> documents. Finally add the missing documentation for V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY
> (only used by the zoran driver).
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

Patch looks OK to me, but see below.

> Question: should we perhaps add _TYPE_VIDEO aliases?

IMHO, let's rename it to _TYPE_VIDEO (or STREAM, or V_STREAM), and make 
_TYPE_CAMERA an alias, e. g.:

#define V4L2_INPUT_TYPE_VIDEO 2

#define V4L2_INPUT_TYPE_CAMERA V4L2_INPUT_TYPE_VIDEO

This way, we'll let clearer what's currently preferred. We should also
change it at the documentation, mentioning that V4L2_INPUT_TYPE_CAMERA
is an alias, due to historical reasons.

Thanks,
Mauro
