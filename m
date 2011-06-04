Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:59589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab1FDIVO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 04:21:14 -0400
Message-ID: <4DE9EB0E.8070207@redhat.com>
Date: Sat, 04 Jun 2011 10:21:34 +0200
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
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Interesting. I'll go and test this with my 6 or so pac207 cameras,
but first I need to wait till this evening as atm it is too
light to test high exposure settings :)

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
