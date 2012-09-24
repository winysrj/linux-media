Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:48355 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753981Ab2IXGGf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 02:06:35 -0400
Received: by obbuo13 with SMTP id uo13so4300203obb.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 23:06:33 -0700 (PDT)
Message-ID: <505FF863.7040305@ti.com>
Date: Mon, 24 Sep 2012 11:36:27 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
MIME-Version: 1.0
To: Shubhrajyoti D <shubhrajyoti@ti.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	julia.lawall@lip6.fr
Subject: Re: [PATCHv4 0/6] media: convert to c99 format
References: <1347970956-11158-1-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1347970956-11158-1-git-send-email-shubhrajyoti@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 18 September 2012 05:52 PM, Shubhrajyoti D wrote:
> The series tries to convert the i2c_msg to c99 struct.
> This may avoid issues like below if someone tries to add an
> element to the structure.
> http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg08972.html
>
> Special thanks to Julia Lawall for helping it automate.
> By the below script.
> http://www.mail-archive.com/cocci@diku.dk/msg02753.html
>
> Changelogs
> - Remove the zero inititialisation of the flags.
ping.
> Shubhrajyoti D (6):
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>
>  drivers/media/i2c/ks0127.c                    |   13 +++++++-
>  drivers/media/i2c/msp3400-driver.c            |   40 +++++++++++++++++++++----
>  drivers/media/i2c/tvaudio.c                   |   13 +++++++-
>  drivers/media/radio/radio-tea5764.c           |   13 ++++++--
>  drivers/media/radio/saa7706h.c                |   15 ++++++++-
>  drivers/media/radio/si470x/radio-si470x-i2c.c |   23 ++++++++++----
>  6 files changed, 96 insertions(+), 21 deletions(-)
>

