Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36061 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751869AbeDFVia (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 17:38:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v7 1/8] media: vsp1: Reword uses of 'fragment' as 'body'
Date: Sat, 07 Apr 2018 00:38:28 +0300
Message-ID: <5759588.aAmm6SK8br@avalon>
In-Reply-To: <4b6be5632b722a40c634b85fc67b38a9d44b9dbf.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com> <4b6be5632b722a40c634b85fc67b38a9d44b9dbf.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Thursday, 8 March 2018 02:05:24 EEST Kieran Bingham wrote:
> Throughout the codebase, the term 'fragment' is used to represent a
> display list body. This term duplicates the 'body' which is already in
> use.
> 
> The datasheet references these objects as a body, therefore replace all
> mentions of a fragment with a body, along with the corresponding
> pluralised terms.

I like this, the code seems less confusing to me this way. Please see below 
for a few minor comments.

> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> ---
> v7
>  - Clean up the formatting of the vsp1_dl_list_add_body()
> 
>  drivers/media/platform/vsp1/vsp1_clu.c |  10 +-
>  drivers/media/platform/vsp1/vsp1_dl.c  | 109 ++++++++++++--------------
>  drivers/media/platform/vsp1/vsp1_dl.h  |  13 +--
>  drivers/media/platform/vsp1/vsp1_lut.c |   8 +-
>  4 files changed, 69 insertions(+), 71 deletions(-)

[snip]

> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> b/drivers/media/platform/vsp1/vsp1_dl.c index 0b86ed01e85d..caed441f5f0c
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c

[snip]

> @@ -157,17 +157,16 @@ static void vsp1_dl_body_cleanup(struct
> vsp1_dl_body *dlb) }
> 
>  /**
> - * vsp1_dl_fragment_alloc - Allocate a display list fragment
> + * vsp1_dl_body_alloc - Allocate a display list body
>   * @vsp1: The VSP1 device
> - * @num_entries: The maximum number of entries that the fragment can
> contain
> + * @num_entries: The maximum number of entries that the body can contain
>   *
> - * Allocate a display list fragment with enough memory to contain the
> requested
> + * Allocate a display list body with enough memory to contain the requested
>   * number of entries.
>   *
> - * Return a pointer to a fragment on success or NULL if memory can't be
> - * allocated.
> + * Return a pointer to a body on success or NULL if memory can't be
> allocated.
>   */
> -struct vsp1_dl_body *vsp1_dl_fragment_alloc(struct vsp1_device *vsp1,
> +struct vsp1_dl_body *vsp1_dl_body_alloc(struct vsp1_device *vsp1,
>  					    unsigned int num_entries)

The indentation of the second line now looks wrong.

[snip]

> @@ -379,33 +378,33 @@ void vsp1_dl_list_put(struct vsp1_dl_list *dl)
>   */
>  void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
>  {
> -	vsp1_dl_fragment_write(&dl->body0, reg, data);
> +	vsp1_dl_body_write(&dl->body0, reg, data);
>  }
> 
>  /**
> - * vsp1_dl_list_add_fragment - Add a fragment to the display list
> + * vsp1_dl_list_add_body - Add a body to the display list
>   * @dl: The display list
> - * @dlb: The fragment
> + * @dlb: The body
>   *
> - * Add a display list body as a fragment to a display list. Registers
> contained
> - * in fragments are processed after registers contained in the main display
> - * list, in the order in which fragments are added.
> + * Add a display list body as a body to a display list. Registers contained

"body as a body" sounds strange. How about just "Add a display list body to 
the display list." ?

> + * in bodies are processed after registers contained in the main display
> list,
> + * in the order in which bodies are added.
>   *
> - * Adding a fragment to a display list passes ownership of the fragment to
> the
> - * list. The caller must not touch the fragment after this call, and
> must not
> - * free it explicitly with vsp1_dl_fragment_free().
> + * Adding a body to a display list passes ownership of the body to the
> list. The
> + * caller must not touch the body after this call, and must not free it
> + * explicitly with vsp1_dl_body_free().
>   *
> - * Fragments are only usable for display lists in header mode. Attempt to
> - * add a fragment to a header-less display list will return an error.
> + * Additional bodies are only usable for display lists in header mode.
> + * Attempting to add a body to a header-less display list will return an
> error.
>   */

[snip]

With those two small issues fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
