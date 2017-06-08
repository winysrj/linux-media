Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58671
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750822AbdFHRvo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 13:51:44 -0400
Date: Thu, 8 Jun 2017 14:51:36 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] media-ioc-g-topology.rst: fix typos
Message-ID: <20170608145136.601612be@vento.lan>
In-Reply-To: <20170607093302.59312-1-acourbot@chromium.org>
References: <20170607093302.59312-1-acourbot@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  7 Jun 2017 18:33:02 +0900
Alexandre Courbot <acourbot@chromium.org> escreveu:

> Fix what seems to be a few typos induced by copy/paste.
> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  Documentation/media/uapi/mediactl/media-ioc-g-topology.rst | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> index 48c9531f4db0..5f2d82756033 100644
> --- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> +++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> @@ -241,7 +241,7 @@ desired arrays with the media graph elements.
>  
>  .. c:type:: media_v2_intf_devnode
>  
> -.. flat-table:: struct media_v2_interface
> +.. flat-table:: struct media_v2_devnode
>      :header-rows:  0
>      :stub-columns: 0
>      :widths: 1 2 8

Actually the fix is wrong here :-)

I'll just fold the following diff to your patch:

diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index 5f2d82756033..add8281494f8 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -241,7 +241,7 @@ desired arrays with the media graph elements.
 
 .. c:type:: media_v2_intf_devnode
 
-.. flat-table:: struct media_v2_devnode
+.. flat-table:: struct media_v2_intf_devnode
     :header-rows:  0
     :stub-columns: 0
     :widths: 1 2 8

Thanks,
Mauro
