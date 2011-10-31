Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934434Ab1JaMg3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 08:36:29 -0400
Message-ID: <4EAE9661.7010006@redhat.com>
Date: Mon, 31 Oct 2011 13:36:49 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Marco_Diego_Aur=E9lio_Mesquita?=
	<marcodiegomesquita@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Increase max exposure value to 255 from 26.
References: <BANLkTikCgTWA92P2Qw4hqyvmQFRZm7+Aog@mail.gmail.com>
In-Reply-To: <BANLkTikCgTWA92P2Qw4hqyvmQFRZm7+Aog@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch, I've taken a look at this, and the way the pac207's
exposure control works is it sets the fps according to the formula of:
90 / exposure reg value. So the old max setting gave you a max exposure
time of 90 / 26 = 3.46 fps or 288.9 milliseconds.

3.46 fps already is quite slow for a webcam, but I agree that under low light
conditions higher exposure settings are necessary. However setting a max
value of 255 would mean the camera would run at 0.35 fps, which would mean
3 seconds between frames likely triggering timeouts in various applications,
or if a frame gets damaged and dropped, 6 seconds, triggering a timeout
condition inside the gspca core.

Thinking more about this I think that a max exposure setting of 1 second
is a sane value, so I've prepared a patch and send a pull request for
this to Mauro which changes the max exposure setting to 90. I've also
included some tweaks to the knee values for the auto exposure knee
algorithm used, to make auto exposure work better under various
circumstances.

Regards,

Hans




On 06/04/2011 09:38 AM, Marco Diego Aurélio Mesquita wrote:
> The inline patch increases maximum exposure value from 26 to 255. It
> has been tested and works well. Without the patch the captured image
> is too dark and can't be improved too much.
>
> Please CC answers as I'm not subscribed to the list.
>
>
> Signed-off-by: Marco Diego Aurélio Mesquita<marcodiegomesquita@gmail.com>
> ---
>   drivers/media/video/gspca/pac207.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/gspca/pac207.c
> b/drivers/media/video/gspca/pac207.c
> index 892b454..6a2fb26 100644
> --- a/drivers/media/video/gspca/pac207.c
> +++ b/drivers/media/video/gspca/pac207.c
> @@ -39,7 +39,7 @@ MODULE_LICENSE("GPL");
>   #define PAC207_BRIGHTNESS_DEFAULT	46
>
>   #define PAC207_EXPOSURE_MIN		3
> -#define PAC207_EXPOSURE_MAX		26
> +#define PAC207_EXPOSURE_MAX		255
>   #define PAC207_EXPOSURE_DEFAULT		5 /* power on default: 3 */
>   #define PAC207_EXPOSURE_KNEE		8 /* 4 = 30 fps, 11 = 8, 15 = 6 */
>
