Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab1I3SHX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 14:07:23 -0400
Message-ID: <4E85F769.3040201@redhat.com>
Date: Fri, 30 Sep 2011 14:07:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Lutz Sammer <johns98@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] stb0899: Fix slow and not locking DVB-S transponder(s)
References: <4E84E010.5020602@gmx.net> <4E84E1A5.3040903@gmx.net>
In-Reply-To: <4E84E1A5.3040903@gmx.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 29-09-2011 18:22, Lutz Sammer escreveu:
> Another version of
> http://patchwork.linuxtv.org/patch/6307
> http://patchwork.linuxtv.org/patch/6510
> which was superseded or rejected, but I don't know why.

Probably because of the same reason of this patch [1]:

patch -p1 -i patches/lmml_8023_v2_stb0899_fix_slow_and_not_locking_dvb_s_transponder_s.patch --dry-run -t -N
patching file drivers/media/dvb/frontends/stb0899_algo.c
Hunk #1 FAILED at 358.
1 out of 1 hunk FAILED -- saving rejects to file drivers/media/dvb/frontends/stb0899_algo.c.rej
 drivers/media/dvb/frontends/stb0899_algo.c |    1 +
 1 file changed, 1 insertion(+)

I'll mark this one as rejected, as it doesn't apply upstream[2].

[1] http://patchwork.linuxtv.org/patch/8023/
[2] at tree/branch: git://linuxtv.org/media_tree.git staging/for_v3.2

Please test if the changes made upstream to solve a similar trouble fixes your issue. 
If not, please rebase your patch on the top of it and resend.

Thanks,
Mauro
> 
> In stb0899_status stb0899_check_data the first read of STB0899_VSTATUS
> could read old (from previous search) status bits and the search fails
> on a good frequency.
> 
> With the patch more transponder could be locked and locks about 2* faster.
> 
> Signed-off-by: Lutz Sammer <johns98@gmx.net>
> ---
>  drivers/media/dvb/frontends/stb0899_algo.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb/frontends/stb0899_algo.c
> index d70eee0..8eca419 100644
> --- a/drivers/media/dvb/frontends/stb0899_algo.c
> +++ b/drivers/media/dvb/frontends/stb0899_algo.c
> @@ -358,6 +358,7 @@ static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
>         else
>                 dataTime = 500;
>  
> +       stb0899_read_reg(state, STB0899_VSTATUS); /* clear old status bits */
>         stb0899_write_reg(state, STB0899_DSTATUS2, 0x00); /* force search loop */
>         while (1) {
>                 /* WARNING! VIT LOCKED has to be tested before VIT_END_LOOOP   */

