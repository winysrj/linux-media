Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:47473 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759618AbcHEJ1O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 05:27:14 -0400
Subject: Re: [PATCH] doc-rst: customize RTD theme, drop padding of inline
 literal
To: Markus Heiser <markus.heiser@darmarit.de>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
References: <1470388783-5200-1-git-send-email-markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <54a6dd78-b424-6bdc-2c46-25e44b3c41f7@xs4all.nl>
Date: Fri, 5 Aug 2016 11:27:07 +0200
MIME-Version: 1.0
In-Reply-To: <1470388783-5200-1-git-send-email-markus.heiser@darmarit.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/05/2016 11:19 AM, Markus Heiser wrote:
> From: Markus Heiser <markus.heiser@darmarIT.de>
> 
> Remove the distracting (left/right) padding of inline literals. (HTML
> <code>). Requested and discussed in [1].
> 
> [1] http://www.spinics.net/lists/linux-media/msg103991.html
> 
> Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thank you! Thank you! Thank you!

So much better!

Regards,

	Hans

> ---
>  Documentation/sphinx-static/theme_overrides.css | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/sphinx-static/theme_overrides.css b/Documentation/sphinx-static/theme_overrides.css
> index 3a2ac4b..e88461c 100644
> --- a/Documentation/sphinx-static/theme_overrides.css
> +++ b/Documentation/sphinx-static/theme_overrides.css
> @@ -42,11 +42,12 @@
>      caption a.headerlink { opacity: 0; }
>      caption a.headerlink:hover { opacity: 1; }
>  
> -    /* inline literal: drop the borderbox and red color */
> +    /* inline literal: drop the borderbox, padding and red color */
>  
>      code, .rst-content tt, .rst-content code {
>          color: inherit;
>          border: none;
> +        padding: unset;
>          background: inherit;
>          font-size: 85%;
>      }
> 
