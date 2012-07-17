Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49963 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab2GQMm0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 08:42:26 -0400
Message-ID: <50055DA6.40705@iki.fi>
Date: Tue, 17 Jul 2012 15:42:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jean-Fran=E7ois_Moine?= <moinejf@free.fr>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: media_build: ov534_9.c:1381:3: error: implicit declaration of
 function 'err'
References: <50055A23.5040008@iki.fi>
In-Reply-To: <50055A23.5040008@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2012 03:27 PM, Antti Palosaari wrote:
> Hello Jean-François,
>
> I just tried to build drivers using media_build.git.
> Could you look that issue?
>
> /media_build/v4l/ov534_9.c: In function 'sd_init':
> /media_build/v4l/ov534_9.c:1381:3: error: implicit declaration of
> function 'err' [-Werror=implicit-function-declaration]
>
> Diff against 3.5-rc5 says:
>
> 26a27
>  > #undef pr_fmt
> 1380c1381
> <         pr_err("Unknown sensor %04x", sensor_id);
> ---
>  >         err("Unknown sensor %04x", sensor_id);

argh, same seem to be for hdpvr-core.c.

Forget whole issue. 3.5-rc5 seems to have fixed those correctly but 
media_build.git downloads older drivers.

regards
Antti


-- 
http://palosaari.fi/


