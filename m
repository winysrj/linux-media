Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33277 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149AbcFASPm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2016 14:15:42 -0400
Date: Wed, 1 Jun 2016 11:15:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
Subject: Re: [PATCH v3 7/8] Input: atmel_mxt_ts - add diagnostic data support
 for mXT1386
Message-ID: <20160601181537.GC4114@dtor-ws>
References: <1464799192-28034-1-git-send-email-nick.dyer@itdev.co.uk>
 <1464799192-28034-8-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1464799192-28034-8-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 01, 2016 at 05:39:51PM +0100, Nick Dyer wrote:
> The mXT1386 family of chips have a different architecture which splits
> the diagnostic data into 3 columns.
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index eced661..7d8002d 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -137,6 +137,10 @@ struct t9_range {
>  #define MXT_DIAGNOSTIC_DELTAS	0x10
>  #define MXT_DIAGNOSTIC_SIZE	128
>  
> +#define MXT_FAMILY_1386			160
> +#define MXT1386_COLUMNS			3
> +#define MXT1386_PAGES_PER_COLUMN	8
> +
>  struct t37_debug {
>  	u8 mode;
>  	u8 page;
> @@ -2135,13 +2139,27 @@ recheck:
>  static u16 mxt_get_debug_value(struct mxt_data *data, unsigned int x,
>  			       unsigned int y)
>  {
> +	struct mxt_info *info = &data->info;
>  	struct mxt_dbg *dbg = &data->dbg;
>  	unsigned int ofs, page;
> +	unsigned int col = 0;
> +	unsigned int col_width;
> +
> +	if (info->family_id == MXT_FAMILY_1386) {
> +		col_width = info->matrix_ysize / MXT1386_COLUMNS;
> +		col = y / col_width;
> +		y = y % col_width;
> +	} else {
> +		col_width = info->matrix_ysize;
> +	}
>  
> -	ofs = (y + (x * data->info.matrix_ysize)) * sizeof(u16);
> +	ofs = (y + (x * col_width)) * sizeof(u16);
>  	page = ofs / MXT_DIAGNOSTIC_SIZE;
>  	ofs %= MXT_DIAGNOSTIC_SIZE;
>  
> +	if (info->family_id == MXT_FAMILY_1386)
> +		page += col * MXT1386_PAGES_PER_COLUMN;
> +
>  	return get_unaligned_le16(&dbg->t37_buf[page].data[ofs]);
>  }
>  
> @@ -2411,6 +2429,7 @@ static const struct video_device mxt_video_device = {
>  
>  static void mxt_debug_init(struct mxt_data *data)
>  {
> +	struct mxt_info *info = &data->info;
>  	struct mxt_dbg *dbg = &data->dbg;
>  	struct mxt_object *object;
>  	int error;
> @@ -2434,9 +2453,13 @@ static void mxt_debug_init(struct mxt_data *data)
>  
>  	/* Calculate size of data and allocate buffer */
>  	dbg->t37_nodes = data->xsize * data->ysize;
> -	dbg->t37_pages = ((data->xsize * data->info.matrix_ysize)
> -			  * sizeof(u16) / sizeof(dbg->t37_buf->data)) + 1;
>  
> +	if (info->family_id == MXT_FAMILY_1386)
> +		dbg->t37_pages = MXT1386_COLUMNS * MXT1386_PAGES_PER_COLUMN;
> +	else
> +		dbg->t37_pages = ((data->xsize * info->matrix_ysize)
> +				   * sizeof(u16) / sizeof(dbg->t37_buf->data))
> +				   + 1;

Won't this result in an extra page in some cases. DIV_ROUND_UP instead?

>  
>  	dbg->t37_buf = devm_kzalloc(&data->client->dev,
>  				     sizeof(struct t37_debug) * dbg->t37_pages,
> -- 
> 2.5.0
> 

-- 
Dmitry
