Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62444 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab1JFS4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 14:56:08 -0400
Received: by wyg34 with SMTP id 34so3153779wyg.19
        for <linux-media@vger.kernel.org>; Thu, 06 Oct 2011 11:56:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E861163.3000903@redhat.com>
References: <4E84E010.5020602@gmx.net>
	<4E84E1A5.3040903@gmx.net>
	<4E85F769.3040201@redhat.com>
	<4E860D76.5040605@gmx.net>
	<4E861163.3000903@redhat.com>
Date: Fri, 7 Oct 2011 00:26:07 +0530
Message-ID: <CAHFNz9LGTnGsafhXDJuGDw=VEaOJuoFL+_DoV0vM9-_RuANtPg@mail.gmail.com>
Subject: Re: [PATCH v2] stb0899: Fix slow and not locking DVB-S transponder(s)
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Lutz Sammer <johns98@gmx.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

comments in-line.

On Sat, Oct 1, 2011 at 12:28 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 30-09-2011 15:41, Lutz Sammer escreveu:
>> On 09/30/11 19:07, Mauro Carvalho Chehab wrote:
>>> Em 29-09-2011 18:22, Lutz Sammer escreveu:
>>>> Another version of
>>>> http://patchwork.linuxtv.org/patch/6307
>>>> http://patchwork.linuxtv.org/patch/6510
>>>> which was superseded or rejected, but I don't know why.
>>>
>>> Probably because of the same reason of this patch [1]:
>>>
>>> patch -p1 -i patches/lmml_8023_v2_stb0899_fix_slow_and_not_locking_dvb_s_transponder_s.patch --dry-run -t -N
>>> patching file drivers/media/dvb/frontends/stb0899_algo.c
>>> Hunk #1 FAILED at 358.
>>> 1 out of 1 hunk FAILED -- saving rejects to file drivers/media/dvb/frontends/stb0899_algo.c.rej
>>>   drivers/media/dvb/frontends/stb0899_algo.c |    1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> I'll mark this one as rejected, as it doesn't apply upstream[2].
>>>
>>> [1] http://patchwork.linuxtv.org/patch/8023/
>>> [2] at tree/branch: git://linuxtv.org/media_tree.git staging/for_v3.2
>>>
>>> Please test if the changes made upstream to solve a similar trouble fixes your issue.
>>> If not, please rebase your patch on the top of it and resend.
>>>
>>> Thanks,
>>> Mauro
>>>>
>>>> In stb0899_status stb0899_check_data the first read of STB0899_VSTATUS
>>>> could read old (from previous search) status bits and the search fails
>>>> on a good frequency.
>>>>
>>>> With the patch more transponder could be locked and locks about 2* faster.
>
> Manu,
>
> Could you please review this one-line patch?
>
>
>>>>
>>>> Signed-off-by: Lutz Sammer<johns98@gmx.net>
>>>> ---
>>>>   drivers/media/dvb/frontends/stb0899_algo.c |    1 +
>>>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb/frontends/stb0899_algo.c
>>>> index d70eee0..8eca419 100644
>>>> --- a/drivers/media/dvb/frontends/stb0899_algo.c
>>>> +++ b/drivers/media/dvb/frontends/stb0899_algo.c
>>>> @@ -358,6 +358,7 @@ static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
>>>>          else
>>>>                  dataTime = 500;
>>>>
>>>> +       stb0899_read_reg(state, STB0899_VSTATUS); /* clear old status bits */
>>>>          stb0899_write_reg(state, STB0899_DSTATUS2, 0x00); /* force search loop */
>>>>          while (1) {
>>>>                  /* WARNING! VIT LOCKED has to be tested before VIT_END_LOOOP   */
>

Please add in these comments, in case you want to apply the change. I
am neither for the patch, nor against it.

- In fact, it doesn't hurt to read STATUS just before LOCK test.
- I wasn't able to find any noticeable difference in LOCK acquisition.
- Nowhere, I was able to find that reading VSTATUS, clears the
Read-Only bits set by the onchip microcontroller. The above comment
could be wrong at least, as far as I can say.

But that said, if the change does really help (thinking of strange
issues with some Silicon cuts)

Acked-by: Manu Abraham <manu@linuxtv.org>

Regards,
Manu
