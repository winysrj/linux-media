Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47219
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751305AbdFFMsn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Jun 2017 08:48:43 -0400
Date: Tue, 6 Jun 2017 09:48:34 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        hverkuil@xs4all.nl
Subject: Re: [PATCH v3 5/7] docs-rst: media: Sort topic list alphabetically
Message-ID: <20170606094834.0152cd6f@vento.lan>
In-Reply-To: <1491829376-14791-6-git-send-email-sakari.ailus@linux.intel.com>
References: <1491829376-14791-1-git-send-email-sakari.ailus@linux.intel.com>
        <1491829376-14791-6-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 10 Apr 2017 16:02:54 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Bring some order by alphabetically ordering the list of topics.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/media/kapi/v4l2-core.rst | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
> index d8f6c46..2fbf532 100644
> --- a/Documentation/media/kapi/v4l2-core.rst
> +++ b/Documentation/media/kapi/v4l2-core.rst
> @@ -4,23 +4,23 @@ Video4Linux devices
>  .. toctree::
>      :maxdepth: 1
>  
> -    v4l2-intro

NACK.

The order of the documentation should match what makes sense for the
user that will be reading the docs, and *not* an alphabetical order. 

I didn't check what order you did, but for sure the introduction should 
come first, and then the stuff that all drivers use, like
v4l2-dev, v4l2-device and v4l2-fh. Then, other stuff that it is part of
the framework but are used only by a subset of the drivers.

That's said, it probably makes sense to use multiple toctrees here, and
add some description before each of them, in order to better organize
its contents. Something similar to what it was done with
	Documentation/admin-guide/index.rst

I'll rebase patch 6/7 to not depend on this one.


Regards

Thanks,
Mauro
