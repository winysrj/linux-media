Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:47571 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932337Ab1I3Slu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 14:41:50 -0400
Message-ID: <4E860D76.5040605@gmx.net>
Date: Fri, 30 Sep 2011 20:41:58 +0200
From: Lutz Sammer <johns98@gmx.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] stb0899: Fix slow and not locking DVB-S transponder(s)
References: <4E84E010.5020602@gmx.net> <4E84E1A5.3040903@gmx.net> <4E85F769.3040201@redhat.com>
In-Reply-To: <4E85F769.3040201@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------060107010805000907030003"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060107010805000907030003
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/30/11 19:07, Mauro Carvalho Chehab wrote:
> Em 29-09-2011 18:22, Lutz Sammer escreveu:
>> Another version of
>> http://patchwork.linuxtv.org/patch/6307
>> http://patchwork.linuxtv.org/patch/6510
>> which was superseded or rejected, but I don't know why.
> 
> Probably because of the same reason of this patch [1]:
> 
> patch -p1 -i patches/lmml_8023_v2_stb0899_fix_slow_and_not_locking_dvb_s_transponder_s.patch --dry-run -t -N
> patching file drivers/media/dvb/frontends/stb0899_algo.c
> Hunk #1 FAILED at 358.
> 1 out of 1 hunk FAILED -- saving rejects to file drivers/media/dvb/frontends/stb0899_algo.c.rej
>   drivers/media/dvb/frontends/stb0899_algo.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> I'll mark this one as rejected, as it doesn't apply upstream[2].
> 
> [1] http://patchwork.linuxtv.org/patch/8023/
> [2] at tree/branch: git://linuxtv.org/media_tree.git staging/for_v3.2
> 
> Please test if the changes made upstream to solve a similar trouble fixes your issue.
> If not, please rebase your patch on the top of it and resend.
> 
> Thanks,
> Mauro
>>
>> In stb0899_status stb0899_check_data the first read of STB0899_VSTATUS
>> could read old (from previous search) status bits and the search fails
>> on a good frequency.
>>
>> With the patch more transponder could be locked and locks about 2* faster.
>>
>> Signed-off-by: Lutz Sammer<johns98@gmx.net>
>> ---
>>   drivers/media/dvb/frontends/stb0899_algo.c |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb/frontends/stb0899_algo.c
>> index d70eee0..8eca419 100644
>> --- a/drivers/media/dvb/frontends/stb0899_algo.c
>> +++ b/drivers/media/dvb/frontends/stb0899_algo.c
>> @@ -358,6 +358,7 @@ static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
>>          else
>>                  dataTime = 500;
>>
>> +       stb0899_read_reg(state, STB0899_VSTATUS); /* clear old status bits */
>>          stb0899_write_reg(state, STB0899_DSTATUS2, 0x00); /* force search loop */
>>          while (1) {
>>                  /* WARNING! VIT LOCKED has to be tested before VIT_END_LOOOP   */
> 
> 

Sorry this fucking thunderbird eats the patches. I have followed the README.patches and
installed thunderbird plugin.

Johns




--------------060107010805000907030003
Content-Type: text/plain;
 name="0001-stb0899-Fix-slow-and-not-locking-DVB-S-transponder-s.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-stb0899-Fix-slow-and-not-locking-DVB-S-transponder-s.pa";
 filename*1="tch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9zdGIwODk5X2FsZ28u
YyBiL2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9zdGIwODk5X2FsZ28uYwppbmRleCBk
NzBlZWUwLi44ZWNhNDE5IDEwMDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVu
ZHMvc3RiMDg5OV9hbGdvLmMKKysrIGIvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL3N0
YjA4OTlfYWxnby5jCkBAIC0zNTgsNiArMzU4LDcgQEAgc3RhdGljIGVudW0gc3RiMDg5OV9z
dGF0dXMgc3RiMDg5OV9jaGVja19kYXRhKHN0cnVjdCBzdGIwODk5X3N0YXRlICpzdGF0ZSkK
IAllbHNlCiAJCWRhdGFUaW1lID0gNTAwOwogCisJc3RiMDg5OV9yZWFkX3JlZyhzdGF0ZSwg
U1RCMDg5OV9WU1RBVFVTKTsgLyogY2xlYXIgb2xkIHN0YXR1cyBiaXRzICovCiAJc3RiMDg5
OV93cml0ZV9yZWcoc3RhdGUsIFNUQjA4OTlfRFNUQVRVUzIsIDB4MDApOyAvKiBmb3JjZSBz
ZWFyY2ggbG9vcAkqLwogCXdoaWxlICgxKSB7CiAJCS8qIFdBUk5JTkchIFZJVCBMT0NLRUQg
aGFzIHRvIGJlIHRlc3RlZCBiZWZvcmUgVklUX0VORF9MT09PUAkqLwo=
--------------060107010805000907030003--
