Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156AbcGCVW7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jul 2016 17:22:59 -0400
Subject: Re: [3/7,media] gspca: avoid unused variable warnings
To: Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1453817424-3080054-3-git-send-email-arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Leandro Costantino <lcostantino@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <aa137f3d-3f15-b2b3-78ce-eea3887394d4@redhat.com>
Date: Sun, 3 Jul 2016 23:22:40 +0200
MIME-Version: 1.0
In-Reply-To: <1453817424-3080054-3-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On 26-01-16 15:09, Arnd Bergmann wrote:
> When CONFIG_INPUT is disabled, multiple gspca backend drivers
> print compile-time warnings about unused variables:
>
> media/usb/gspca/cpia1.c: In function 'sd_stopN':
> media/usb/gspca/cpia1.c:1627:13: error: unused variable 'sd' [-Werror=unused-variable]
> media/usb/gspca/konica.c: In function 'sd_stopN':
> media/usb/gspca/konica.c:246:13: error: unused variable 'sd' [-Werror=unused-variable]
>
> This encloses the declarations in #ifdef CONFIG_INPUT, just like
> the code using them is.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: ee186fd96a5f ("[media] gscpa_t613: Add support for the camera button")
> Fixes: c2f644aeeba3 ("[media] gspca_cpia1: Add support for button")
> Fixes: b517af722860 ("V4L/DVB: gspca_konica: New gspca subdriver for konica chipset using cams")

Sorry for being super slow to respond to this patch, can you
please do a new version using __maybe_unused instead of adding
#ifdef-s ?

Thanks,

Hans


> ---
>  drivers/media/usb/gspca/cpia1.c  | 2 ++
>  drivers/media/usb/gspca/konica.c | 2 ++
>  drivers/media/usb/gspca/t613.c   | 3 ++-
>  3 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/gspca/cpia1.c b/drivers/media/usb/gspca/cpia1.c
> index f23df4a9d8c5..e2264dc5d64d 100644
> --- a/drivers/media/usb/gspca/cpia1.c
> +++ b/drivers/media/usb/gspca/cpia1.c
> @@ -1624,7 +1624,9 @@ static int sd_start(struct gspca_dev *gspca_dev)
>
>  static void sd_stopN(struct gspca_dev *gspca_dev)
>  {
> +#if IS_ENABLED(CONFIG_INPUT)
>  	struct sd *sd = (struct sd *) gspca_dev;
> +#endif
>
>  	command_pause(gspca_dev);
>
> diff --git a/drivers/media/usb/gspca/konica.c b/drivers/media/usb/gspca/konica.c
> index 39c96bb4c985..21c52655ef28 100644
> --- a/drivers/media/usb/gspca/konica.c
> +++ b/drivers/media/usb/gspca/konica.c
> @@ -243,7 +243,9 @@ static int sd_start(struct gspca_dev *gspca_dev)
>
>  static void sd_stopN(struct gspca_dev *gspca_dev)
>  {
> +#if IS_ENABLED(CONFIG_INPUT)
>  	struct sd *sd = (struct sd *) gspca_dev;
> +#endif
>
>  	konica_stream_off(gspca_dev);
>  #if IS_ENABLED(CONFIG_INPUT)
> diff --git a/drivers/media/usb/gspca/t613.c b/drivers/media/usb/gspca/t613.c
> index e2cc4e5a0ccb..d918c2d31502 100644
> --- a/drivers/media/usb/gspca/t613.c
> +++ b/drivers/media/usb/gspca/t613.c
> @@ -837,11 +837,12 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
>  			u8 *data,			/* isoc packet */
>  			int len)			/* iso packet length */
>  {
> -	struct sd *sd = (struct sd *) gspca_dev;
>  	int pkt_type;
>
>  	if (data[0] == 0x5a) {
>  #if IS_ENABLED(CONFIG_INPUT)
> +		struct sd *sd = (struct sd *) gspca_dev;
> +
>  		if (len > 20) {
>  			u8 state = (data[20] & 0x80) ? 1 : 0;
>  			if (sd->button_pressed != state) {
>
