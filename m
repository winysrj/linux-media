Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1C2Yvbg005150
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 21:34:57 -0500
Received: from host06.hostingexpert.com (host06.hostingexpert.com
	[216.80.70.60])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1C2YacN016571
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 21:34:36 -0500
Message-ID: <47B105B8.7010900@linuxtv.org>
Date: Mon, 11 Feb 2008 21:34:32 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Tony Breeds <tony@bakeyournoodle.com>
References: <200802111154.31760.toralf.foerster@gmx.de>
	<20080212004251.GT6887@bakeyournoodle.com>
In-Reply-To: <20080212004251.GT6887@bakeyournoodle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com,
	=?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Steven Toth <stoth@hauppauge.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: build #345 issue for v2.6.25-rc1 in tuner-core.c
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Tony Breeds wrote:
> On Mon, Feb 11, 2008 at 11:54:31AM +0100, Toralf Förster wrote:
>   
>> Hello,
>>
>> the build with the attached .config failed, make ending with:
>> ...
>>   MODPOST vmlinux.o
>> WARNING: modpost: Found 12 section mismatch(es).
>> To see full details build your kernel with:
>> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>>   GEN     .version
>>   CHK     include/linux/compile.h
>>   UPD     include/linux/compile.h
>>   CC      init/version.o
>>   LD      init/built-in.o
>>   LD      .tmp_vmlinux1
>> drivers/built-in.o: In function `set_type':
>> tuner-core.c:(.text+0x8879d): undefined reference to `xc5000_attach'
>> make: *** [.tmp_vmlinux1] Error 1
>>     
>
> <snip>
> Fix Build error for xc5000 tuner when built as module.
>
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
>   
Patch is correct.  Not sure which tag is appropriate.....

Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

This should go straight to Linus.....  Andrew or Mauro, can one of you
take care of it?

Regards,

Mike
> ---
> Not 100% certain this is correct but it works for me :) Michael?
>
>  drivers/media/dvb/frontends/xc5000.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/xc5000.h b/drivers/media/dvb/frontends/xc5000.h
> index e0e8456..32a5f1c 100644
> --- a/drivers/media/dvb/frontends/xc5000.h
> +++ b/drivers/media/dvb/frontends/xc5000.h
> @@ -45,7 +45,8 @@ struct xc5000_config {
>  /* xc5000 callback command */
>  #define XC5000_TUNER_RESET		0
>  
> -#if defined(CONFIG_DVB_TUNER_XC5000) || defined(CONFIG_DVB_TUNER_XC5000_MODULE)
> +#if defined(CONFIG_DVB_TUNER_XC5000) || \
> +    (defined(CONFIG_DVB_TUNER_XC5000_MODULE) && defined(MODULE))
>  extern struct dvb_frontend* xc5000_attach(struct dvb_frontend *fe,
>  					  struct i2c_adapter *i2c,
>  					  struct xc5000_config *cfg);
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
