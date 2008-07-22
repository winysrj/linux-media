Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6M4q12u006821
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 00:52:01 -0400
Received: from smtp-vbr11.xs4all.nl (smtp-vbr11.xs4all.nl [194.109.24.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6M4pojs023039
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 00:51:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: roel kluin <roel.kluin@gmail.com>
Date: Tue, 22 Jul 2008 06:50:43 +0200
References: <488529D4.10007@gmail.com>
In-Reply-To: <488529D4.10007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807220650.43684.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
Subject: Re: [PATCH 3/9] ivtv: test below 0 on unsigned has_ir
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

On Tuesday 22 July 2008 02:29:08 roel kluin wrote:
> u32 has_ir, member of struct tveeprom is unsigned,
> so assignment of -1 and subsequent tests fail

Thank you for this report, but I'm going to NAK this patch. I will take 
a closer look at this tonight and I will make a new patch for this. 
First to take care of the FIXME that's just before the first change 
below and secondly I'll see if it isn't better to change has_ir to an 
int: I don't like using ~0 like this.

So expect to see a new patch later today.

Regards,

	Hans

>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>
> diff --git a/drivers/media/video/ivtv/ivtv-driver.c
> b/drivers/media/video/ivtv/ivtv-driver.c index 797e636..7d909f9
> 100644
> --- a/drivers/media/video/ivtv/ivtv-driver.c
> +++ b/drivers/media/video/ivtv/ivtv-driver.c
> @@ -465,7 +465,7 @@ static void ivtv_process_eeprom(struct ivtv *itv)
>  		itv->options.radio = (tv.has_radio != 0);
>  	/* only enable newi2c if an IR blaster is present */
>  	/* FIXME: for 2.6.20 the test against 2 should be removed */
> -	if (itv->options.newi2c == -1 && tv.has_ir != -1 && tv.has_ir != 2)
> { +	if (itv->options.newi2c == -1 && tv.has_ir != ~0 && tv.has_ir !=
> 2) { itv->options.newi2c = (tv.has_ir & 2) ? 1 : 0;
>  		if (itv->options.newi2c) {
>  		    IVTV_INFO("Reopen i2c bus for IR-blaster support\n");
> diff --git a/drivers/media/video/tveeprom.c
> b/drivers/media/video/tveeprom.c index 9da0e18..41c22a7 100644
> --- a/drivers/media/video/tveeprom.c
> +++ b/drivers/media/video/tveeprom.c
> @@ -483,7 +483,7 @@ void tveeprom_hauppauge_analog(struct i2c_client
> *c, struct tveeprom *tvee, tvee->has_radio = eeprom_data[i+len-1];
>  			/* old style tag, don't know how to detect
>  			IR presence, mark as unknown. */
> -			tvee->has_ir = -1;
> +			tvee->has_ir = ~0;
>  			tvee->model =
>  				eeprom_data[i+8] +
>  				(eeprom_data[i+9] << 8);
> @@ -703,7 +703,7 @@ void tveeprom_hauppauge_analog(struct i2c_client
> *c, struct tveeprom *tvee, tveeprom_info("decoder processor is %s
> (idx %d)\n",
>  			STRM(decoderIC, tvee->decoder_processor),
>  			tvee->decoder_processor);
> -	if (tvee->has_ir == -1)
> +	if (tvee->has_ir == ~0)
>  		tveeprom_info("has %sradio\n",
>  				tvee->has_radio ? "" : "no ");
>  	else


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
