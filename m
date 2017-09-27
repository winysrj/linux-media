Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45892 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbdI0VUI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:20:08 -0400
Subject: Re: [PATCH v2 07/13] docs: kernel-doc.rst: add documentation about
 man pages
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
References: <cover.1506546492.git.mchehab@s-opensource.com>
 <d728e50a675aad84310e1418c2d4ec9495322982.1506546492.git.mchehab@s-opensource.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6ef754d0-4c7f-0547-e7e9-8afb87b28506@infradead.org>
Date: Wed, 27 Sep 2017 14:20:03 -0700
MIME-Version: 1.0
In-Reply-To: <d728e50a675aad84310e1418c2d4ec9495322982.1506546492.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/27/17 14:10, Mauro Carvalho Chehab wrote:
> kernel-doc-nano-HOWTO.txt has a chapter about man pages

  kernel-doc.rst has a chapter (or section)

> production. While we don't have a working  "make manpages"
> target, add it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/doc-guide/kernel-doc.rst | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
> index 0923c8bd5769..96012f9e314d 100644
> --- a/Documentation/doc-guide/kernel-doc.rst
> +++ b/Documentation/doc-guide/kernel-doc.rst


-- 
~Randy
