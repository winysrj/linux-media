Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49178 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752440AbdK3Mtp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 07:49:45 -0500
Date: Thu, 30 Nov 2017 10:49:34 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org, Sergey Kozlov <serjk@netup.ru>,
        Abylay Ospan <aospan@netup.ru>,
        Daniel Scheller <d.scheller@gmx.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RESEND 1/2] dvb-frontends: fix i2c access helpers for
 KASAN
Message-ID: <20171130104934.30dcfdf6@vento.lan>
In-Reply-To: <20171130110939.1140969-1-arnd@arndb.de>
References: <20171130110939.1140969-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Em Thu, 30 Nov 2017 12:08:04 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> A typical code fragment was copied across many dvb-frontend drivers and
> causes large stack frames when built with with CONFIG_KASAN on gcc-5/6/7:
> 
> drivers/media/dvb-frontends/cxd2841er.c:3225:1: error: the frame size of 3992 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
> drivers/media/dvb-frontends/cxd2841er.c:3404:1: error: the frame size of 3136 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
> drivers/media/dvb-frontends/stv0367.c:3143:1: error: the frame size of 4016 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
> drivers/media/dvb-frontends/stv090x.c:3430:1: error: the frame size of 5312 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
> drivers/media/dvb-frontends/stv090x.c:4248:1: error: the frame size of 4872 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
> 
> gcc-8 now solves this by consolidating the stack slots for the argument
> variables, but on older compilers we can get the same behavior by taking
> the pointer of a local variable rather than the inline function argument.
> 
> Cc: stable@vger.kernel.org
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81715
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I'm undecided here whether there should be a comment pointing
> to PR81715 for each file that the bogus local variable workaround
> to prevent it from being cleaned up again. It's probably not
> necessary since anything that causes actual problems would also
> trigger a build warning.
> ---
>  drivers/media/dvb-frontends/ascot2e.c     | 4 +++-
>  drivers/media/dvb-frontends/cxd2841er.c   | 4 +++-
>  drivers/media/dvb-frontends/helene.c      | 4 +++-
>  drivers/media/dvb-frontends/horus3a.c     | 4 +++-
>  drivers/media/dvb-frontends/itd1000.c     | 5 +++--
>  drivers/media/dvb-frontends/mt312.c       | 4 +++-
>  drivers/media/dvb-frontends/stb0899_drv.c | 3 ++-
>  drivers/media/dvb-frontends/stb6100.c     | 6 ++++--
>  drivers/media/dvb-frontends/stv0367.c     | 4 +++-
>  drivers/media/dvb-frontends/stv090x.c     | 4 +++-
>  drivers/media/dvb-frontends/stv6110x.c    | 4 +++-
>  drivers/media/dvb-frontends/zl10039.c     | 4 +++-
>  12 files changed, 36 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/ascot2e.c b/drivers/media/dvb-frontends/ascot2e.c
> index 0ee0df53b91b..1219272ca3f0 100644
> --- a/drivers/media/dvb-frontends/ascot2e.c
> +++ b/drivers/media/dvb-frontends/ascot2e.c
> @@ -155,7 +155,9 @@ static int ascot2e_write_regs(struct ascot2e_priv *priv,
>  
>  static int ascot2e_write_reg(struct ascot2e_priv *priv, u8 reg, u8 val)
>  {
> -	return ascot2e_write_regs(priv, reg, &val, 1);
> +	u8 tmp = val;
> +
> +	return ascot2e_write_regs(priv, reg, &tmp, 1);
>  }
>  
>  static int ascot2e_read_regs(struct ascot2e_priv *priv,
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 48ee9bc00c06..b7574deff5c6 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -257,7 +257,9 @@ static int cxd2841er_write_regs(struct cxd2841er_priv *priv,
>  static int cxd2841er_write_reg(struct cxd2841er_priv *priv,
>  			       u8 addr, u8 reg, u8 val)
>  {
> -	return cxd2841er_write_regs(priv, addr, reg, &val, 1);
> +	u8 tmp = val;
> +
> +	return cxd2841er_write_regs(priv, addr, reg, &tmp, 1);
>  }


This kind of sucks, and it is completely unexpected... why val is
so special that it would require this kind of hack?

Also, there's always a risk of someone see it and decide to 
simplify the code, returning it to the previous state.

So, if we're willing to do something like that, IMHO, we should have
some macro that would document it, and fall back to the direct
code if the compiler is not gcc 5, 6 or 7.

Regards,
Mauro
