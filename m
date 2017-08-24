Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:47014 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753700AbdHXT0a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 15:26:30 -0400
Date: Thu, 24 Aug 2017 13:26:28 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        SeongJae Park <sj38.park@gmail.com>,
        Markus Heiser <markus.heiser@darmarit.de>
Subject: Re: [PATCH v2 4/4] docs-rst: Allow Sphinx version 1.6
Message-ID: <20170824132628.75cdf353@lwn.net>
In-Reply-To: <0552b7adf6e023f33494987c3e908101d75250d2.1503477995.git.mchehab@s-opensource.com>
References: <cover.1503477995.git.mchehab@s-opensource.com>
        <0552b7adf6e023f33494987c3e908101d75250d2.1503477995.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 23 Aug 2017 05:56:57 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> Now that the PDF building issues with Sphinx 1.6 got fixed,
> update the documentation and scripts accordingly.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/conf.py              | 3 ---
>  Documentation/doc-guide/sphinx.rst | 4 +---
>  scripts/sphinx-pre-install         | 1 -
>  3 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/Documentation/conf.py b/Documentation/conf.py
> index 8e74d68037a5..0834a9933d69 100644
> --- a/Documentation/conf.py
> +++ b/Documentation/conf.py
> @@ -331,9 +331,6 @@ latex_elements = {
>          \\setromanfont{DejaVu Sans}
>          \\setmonofont{DejaVu Sans Mono}
>  
> -	% To allow adjusting table sizes
> -	\\usepackage{adjustbox}
> -
>       '''
>  }

So this change doesn't quite match the changelog...what's the story there?

Thanks,

jon
