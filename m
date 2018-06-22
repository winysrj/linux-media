Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.anw.at ([195.234.102.72]:43423 "EHLO smtp.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933869AbeFVSao (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 14:30:44 -0400
Subject: Re: [PATCH 3/3] [media] dvb-frontends/cxd2099: fix boilerplate
 whitespace
To: Daniel Scheller <d.scheller.oss@gmail.com>, mchehab@kernel.org,
        mchehab@s-opensource.com, rjkm@metzlerbros.de,
        mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
References: <20180619185119.24548-1-d.scheller.oss@gmail.com>
 <20180619185119.24548-4-d.scheller.oss@gmail.com>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <7fd59c35-063f-bf70-376f-05827ebd003b@anw.at>
Date: Fri, 22 Jun 2018 20:30:36 +0200
MIME-Version: 1.0
In-Reply-To: <20180619185119.24548-4-d.scheller.oss@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-AT
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You can add my Acked-by: Jasmin Jessich <jasmin@anw.at>

On 06/19/2018 08:51 PM, Daniel Scheller wrote:
> From: Daniel Scheller <d.scheller@gmx.net>
> 
> There's a superfluous whitespace in the boilerplate license text in both
> .c and .h files. Fix this.
> 
> Cc: Ralph Metzler <rjkm@metzlerbros.de>
> Cc: Manfred Voelkel <mvoelkel@DigitalDevices.de>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2099.c | 2 +-
>  drivers/media/dvb-frontends/cxd2099.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/cxd2099.c b/drivers/media/dvb-frontends/cxd2099.c
> index 5264e873850e..5d8884ed64ef 100644
> --- a/drivers/media/dvb-frontends/cxd2099.c
> +++ b/drivers/media/dvb-frontends/cxd2099.c
> @@ -10,7 +10,7 @@
>   *
>   * This program is distributed in the hope that it will be useful,
>   * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>   * GNU General Public License for more details.
>   */
>  
> diff --git a/drivers/media/dvb-frontends/cxd2099.h b/drivers/media/dvb-frontends/cxd2099.h
> index 0c101bdef01d..30787095843a 100644
> --- a/drivers/media/dvb-frontends/cxd2099.h
> +++ b/drivers/media/dvb-frontends/cxd2099.h
> @@ -10,7 +10,7 @@
>   *
>   * This program is distributed in the hope that it will be useful,
>   * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>   * GNU General Public License for more details.
>   */
>  
> 
