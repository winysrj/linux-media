Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751172AbdGOLmI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 07:42:08 -0400
Date: Sat, 15 Jul 2017 12:42:04 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 10/14] staging:iio:resolver:ad2s1210 fix negative
 IIO_ANGL_VEL read
Message-ID: <20170715124204.0508d7f2@kernel.org>
In-Reply-To: <20170714093129.1366900-1-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
        <20170714093129.1366900-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 14 Jul 2017 11:31:03 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> gcc-7 points out an older regression:
> 
> drivers/staging/iio/resolver/ad2s1210.c: In function 'ad2s1210_read_raw':
> drivers/staging/iio/resolver/ad2s1210.c:515:42: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]
> 
> The original code had 'unsigned short' here, but incorrectly got
> converted to 'bool'. This reverts the regression and uses a normal
> type instead.
> 
> Fixes: 29148543c521 ("staging:iio:resolver:ad2s1210 minimal chan spec conversion.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Thanks Arnd,

Applied to the fixes-togreg branch of iio.git.

Jonathan
> ---
>  drivers/staging/iio/resolver/ad2s1210.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/iio/resolver/ad2s1210.c b/drivers/staging/iio/resolver/ad2s1210.c
> index a6a8393d6664..3e00df74b18c 100644
> --- a/drivers/staging/iio/resolver/ad2s1210.c
> +++ b/drivers/staging/iio/resolver/ad2s1210.c
> @@ -472,7 +472,7 @@ static int ad2s1210_read_raw(struct iio_dev *indio_dev,
>  			     long m)
>  {
>  	struct ad2s1210_state *st = iio_priv(indio_dev);
> -	bool negative;
> +	u16 negative;
>  	int ret = 0;
>  	u16 pos;
>  	s16 vel;
