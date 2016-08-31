Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46198 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934022AbcHaM6w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 08:58:52 -0400
Date: Wed, 31 Aug 2016 15:57:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hansverk@cisco.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: RFC: V4L2_PIX_FMT_NV16: should it allow padding after each plane?
Message-ID: <20160831125742.GR12130@valkosipuli.retiisi.org.uk>
References: <57C69897.8010200@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C69897.8010200@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Aug 31, 2016 at 10:43:03AM +0200, Hans Verkuil wrote:
> The NV16 documentation allows for padding after each line:
> 
> https://hverkuil.home.xs4all.nl/spec/uapi/v4l/pixfmt-nv16.html
> 
> But I have one case where there is also padding after each plane.
> 
> Can we fold that into the existing NV16 format? I.e., in that case
> the size of each plane is sizeimage / 2.

I can't see any harm in doing so. It likely catches most of the alignment
requirements.

That still probably doesn't catch all the possible cases but we always do
have the option of creating another format in that case.

> 
> Or do I have to make a new NV16PAD format that allows such padding?
> 
> I am in favor of extending the NV16 specification since I believe it
> makes sense, but I want to know what others think.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
