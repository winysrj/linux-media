Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37369
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbcIVKFS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 06:05:18 -0400
Date: Thu, 22 Sep 2016 07:05:08 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC] Remove row numbers from tables in V4L2 documentation
Message-ID: <20160922070508.6cc6e249@vento.lan>
In-Reply-To: <7698306.QJLkYlHSte@avalon>
References: <7698306.QJLkYlHSte@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 21 Sep 2016 11:48:22 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hello,
> 
> While documenting the metadata API I got annoyed by how tables were converted
> from DocBook to ReST.
> 
> The table format currently used by the documentation is as follows:
> 
>  -  .. row 1
>     - row 1, entry 1
>     - row 1, entry 2
>  -  .. row 2
>     - row 2, entry 1
>     - row 2, entry 2
> 
> The comments that include row numbers are not only useless, but make row
> insertion or deletion painful.
> 
> I propose switching to the following format instead:
> 
>  * - row 1, entry 1
>    - row 1, entry 2
>  * - row 2, entry 1
>    - row 2, entry 2
> 
> I've pushed two patches that perform the conversion to
> 
> 	git://linuxtv.org/pinchartl/media.git v4l2/doc

Applied. Thanks!
Thanks,
Mauro
