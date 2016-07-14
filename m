Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:41885 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbcGNKQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 06:16:17 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 2/2] [media] doc-rst: increase depth of the main index
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <4de33984f6584cbb04e0c2bea8aa5a4c8bcbd2b1.1468417933.git.mchehab@s-opensource.com>
Date: Thu, 14 Jul 2016 12:16:03 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C76547C5-1844-4411-9061-CB01D51ACD9B@darmarit.de>
References: <47e23fda1c738e648d2a5470e1dacdc62ce788a5.1468417933.git.mchehab@s-opensource.com> <4de33984f6584cbb04e0c2bea8aa5a4c8bcbd2b1.1468417933.git.mchehab@s-opensource.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Am 13.07.2016 um 15:52 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> It is useful to have an index with all the book contents somewhere,
> as it makes easier to seek for something. So, increase maxdepth
> to 5 for the main index at the beginning of the book.
> 
> While here, remove the genindex content, as it is bogus.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
> Documentation/media/media_uapi.rst | 11 +++--------
> 1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
> index 527c6deb1a19..5e872c8297b0 100644
> --- a/Documentation/media/media_uapi.rst
> +++ b/Documentation/media/media_uapi.rst
> @@ -15,8 +15,10 @@ the license is included in the chapter entitled "GNU Free Documentation
> License".
> 
> 
> +.. contents::
> +

Since there is a ".. toctree" with maxdepth, you don't need
this ".. contents::" directive.

The ".. contents::" directive is helpfull if you want to show
the contents (e.g.) on top of a file which has no toctree in.

-- Markus --

> .. toctree::
> -    :maxdepth: 1
> +    :maxdepth: 5
> 
>     intro
>     uapi/v4l/v4l2
> @@ -26,10 +28,3 @@ License".
>     uapi/cec/cec-api
>     uapi/gen-errors
>     uapi/fdl-appendix
> -
> -.. only:: html
> -
> -  Retrieval
> -  =========
> -
> -  * :ref:`genindex`
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

