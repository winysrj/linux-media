Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37880 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751644AbdLMJgs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 04:36:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] uvcvideo: Refactor code to ease metadata implementation
Date: Wed, 13 Dec 2017 11:36:52 +0200
Message-ID: <19177434.yaqnhLVI9Y@avalon>
In-Reply-To: <alpine.DEB.2.20.1712120832090.26789@axis700.grange>
References: <20171204232333.30084-1-laurent.pinchart@ideasonboard.com> <alpine.DEB.2.20.1712120832090.26789@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday, 12 December 2017 09:45:11 EET Guennadi Liakhovetski wrote:
> Hi Laurent,
> 
> Thanks for the patches. Please feel free to add either or both of
> 
> Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> Tested-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> 
> to both of the patches. Whereas in fact strictly speaking your current
> tree has updated improved versions of the patches, at least of the first
> of them - it now correctly handles the struct video_device::vfl_dir field,
> even thoough I'd still find merging that "if" with the following "switch"
> prettier ;-) So, strictly speaking you'd have to post those updated
> versions, in any case my approval tags refer to versions in your tree with
> commit IDs
> 
> 53464c9f76da054ac3c291d27f348170d2a346c6
> and
> b6c5f10563c4ee8437cd9131bc3d389514456519

Thank you. You're absolutely right, I've reposted the patches in a v2 with 
your tags included.

-- 
Regards,

Laurent Pinchart
