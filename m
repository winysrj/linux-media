Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab1LGJ7L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Dec 2011 04:59:11 -0500
Message-ID: <4EDF38E9.7010504@redhat.com>
Date: Wed, 07 Dec 2011 07:59:05 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Eddi De Pieri <eddi@depieri.net>, linux-media@vger.kernel.org,
	Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 5/8] [media] em28xx: initial support for HAUPPAUGE HVR-930C
 again
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com> <1321800978-27912-2-git-send-email-mchehab@redhat.com> <1321800978-27912-3-git-send-email-mchehab@redhat.com> <1321800978-27912-4-git-send-email-mchehab@redhat.com> <1321800978-27912-5-git-send-email-mchehab@redhat.com> <CAGoCfiwv1MWnJc+3HL+9-E=o+HG09jjdGYOfpoXSoPd+wW3oHg@mail.gmail.com> <4EDD0F01.7040808@redhat.com> <CAGoCfizRuBEgBhfnzyrE=aJD-WMXCz9OmkoEqQCDpqmYXU2=zA@mail.gmail.com> <CAGoCfiywqY+U0+t9tget1X09=apDm46GpGCa-_QiGp+JhyLXxQ@mail.gmail.com> <CAKdnbx7Ayg6AGS-u=z9Pg6pHV6UN_ZiB-kQ1rv78zG9nm+U9TA@mail.gmail.com> <CAGoCfiwwt898OwmNNwrboT7q5v-sNQuTP6TxCdtY-fFauAyHrA@mail.gmail.com>
In-Reply-To: <CAGoCfiwwt898OwmNNwrboT7q5v-sNQuTP6TxCdtY-fFauAyHrA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05-12-2011 21:47, Devin Heitmueller wrote:
> On Mon, Dec 5, 2011 at 6:32 PM, Eddi De Pieri<eddi@depieri.net>  wrote:
>> Sorry,  I think I applied follow patch on my tree while I developed
>> the driver trying to fix tuner initialization.
>>
>> http://patchwork.linuxtv.org/patch/6617/
>>
>> I forgot to remove from my tree after I see that don't solve anything.
>
> Ok, great.  At least that explains why it's there (since I couldn't
> figure out how on Earth the patch made sense otherwise).
>
> Eddi, could you please submit a patch removing the offending code?

Ok, As Eddi agreed with this change, I'm adding the enclosed patch to
the development tree, removing the bad code.

I'll do a quick test before pushing it upstream.

Regards,
Mauro

-


[media] xc5000: Remove the global mutex lock at xc5000 firmware init

As reported by Devin Heitmueller <dheitmueller@kernellabs.com>:

> It seems like a change such as this could significantly change the
> timing of tuner initialization if you have multiple xc5000 based
> products that might have a slow i2c bus.  Was that intentional?

After discussed with Eddi de Pierri <eddi@depieri.net>, it was pointed that
the change was not intentional, and it was just a trial while developing
the patches that add support for HVR-930C.

So, remove this hack.

Reported-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Acked by: Eddi de Pierri <eddi@depieri.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 048f489..ecd1f95 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -1004,8 +1004,6 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
  	struct xc5000_priv *priv = fe->tuner_priv;
  	int ret = 0;
  
-	mutex_lock(&xc5000_list_mutex);
-
  	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
  		ret = xc5000_fwupload(fe);
  		if (ret != XC_RESULT_SUCCESS)
@@ -1025,8 +1023,6 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
  	/* Default to "CABLE" mode */
  	ret |= xc_write_reg(priv, XREG_SIGNALSOURCE, XC_RF_MODE_CABLE);
  
-	mutex_unlock(&xc5000_list_mutex);
-
  	return ret;
  }
  



>
> Thanks,
>
> Devin
>

