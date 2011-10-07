Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:36830 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754317Ab1JGUL7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2011 16:11:59 -0400
Message-ID: <4E8F5CF9.1080506@gmx.net>
Date: Fri, 07 Oct 2011 22:11:37 +0200
From: Lutz Sammer <johns98@gmx.net>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3] stb0899: Fix slow and not locking DVB-S transponder(s)
References: <4E84E010.5020602@gmx.net> <4E84E1A5.3040903@gmx.net> <4E85F769.3040201@redhat.com> <4E860D76.5040605@gmx.net> <4E861163.3000903@redhat.com> <CAHFNz9LGTnGsafhXDJuGDw=VEaOJuoFL+_DoV0vM9-_RuANtPg@mail.gmail.com> <4E8F3071.3010802@gmx.net> <CAHFNz9LbDHTgpH0HYJS3TOSdiFBeG_N2X_iO6mRarC5gnTry1Q@mail.gmail.com>
In-Reply-To: <CAHFNz9LbDHTgpH0HYJS3TOSdiFBeG_N2X_iO6mRarC5gnTry1Q@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090207010006030501080202"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090207010006030501080202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/07/11 20:20, Manu Abraham wrote:
> On Fri, Oct 7, 2011 at 10:31 PM, Lutz Sammer<johns98@gmx.net>  wrote:
>> On 10/06/11 20:56, Manu Abraham wrote:
>>>
>>> Mauro,
>>>
>>> comments in-line.
>>>
>>> On Sat, Oct 1, 2011 at 12:28 AM, Mauro Carvalho Chehab
>>> <mchehab@redhat.com>    wrote:
>>>>
>>>> Em 30-09-2011 15:41, Lutz Sammer escreveu:
>>>>>
>>>>> On 09/30/11 19:07, Mauro Carvalho Chehab wrote:
>>>>>>
>>>>>> Em 29-09-2011 18:22, Lutz Sammer escreveu:
>>>>>>>
>>>>>>> Another version of
>>>>>>> http://patchwork.linuxtv.org/patch/6307
>>>>>>> http://patchwork.linuxtv.org/patch/6510
>>>>>>> which was superseded or rejected, but I don't know why.
>>>>>>
>>>>>> Probably because of the same reason of this patch [1]:
>>>>>>
>>>>>> patch -p1 -i
>>>>>> patches/lmml_8023_v2_stb0899_fix_slow_and_not_locking_dvb_s_transponder_s.patch
>>>>>> --dry-run -t -N
>>>>>> patching file drivers/media/dvb/frontends/stb0899_algo.c
>>>>>> Hunk #1 FAILED at 358.
>>>>>> 1 out of 1 hunk FAILED -- saving rejects to file
>>>>>> drivers/media/dvb/frontends/stb0899_algo.c.rej
>>>>>>    drivers/media/dvb/frontends/stb0899_algo.c |    1 +
>>>>>>    1 file changed, 1 insertion(+)
>>>>>>
>>>>>> I'll mark this one as rejected, as it doesn't apply upstream[2].
>>>>>>
>>>>>> [1] http://patchwork.linuxtv.org/patch/8023/
>>>>>> [2] at tree/branch: git://linuxtv.org/media_tree.git staging/for_v3.2
>>>>>>
>>>>>> Please test if the changes made upstream to solve a similar trouble
>>>>>> fixes your issue.
>>>>>> If not, please rebase your patch on the top of it and resend.
>>>>>>
>>>>>> Thanks,
>>>>>> Mauro
>>>>>>>
>>>>>>> In stb0899_status stb0899_check_data the first read of STB0899_VSTATUS
>>>>>>> could read old (from previous search) status bits and the search fails
>>>>>>> on a good frequency.
>>>>>>>
>>>>>>> With the patch more transponder could be locked and locks about 2*
>>>>>>> faster.
>>>>
>>>> Manu,
>>>>
>>>> Could you please review this one-line patch?
>>>>
>>>>
>>>>>>>
>>>>>>> Signed-off-by: Lutz Sammer<johns98@gmx.net>
>>>>>>> ---
>>>>>>>    drivers/media/dvb/frontends/stb0899_algo.c |    1 +
>>>>>>>    1 files changed, 1 insertions(+), 0 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/media/dvb/frontends/stb0899_algo.c
>>>>>>> b/drivers/media/dvb/frontends/stb0899_algo.c
>>>>>>> index d70eee0..8eca419 100644
>>>>>>> --- a/drivers/media/dvb/frontends/stb0899_algo.c
>>>>>>> +++ b/drivers/media/dvb/frontends/stb0899_algo.c
>>>>>>> @@ -358,6 +358,7 @@ static enum stb0899_status
>>>>>>> stb0899_check_data(struct stb0899_state *state)
>>>>>>>           else
>>>>>>>                   dataTime = 500;
>>>>>>>
>>>>>>> +       stb0899_read_reg(state, STB0899_VSTATUS); /* clear old status
>>>>>>> bits */
>>>>>>>           stb0899_write_reg(state, STB0899_DSTATUS2, 0x00); /* force
>>>>>>> search loop */
>>>>>>>           while (1) {
>>>>>>>                   /* WARNING! VIT LOCKED has to be tested before
>>>>>>> VIT_END_LOOOP   */
>>>>
>>>
>>> Please add in these comments, in case you want to apply the change. I
>>> am neither for the patch, nor against it.
>>>
>>> - In fact, it doesn't hurt to read STATUS just before LOCK test.
>>> - I wasn't able to find any noticeable difference in LOCK acquisition.
>>> - Nowhere, I was able to find that reading VSTATUS, clears the
>>> Read-Only bits set by the onchip microcontroller. The above comment
>>> could be wrong at least, as far as I can say.
>>>
>>> But that said, if the change does really help (thinking of strange
>>> issues with some Silicon cuts)
>>>
>>> Acked-by: Manu Abraham<manu@linuxtv.org>
>>>
>>> Regards,
>>> Manu
>>>
>>
>> To be exact only the loop bit is reset by the read:
>>
>> kernel: [62791.427869] stb0899: vstatus 40 00 40 00
>> kernel: [62791.597609] stb0899: vstatus 00 00 18 18
>>
>> Printed twice before and after the loop. I tested this with the
>> tt-3600 and tt-3650.
>
> Ok, reading VSTATUS might force the VIT_END_LOOP to be refreshed
> (cached copy) in some cases where it probably never cleared due to
> some internal error. In fact, actually it should be automatically be
> cleared, surprised that it didn't.
>
> Can you please adjust the comment to state: Clear previous failed END_LOOPVIT ?
>
> Mauro,
>
> The following patch can be applied, with a modified comment similar to
> the above.
> Reviewed-by: Manu Abraham<manu@linuxtv.org>
>
> Thanks,
> Manu
>

In stb0899_status stb0899_check_data the first read of STB0899_VSTATUS
could read old (from previous search) LOOP status bit and the search
fails on a good frequency.

With the patch more transponder could be locked and locks about 2*
faster.

Signed-off-by: Lutz Sammer<johns98@gmx.net>


--------------090207010006030501080202
Content-Type: text/plain;
 name="stb0899-Fix-slow-and-not-locking-DVB-S-transponders.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="stb0899-Fix-slow-and-not-locking-DVB-S-transponders.patch"

diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb/frontends/stb0899_algo.c
index d70eee0..117a569 100644
--- a/drivers/media/dvb/frontends/stb0899_algo.c
+++ b/drivers/media/dvb/frontends/stb0899_algo.c
@@ -358,6 +358,9 @@ static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
 	else
 		dataTime = 500;
 
+	/* clear previous failed END_LOOPVIT */
+	stb0899_read_reg(state, STB0899_VSTATUS);
+
 	stb0899_write_reg(state, STB0899_DSTATUS2, 0x00); /* force search loop	*/
 	while (1) {
 		/* WARNING! VIT LOCKED has to be tested before VIT_END_LOOOP	*/

--------------090207010006030501080202--
