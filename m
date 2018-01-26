Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36321 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751363AbeAZUkO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 15:40:14 -0500
Subject: Re: [RFC PATCH 6/8] v4l2: document the request API interface
To: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180126060216.147918-1-acourbot@chromium.org>
 <20180126060216.147918-7-acourbot@chromium.org>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <98ccb2f3-156e-2f4e-4630-9d16d157d65b@infradead.org>
Date: Fri, 26 Jan 2018 12:40:10 -0800
MIME-Version: 1.0
In-Reply-To: <20180126060216.147918-7-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/25/2018 10:02 PM, Alexandre Courbot wrote:
> Document how the request API can be used along with the existing V4L2
> interface.
> 

> +Request API
> +===========
> +
> +The Request API has been designed to allow V4L2 to deal with requirements of
> +modern IPs (stateless codecs, MIPI cameras, ...) and APIs (Android Codec v2).

Hi,
Just a quick question:  What are IPs?

Not Internet Protocols. Hopefully not Intellectual Properties.
Maybe Intelligent Processors?

thanks,
-- 
~Randy
