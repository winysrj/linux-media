Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33260 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968076AbdI0CEI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 22:04:08 -0400
Subject: Re: [PATCH 02/10] docs: kernel-doc.rst: better describe kernel-doc
 arguments
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
References: <cover.1506448061.git.mchehab@s-opensource.com>
 <66135bb9d76913c9f1515d33e731b94becbc98da.1506448061.git.mchehab@s-opensource.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f50f8ce4-96f1-5586-173e-1d8e1a31d598@infradead.org>
Date: Tue, 26 Sep 2017 19:04:01 -0700
MIME-Version: 1.0
In-Reply-To: <66135bb9d76913c9f1515d33e731b94becbc98da.1506448061.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/26/17 10:59, Mauro Carvalho Chehab wrote:
> Add a new section to describe kernel-doc arguments,
> adding examples about how identation should happen, as failing
> to do that causes Sphinx to do the wrong thing.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/doc-guide/kernel-doc.rst | 44 +++++++++++++++++++++++++++++++---
>  1 file changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
> index b24854b5d6be..7a3f5c710c0b 100644
> --- a/Documentation/doc-guide/kernel-doc.rst
> +++ b/Documentation/doc-guide/kernel-doc.rst
> @@ -112,16 +112,17 @@ Example kernel-doc function comment::
>  
>    /**
>     * foobar() - Brief description of foobar.
> -   * @arg: Description of argument of foobar.
> +   * @argument1: Description of parameter argument1 of foobar.
> +   * @argument1: Description of parameter argument2 of foobar.

        @argument2:

>     *
>     * Longer description of foobar.
>     *
>     * Return: Description of return value of foobar.
>     */
> -  int foobar(int arg)
> +  int foobar(int argument1, char *argument2)


-- 
~Randy
