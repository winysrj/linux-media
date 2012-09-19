Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab2ISQ2y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 12:28:54 -0400
Message-ID: <5059F2C1.7050302@redhat.com>
Date: Wed, 19 Sep 2012 13:28:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Mygica X8507 audio for YPbPr, AV and S-Video
References: <50450FB5.3090503@netscape.net> <50589E52.5050602@redhat.com> <5059C949.6010808@netscape.net>
In-Reply-To: <5059C949.6010808@netscape.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-09-2012 10:31, Alfredo Jesús Delaiti escreveu:
> El 18/09/12 13:16, Mauro Carvalho Chehab escribió:
>> Em 03-09-2012 17:14, Alfredo Jesús Delaiti escreveu:
>>> Hi
>>>
>>> This patch add audio support for input YPbPr, AV and S-Video for Mygica X8507 card.
>>> I tried it with the 3.4 and 3.5 kernel
>>>
>>> Remains to be done: IR, FM and ISDBT
>>>
>>> Sorry if I sent the patch improperly.
>>>
>>> Signed-off-by: Alfredo J. Delaiti <alfredodelaiti@netscape.net>
>>>
>>>
>>>
>>> diff --git a/media/video/cx23885/cx23885-cards.c b/media/video/cx23885/cx23885-cards.c
>>> index 080e111..17e2576 100644
>>> --- a/media/video/cx23885/cx23885-cards.c
>>> +++ b/media/video/cx23885/cx23885-cards.c
>> Wrong format... the "drivers/" is missing.
>>
>> Well, the location also changed to drivers/media/pci, but my scripts can
>> fix it.
>>
>>> @@ -541,11 +541,13 @@ struct cx23885_board cx23885_boards[] = {
>>>                          {
>>>                                  .type   = CX23885_VMUX_COMPOSITE1,
>>>                                  .vmux   = CX25840_COMPOSITE8,
>>> +                               .amux   = CX25840_AUDIO7,
>> Didn't apply well. It seems it conflicted with some other patch.
>>
>> Please, re-generate it against the very latest tree.
>>
>> Also, when doing diffs for the boards entries, it is wise to have
>> more context lines, in order that a patch made for one driver would
>> be badly applied at some other board entry.
>>
>> The easiest way to do that is to do:
>>
>>     $ git diff -U10
>>         or
>>     $ git show -U10
>>         (if you've merged the patch at your local copy)
>>
>> (if you're generating the patch against the main media-tree.git)
>>
>> Where "10" is just an arbitrary large number that will allow to
>> see the board name that will be modified, like:
>>
>> --- a/drivers/media/pci/cx23885/cx23885-cards.c
>> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
>> @@ -531,20 +531,21 @@ struct cx23885_board cx23885_boards[] = {
>>                  .name           = "Mygica X8507",
>>                  .tuner_type = TUNER_XC5000,
>>                  .tuner_addr = 0x61,
>>                  .tuner_bus      = 1,
>>                  .porta          = CX23885_ANALOG_VIDEO,
>>                  .input          = {
>>                          {
>>                                  .type   = CX23885_VMUX_TELEVISION,
>>                                  .vmux   = CX25840_COMPOSITE2,
>>                                  .amux   = CX25840_AUDIO8,
>> + /* Some foo addition - just for testing */
>>                          },
>>                          {
>>                                  .type   = CX23885_VMUX_COMPOSITE1,
>>                                  .vmux   = CX25840_COMPOSITE8,
>>                          },
>>                          {
>>                                  .type   = CX23885_VMUX_SVIDEO,
>>                                  .vmux   = CX25840_SVIDEO_LUMA3 |
>>                                                  CX25840_SVIDEO_CHROMA4,
>>                          },
>>
>>
>> Thanks,
>> Mauro
> Hi
> 
> Thanks for the advice.
> 
> I resubmit the patch with the advice given.
> I apologize, but git and diff, still " aren't my friends"
> 
> Thanks
> 
> 
> Signed-off-by: Alfredo J. Delaiti <alfredodelaiti@netscape.net>
> 
> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
> index d889bd2..cb5f847 100644
> --- a/drivers/media/pci/cx23885/cx23885-cards.c
> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
> @@ -530,42 +530,45 @@ struct cx23885_board cx23885_boards[] = {
>         [CX23885_BOARD_MYGICA_X8507] = {
>                 .name           = "Mygica X8507",
>                 .tuner_type = TUNER_XC5000,
>                 .tuner_addr = 0x61,
>                 .tuner_bus      = 1,
>                 .porta          = CX23885_ANALOG_VIDEO,
>                 .input          = {
>                         {
>                                 .type   = CX23885_VMUX_TELEVISION,
>                                 .vmux   = CX25840_COMPOSITE2,
>                                 .amux   = CX25840_AUDIO8,
>                         },
>                         {
>                                 .type   = CX23885_VMUX_COMPOSITE1,
>                                 .vmux   = CX25840_COMPOSITE8,
> +                               .amux   = CX25840_AUDIO7,
>                         },
>                         {
>                                 .type   = CX23885_VMUX_SVIDEO,
>                                 .vmux   = CX25840_SVIDEO_LUMA3 |
> CX25840_SVIDEO_CHROMA4,

It seems that your emailer is not your friend too - it broke your patch ;)

Please, be sure to not let your email break long lines like that, or the
patch won't apply.

IMO, the better is to submit patches with git send-email. There are some examples
at git-send-email manpage on how to use it with an smart host, if your sendmail
is not configured for that.

Regards,
Mauro.
