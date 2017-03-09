Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:56191 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754213AbdCIJtx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 04:49:53 -0500
Subject: Re: [PATCH 1/1] docs-rst: media: Push CEC documentation under CEC
 section
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <1489052418-12575-1-git-send-email-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <79c9573c-19da-4f3f-bd7c-0256e1986bab@xs4all.nl>
Date: Thu, 9 Mar 2017 10:49:47 +0100
MIME-Version: 1.0
In-Reply-To: <1489052418-12575-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/17 10:40, Sakari Ailus wrote:
> The CEC documentation added two sections on the main media kAPI level.
> There should be only one.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  Documentation/media/kapi/cec-core.rst | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
> index 81c6d8e..79db774 100644
> --- a/Documentation/media/kapi/cec-core.rst
> +++ b/Documentation/media/kapi/cec-core.rst
> @@ -27,11 +27,8 @@ HDMI 1.3a specification is sufficient:
>  http://www.microprocessor.org/HDMISpecification13a.pdf
>  
>  
> -The Kernel Interface
> -====================
> -
> -CEC Adapter
> ------------
> +CEC Adapter Interface
> +---------------------
>  
>  The struct cec_adapter represents the CEC adapter hardware. It is created by
>  calling cec_allocate_adapter() and deleted by calling cec_delete_adapter():
> 
