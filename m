Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52420 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab1KUM7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 07:59:12 -0500
Received: by wwe5 with SMTP id 5so10437438wwe.1
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 04:59:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E1RSTA6-00086e-3F@www.linuxtv.org>
References: <E1RSTA6-00086e-3F@www.linuxtv.org>
Date: Mon, 21 Nov 2011 18:29:09 +0530
Message-ID: <CAHFNz9+p5Xz++6J-S2EJX9P2z96+HywZB3O9TqzHJLruWek4aQ@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v3.3] [media] dvb: Allow select between DVB-C
 Annex A and Annex C
From: Manu Abraham <abraham.manu@gmail.com>
To: linux-media@vger.kernel.org
Cc: linuxtv-commits@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,


On Fri, Nov 11, 2011 at 8:16 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
>
> Subject: [media] dvb: Allow select between DVB-C Annex A and Annex C
> Author:  Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:    Fri Nov 11 12:46:23 2011 -0200
>
> DVB-C, as defined by ITU-T J.83 has 3 annexes. The differences between
> Annex A and Annex C is that Annex C uses a subset of the modulation
> types, and uses a different rolloff factor. A different rolloff means
> that the bandwidth required is slicely different, and may affect the
> saw filter configuration at the tuners. Also, some demods have different
> configurations, depending on using Annex A or Annex C.
>
> So, allow userspace to specify it, by changing the rolloff factor.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
>  Documentation/DocBook/media/dvb/dvbproperty.xml |    4 ++++
>  drivers/media/dvb/dvb-core/dvb_frontend.c       |    2 ++
>  include/linux/dvb/frontend.h                    |    2 ++
>  3 files changed, 8 insertions(+), 0 deletions(-)
>
> ---
>
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=39ce61a846c8e1fa00cb57ad5af021542e6e8403
>
> diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
> index 3bc8a61..6ac8039 100644
> --- a/Documentation/DocBook/media/dvb/dvbproperty.xml
> +++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
> @@ -311,6 +311,8 @@ typedef enum fe_rolloff {
>        ROLLOFF_20,
>        ROLLOFF_25,
>        ROLLOFF_AUTO,
> +       ROLLOFF_15, /* DVB-C Annex A */
> +       ROLLOFF_13, /* DVB-C Annex C */
>  } fe_rolloff_t;
>                </programlisting>
>                </section>
> @@ -778,8 +780,10 @@ typedef enum fe_hierarchy {
>                        <listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
>                        <listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
>                        <listitem><para><link linkend="DTV-SYMBOL-RATE"><constant>DTV_SYMBOL_RATE</constant></link></para></listitem>
> +                       <listitem><para><link linkend="DTV-ROLLOFF"><constant>DTV_ROLLOFF</constant></link></para></listitem>
>                        <listitem><para><link linkend="DTV-INNER-FEC"><constant>DTV_INNER_FEC</constant></link></para></listitem>
>                </itemizedlist>
> +               <para>The Rolloff of 0.15 (ROLLOFF_15) is assumed, as ITU-T J.83 Annex A is more common. For Annex C, rolloff should be 0.13 (ROLLOFF_13). All other values are invalid.</para>
>        </section>
>        <section id="dvbc-annex-b-params">
>                <title>DVB-C Annex B delivery system</title>
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 2c0acdb..c849455 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -876,6 +876,7 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
>        c->symbol_rate = QAM_AUTO;
>        c->code_rate_HP = FEC_AUTO;
>        c->code_rate_LP = FEC_AUTO;
> +       c->rolloff = ROLLOFF_AUTO;
>
>        c->isdbt_partial_reception = -1;
>        c->isdbt_sb_mode = -1;
> @@ -1030,6 +1031,7 @@ static void dtv_property_cache_init(struct dvb_frontend *fe,
>                break;
>        case FE_QAM:
>                c->delivery_system = SYS_DVBC_ANNEX_AC;
> +               c->rolloff = ROLLOFF_15; /* implied for Annex A */
>                break;
>        case FE_OFDM:
>                c->delivery_system = SYS_DVBT;
> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
> index 1b1094c..d9251df 100644
> --- a/include/linux/dvb/frontend.h
> +++ b/include/linux/dvb/frontend.h
> @@ -329,6 +329,8 @@ typedef enum fe_rolloff {
>        ROLLOFF_20,
>        ROLLOFF_25,
>        ROLLOFF_AUTO,
> +       ROLLOFF_15,     /* DVB-C Annex A */
> +       ROLLOFF_13,     /* DVB-C Annex C */
>  } fe_rolloff_t;
>
>  typedef enum fe_delivery_system {



Please don't do this.

Why ?

 - It is an API bug: DVBC_ANNEX_AC should not have existed.
 - We should handle systems by their delivery systems and each
delivery system should be unique.
 - We wouldn't want the user to know more details, such as rolloff,
the user would know whether they are in the Europe, US or Japan, which
would imply ANNEX_A, ANNEX_B, ANNEX_C respectively.

Ok, that said there exists the issue and you found some way to
workaround the issue. But it doesn't look nice.

- I would instead like to have the API bug fix instead, as Andreas
suggested in another thread.

 in frontend.h

#define DVBC_ANNEX_AC      DVBC_ANNEX_A

and in enum fe_delivery system_t

replace DVBC_ANNEX_AC with DVBC_ANNEX_A

add in DVBC_ANNEX_B and DVBC_ANNEX_C


What would this gain ?

- A unique delivery system descriptor (This is what I am trying to
address in the query fe delivery system capabilities. If you have a
device that supports both DVBC_ANNEX_A and C as in the current case
with DRXK, the same old problems resurface again)

- Simplicity to users, they don't have to know what rolloff it is, but
just their geographical location

- Fixing of a bug in the API, rather than a workaround.

I would appreciate, if you would revert this patch and amend it such
that it reflects to fix the bug, rather than to work around it.

Regards,
Manu
