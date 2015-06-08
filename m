Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0005.hostedemail.com ([216.40.44.5]:34956 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751278AbbFHUDM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 16:03:12 -0400
Message-ID: <1433793783.2730.9.camel@perches.com>
Subject: Re: [PATCH 18/26] [media] dvb: Get rid of typedev usage for enums
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Jemma Denson <jdenson@gmail.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Shuah Khan <shuah.kh@samsung.com>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Martin Kepplinger <martink@posteo.de>,
	Richard Vollkommer <linux@hauppauge.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Himangi Saraogi <himangi774@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Heinrich Schuchardt <xypron.glpk@gmx.de>,
	Cheolhyun Park <pch851130@gmail.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Benoit Taine <benoit.taine@lip6.fr>,
	Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>,
	Fred Richter <frichter@hauppauge.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Wennborg <hans@hanshq.net>, Arnd Bergmann <arnd@arndb.de>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Christian Engelmayer <cengelma@gmx.at>,
	Luis de Bethencourt <luis.bg@samsung.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Asaf Vertz <asaf.vertz@tandemg.com>,
	Emil Goode <emilgoode@gmail.com>,
	Maks Naumov <maksqwe1@ukr.net>,
	Olli Salonen <olli.salonen@iki.fi>,
	Nibble Max <nibble.max@gmail.com>,
	James Harper <james.harper@ejbdigital.com.au>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Pawel Osciak <pawel@osciak.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jiri Kosina <jkosina@suse.cz>,
	Masanari Iida <standby24x7@gmail.com>,
	Thomas Reitmayr <treitmayr@devbase.at>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>,
	CrazyCat <crazycat69@narod.ru>,
	Fabian Frederick <fabf@skynet.be>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux1394-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
	linux-api@vger.kernel.org
Date: Mon, 08 Jun 2015 13:03:03 -0700
In-Reply-To: <336c59e13064f2fa872a1682268f1995deb18fa5.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
	 <336c59e13064f2fa872a1682268f1995deb18fa5.1433792665.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2015-06-08 at 16:54 -0300, Mauro Carvalho Chehab wrote:
> The DVB API was originally defined using typedefs. This is against
> Kernel CodingStyle, and there's no good usage here. While we can't
> remove its usage on userspace, we can avoid its usage in Kernelspace.
> 
> So, let's do it.
> 
> This patch was generated by this shell script:
> 
> 	for j in $(grep typedef include/uapi/linux/dvb/frontend.h |cut -d' ' -f 3); do for i in $(find drivers/media -name '*.[ch]' -type f) $(find drivers/staging/media -name '*.[ch]' -type f); do sed "s,${j}_t,enum $j," <$i >a && mv a $i; done; done

Seems sensible, thanks.

> While here, make CodingStyle fixes on the affected lines.

Trivial note examples:

> diff --git a/drivers/media/common/b2c2/flexcop-fe-tuner.c b/drivers/media/common/b2c2/flexcop-fe-tuner.c
[]
> @@ -39,7 +39,8 @@ static int flexcop_fe_request_firmware(struct dvb_frontend *fe,
>  
>  /* lnb control */
>  #if FE_SUPPORTED(MT312) || FE_SUPPORTED(STV0299)
> -static int flexcop_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
> +static int flexcop_set_voltage(struct dvb_frontend *fe,
> +			       enum fe_sec_voltage voltage)

Aligned to open paren.

> @@ -157,7 +158,7 @@ static int flexcop_diseqc_send_master_cmd(struct dvb_frontend *fe,
>  }
>  
>  static int flexcop_diseqc_send_burst(struct dvb_frontend *fe,
> -	fe_sec_mini_cmd_t minicmd)
> +	enum fe_sec_mini_cmd minicmd)

Not aligned to open paren.

Why some and not all?

> diff --git a/drivers/media/common/siano/smsdvb.h b/drivers/media/common/siano/smsdvb.h
[]
> @@ -40,7 +40,7 @@ struct smsdvb_client_t {
>  	struct dmxdev           dmxdev;
>  	struct dvb_frontend     frontend;
>  
> -	fe_status_t             fe_status;
> +	enum fe_status             fe_status;

Maybe realign these too.


