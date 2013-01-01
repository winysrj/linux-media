Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34891 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab3AAQnw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 11:43:52 -0500
Message-ID: <50E31220.5060405@iki.fi>
Date: Tue, 01 Jan 2013 18:43:12 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH] [media] dvb: frontend API: Add a flag to indicate
 that get_frontend() can be called
References: <1356738146-9352-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1356738146-9352-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/29/2012 01:42 AM, Mauro Carvalho Chehab wrote:
> get_frontend() can't be called too early, as the device may not have it
> yet. Yet, get_frontend() on OFDM standards can happen before FE_HAS_LOCK,
> as the TMCC carriers (ISDB-T) or the TPS carriers (DVB-T) require a very
> low signal to noise relation to be detected. The other carriers use
> different modulations, so they require a higher SNR.

I would like to questionable need of whole flag. Is there really need to 
separate FE_HAS_PARAMETERS from FE_HAS_LOCK as we are not still making 
the professional DTV analyzing equipment?

And on the other-hand, I don't see any change for DVB-core which syncs 
cache when FE_HAS_PARAMETERS is set. What I remember current behavior of 
DVB-core is to call get_frontend() after FE_HAS_LOCK is set and as that 
patch does not change it => there is likely implementation bug too.

regards
Antti


>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>   Documentation/DocBook/media/dvb/frontend.xml | 13 ++++++++++++-
>   drivers/media/dvb-frontends/mb86a20s.c       | 17 ++++++++++-------
>   include/uapi/linux/dvb/frontend.h            |  4 ++++
>   3 files changed, 26 insertions(+), 8 deletions(-)
>
> v3: rebase it to apply with current tip and add an implementation example.
>
> Obsoletes: http://patchwork.linuxtv.org/patch/13783/
>
> diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
> index 426c252..5feff4e 100644
> --- a/Documentation/DocBook/media/dvb/frontend.xml
> +++ b/Documentation/DocBook/media/dvb/frontend.xml
> @@ -216,6 +216,7 @@ typedef enum fe_status {
>   	FE_HAS_LOCK		= 0x10,
>   	FE_TIMEDOUT		= 0x20,
>   	FE_REINIT		= 0x40,
> +	FE_HAS_PARAMETERS	= 0x80,
>   } fe_status_t;
>   </programlisting>
>   <para>to indicate the current state and/or state changes of the frontend hardware:
> @@ -244,7 +245,17 @@ typedef enum fe_status {
>   <entry align="char">FE_REINIT</entry>
>   <entry align="char">The frontend was reinitialized, application is
>   recommended to reset DiSEqC, tone and parameters</entry>
> -</row>
> +</row><row>
> +<entry align="char">FE_HAS_PARAMETERS</entry>
> +<entry align="char"><link linkend="FE_GET_SET_PROPERTY">
> +<constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></link> or
> +<link linkend="FE_GET_FRONTEND"><constant>FE_GET_FRONTEND</constant></link> can now be
> +called to provide the detected network parameters.
> +This should be risen for example when the DVB-T TPS/ISDB-T TMCC is locked.
> +This status can be risen before FE_HAS_SYNC, as the SNR required for
> +parameters detection is lower than the requirement for the other
> +carriers on the OFDM delivery systems.
> +</entry></row>
>   </tbody></tgroup></informaltable>
>
>   </section>
> diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
> index fade566..35153b6 100644
> --- a/drivers/media/dvb-frontends/mb86a20s.c
> +++ b/drivers/media/dvb-frontends/mb86a20s.c
> @@ -333,19 +333,22 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
>   		fe->ops.i2c_gate_ctrl(fe, 1);
>
>   	if (val >= 2)
> -		*status |= FE_HAS_SIGNAL;
> +		*status |= FE_HAS_SIGNAL;	/* Tuner locked */
>
>   	if (val >= 4)
> -		*status |= FE_HAS_CARRIER;
> +		*status |= FE_HAS_CARRIER;	/* Mode reliably detected */
>
> -	if (val >= 5)
> -		*status |= FE_HAS_VITERBI;
> +	if (val >= 6)
> +		*status |= FE_HAS_VITERBI;	/* PLL locked and broadband detected */
>
>   	if (val >= 7)
> -		*status |= FE_HAS_SYNC;
> +		*status |= FE_HAS_SYNC;		/* Frame sync */
>
> -	if (val >= 8)				/* Maybe 9? */
> -		*status |= FE_HAS_LOCK;
> +	if (val >= 8)
> +		*status |= FE_HAS_PARAMETERS;	/* TMCC locked */
> +
> +	if (val >= 9)
> +		*status |= FE_HAS_LOCK;		/* TS output started */
>
>   	dprintk("val = %d, status = 0x%02x\n", val, *status);
>
> diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
> index c12d452..e4daeee 100644
> --- a/include/uapi/linux/dvb/frontend.h
> +++ b/include/uapi/linux/dvb/frontend.h
> @@ -132,6 +132,9 @@ typedef enum fe_sec_mini_cmd {
>    * @FE_TIMEDOUT:	no lock within the last ~2 seconds
>    * @FE_REINIT:		frontend was reinitialized, application is recommended
>    *			to reset DiSEqC, tone and parameters
> + * @FE_HAS_PARAMETERS:	get_frontend() can now be called to provide the
> + *			detected network parameters. This should be risen
> + *			for example when the DVB-T TPS/ISDB-T TMCC is locked.
>    */
>
>   typedef enum fe_status {
> @@ -142,6 +145,7 @@ typedef enum fe_status {
>   	FE_HAS_LOCK		= 0x10,
>   	FE_TIMEDOUT		= 0x20,
>   	FE_REINIT		= 0x40,
> +	FE_HAS_PARAMETERS	= 0x80,
>   } fe_status_t;
>
>   typedef enum fe_spectral_inversion {
>


-- 
http://palosaari.fi/
