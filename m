Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275ECC67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBB922075B
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:02:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBB922075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbeLMNCH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 08:02:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:36652 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbeLMNCG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 08:02:06 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 05:02:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,349,1539673200"; 
   d="scan'208";a="101246247"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga008.jf.intel.com with ESMTP; 13 Dec 2018 05:02:04 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id DF0A2207AF; Thu, 13 Dec 2018 15:02:03 +0200 (EET)
Date:   Thu, 13 Dec 2018 15:02:03 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl, mchehab@kernel.org
Subject: Re: [PATCH 3/3] videobuf2-core.h: Document the alloc memop size
 argument as page aligned
Message-ID: <20181213130203.jzjltl6hxlwlp5wk@paasikivi.fi.intel.com>
References: <20181213104006.401-1-sakari.ailus@linux.intel.com>
 <20181213104006.401-4-sakari.ailus@linux.intel.com>
 <2569261.dXsbqdVbdC@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2569261.dXsbqdVbdC@avalon>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 13, 2018 at 02:59:50PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Thursday, 13 December 2018 12:40:06 EET Sakari Ailus wrote:
> > The size argument of the alloc memop, which allocates buffer memory, is
> > page aligned. Document it as such, as code elsewhere has not taken this
> > into account.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  include/media/videobuf2-core.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> > index e86981d615ae4..68b9fe660e4f1 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h
> > @@ -54,7 +54,8 @@ struct vb2_threadio_data;
> >   *		will then be passed as @buf_priv argument to other ops in this
> >   *		structure. Additional gfp_flags to use when allocating the
> >   *		are also passed to this operation. These flags are from the
> > - *		gfp_flags field of vb2_queue.
> > + *		gfp_flags field of vb2_queue. The size argument to this function
> > + *		shall be *page aligned*.
> >   * @put:	inform the allocator that the buffer will no longer be used;
> >   *		usually will result in the allocator freeing the buffer (if
> >   *		no other users of this buffer are present); the @buf_priv
> 
> I wonder if a WARN_ON() to ensure this would make sense. In any case,

There's a single place where the alloc() op is called. I thought it'd be
silly to put a check after the line of code that performs the alignment.

Perhaps a comment right there?

I'm open to other ideas that don't seem silly. :-)

> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
