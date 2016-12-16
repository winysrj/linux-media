Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48414 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754916AbcLPKaN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 05:30:13 -0500
Date: Fri, 16 Dec 2016 12:30:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gen-errors.rst: document EIO
Message-ID: <20161216103006.GH16630@valkosipuli.retiisi.org.uk>
References: <3c05072b-f3ee-4018-d5a8-d341e66fedfe@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c05072b-f3ee-4018-d5a8-d341e66fedfe@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 16, 2016 at 10:22:08AM +0100, Hans Verkuil wrote:
> Document the EIO error since this can happen anywhere anytime and applications
> should be aware of this.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/Documentation/media/uapi/gen-errors.rst b/Documentation/media/uapi/gen-errors.rst
> index 6e983b9..ee224b9 100644
> --- a/Documentation/media/uapi/gen-errors.rst
> +++ b/Documentation/media/uapi/gen-errors.rst
> @@ -94,6 +94,14 @@ Generic Error Codes
>         -  Permission denied. Can be returned if the device needs write
>  	  permission, or some special capabilities is needed (e. g. root)
> 
> +    -  .. row 11
> +
> +       -  ``EIO``
> +
> +       -  I/O error. Typically used when there are problems communicating with
> +          a hardware device. This could indicate broken or flaky hardware.
> +	  It's a 'Something is wrong, I give up!' type of error.
> +
>  .. note::
> 
>    #. This list is not exaustive; ioctls may return other error codes.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
