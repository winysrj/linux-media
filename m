Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58834 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933738AbeF1M3m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 08:29:42 -0400
Date: Thu, 28 Jun 2018 15:29:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv3 0/8] media/mc: fix inconsistencies
Message-ID: <20180628122940.qxyunzbqlc5ostpn@valkosipuli.retiisi.org.uk>
References: <20180621071914.28729-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180621071914.28729-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 21, 2018 at 09:19:06AM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series sits on top of this pull request:
> 
> https://patchwork.linuxtv.org/patch/50453/
> 
> That pull request cleans up the tables in the documentation, making it
> easier to add new entries.
> 
> This series is v3 of my previous attempt:
> 
> https://www.spinics.net/lists/linux-media/msg132218.html
> 
> The goal is to fix the inconsistencies between the 'old' and 'new' 
> MC API. I hate the terms 'old' and 'new', there is nothing wrong IMHO with 
> using an 'old' API if it meets the needs of the application.
> 
> The differences between v2 and v3 are that I changed that I changed
> the defines that test if the index or flags fields are present:
> 
> /*
>  * Appeared in 4.19.0.
>  *
>  * The media_version argument comes from the media_version field in
>  * struct media_device_info.
>  */
> #define MEDIA_V2_PAD_HAS_INDEX(media_version) \
>        ((media_version) >= ((4 << 16) | (19 << 8) | 0))
> 
> KERNEL_VERSION cannot be used in a public header, and my previous
> attempt used 0x00041300, which isn't as readable as what I do now.
> I also expanded the comment before the define pointing to struct
> media_device_info. I also did the same in the documentation.
> 
> I dropped the patches adding a function field to struct media_entity_desc.
> Instead I started the work to ensure all drivers set function correctly.
> 
> I still want to add a 'function' field to struct media_entity_desc but
> step one is to make sure drivers actually set function correctly. I'll
> revisit this once that's done.
> 
> Making G_TOPOLOGY useful is urgently needed since I think that will be
> very helpful for the work we want to do on library support for complex
> cameras.

For the set:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
