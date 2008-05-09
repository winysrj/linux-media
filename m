Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m49DYitB019692
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 09:34:44 -0400
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m49DYWsf024898
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 09:34:32 -0400
Message-ID: <482452E5.2090602@users.sourceforge.net>
Date: Fri, 09 May 2008 15:34:29 +0200
From: Andre Auzi <aauzi@users.sourceforge.net>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <482370FD.7000001@users.sourceforge.net>
	<1210296633.2541.26.camel@pc10.localdom.local>
In-Reply-To: <1210296633.2541.26.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: cx88 driver: Help needed to add radio support on Leadtek	WINFAST
 DTV 2000 H (version J)
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

hermann pitton a écrit :
> Am Donnerstag, den 08.05.2008, 23:30 +0200 schrieb Andre Auzi:
>> Hello list,
>>
>> I've started the task to add support of the board mentionned above.
>>
>> So far I've got analog TV, Composite and Svideo inputs working OK with 
>> IR as well.
>>
>> Unfortunately, my area does not have DVB-T yet, but from the scans I've 
>> made, I'm confident DVB support is on good tracks.
>>
>> Nevertheless, I cannot achieve to have the radio input working.
>>
>> The gpio values were captured with regspy on a working windows installation.
>>
>> Here are my additions in cx88-cards.c:
>>
>> diff -r 0a072dd11cd8 linux/drivers/media/video/cx88/cx88-cards.c
>> --- a/linux/drivers/media/video/cx88/cx88-cards.c    Wed May 07 15:42:54 
>> 2008 -0300
>> +++ b/linux/drivers/media/video/cx88/cx88-cards.c    Thu May 08 23:07:36 
>> 2008 +0200
>> @@ -1300,6 +1300,52 @@
>>          }},
>>          .mpeg           = CX88_MPEG_DVB,
>>      },
>> +    [CX88_BOARD_WINFAST_DTV2000H_VERSION_J] = {
>> +        /* Radio still in testing */
>> +        .name           = "WinFast DTV2000 H (version J)",
>> +        .tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
>> +        .radio_type     = UNSET,
>> +        .tuner_addr     = ADDR_UNSET,
>> +        .radio_addr     = ADDR_UNSET,
>> +        .tda9887_conf   = TDA9887_PRESENT,
>> +        .input          = {{
>> +            .type   = CX88_VMUX_TELEVISION,
>> +            .vmux   = 0,
>> +            .gpio0  = 0x00013700,
>> +            .gpio1  = 0x0000a207,
>> +            .gpio2  = 0x00013700,
>> +            .gpio3  = 0x02000000,
>> +        },{
>> +            .type   = CX88_VMUX_CABLE,
>> +            .vmux   = 0,
>> +            .gpio0  = 0x0001b700,
>> +            .gpio1  = 0x0000a207,
>> +            .gpio2  = 0x0001b700,
>> +            .gpio3  = 0x02000000,
>> +        },{
>> +            .type   = CX88_VMUX_COMPOSITE1,
>> +            .vmux   = 1,
>> +            .gpio0  = 0x00013701,
>> +            .gpio1  = 0x0000a207,
>> +            .gpio2  = 0x00013701,
>> +            .gpio3  = 0x02000000,
>> +        },{
>> +            .type   = CX88_VMUX_SVIDEO,
>> +            .vmux   = 2,
>> +            .gpio0  = 0x00013701,
>> +            .gpio1  = 0x0000a207,
>> +            .gpio2  = 0x00013701,
>> +            .gpio3  = 0x02000000,
>> +        } },
>> +        .radio = {
>> +            .type   = CX88_RADIO,
>> +            .gpio0  = 0x00013702,
>> +            .gpio1  = 0x0000a207,
>> +            .gpio2  = 0x00013702,
>> +            .gpio3  = 0x02000000,
>> +        },
>> +    },
>>      [CX88_BOARD_GENIATECH_DVBS] = {
>>          .name          = "Geniatech DVB-S",
>>          .tuner_type    = TUNER_ABSENT,
>> @@ -1957,6 +2003,10 @@
>>          .subdevice = 0x665e,
>>          .card      = CX88_BOARD_WINFAST_DTV2000H,
>>      },{
>> +        .subvendor = 0x107d,
>> +        .subdevice = 0x6f2b,
>> +        .card      = CX88_BOARD_WINFAST_DTV2000H_VERSION_J,
>> +    },{
>>          .subvendor = 0x18ac,
>>          .subdevice = 0xd800, /* FusionHDTV 3 Gold (original revision) */
>>          .card      = CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_Q,
>>
>>
>> Would there be someone in the list with cx88 driver knowledge who 
>> already achieved this for another board and could hint me on things to 
>> look for?
>>
>> I kindof reached the limits of my imagination and would really 
>> appreciate a help.
>>
>> So far my modprobe.conf reads:
>>
>> options tda9887 debug=1
>> options cx22702 debug=1
>> options cx88xx i2c_debug=1 i2c_scan=1 audio_debug=1
>> options cx8800 video_debug=1
>>
>> and I would join the dmesg output if I did not care to flood the list.
>>
>> Just let me know if it could help.
>>
>> Thanks in advance
>> Andre
>>
>>
> 
> Hi Andre,
> 
> guess we could need someone to tell about SECAM_L NICAM stereo on
> latest, you might have had a reason to send your current saa7134 patch
> for 2.6.24 only, eventually?
 >

Hi Hermann,

that's different matters but I'm glad somebody noticed.

I've mentioned the kernel version just because it is the one I tested 
the patch with.

Now that I've evolved to 2.6.25 (thanks to F9 preview) I can say that it 
  would work for it too but I had to patch around mercurial's code 
elsewhere (mt9m001.c for i2c interface and zoran_procfs.c where I've 
just removed proc fs support) to have it compile with this new version.

> 
> For the radio, see my previous posts to Andy.
> 
> Radio on the FMD1216ME/I MK3 is not perfect anyway, on other stuff it
> might also only be the best hack around then, but some still claim new
> hardware doesn't exist ...
> 
> Your Items saa7134 patch is not unnoticed, but I would have a lot of
> questions and maybe Hartmut, Nickolay and everybody still interested
> too.
> 

This was a first (lucky?) try and it kind of magically worked at last.

I'll be happy if I can give good answers.

> Try to send it again, read about new cards on the v4l-wiki and about
> patches on a recent v4l-dvb mercurial, we don't invent the rules ...
> 
> As a hint, you might have much better chances for somebody to start
> looking at it, if you split the card and remote addition in two separate
> patches.
> 
 > Cheers,
 > Hermann
 >

It would had been surprising if I did not break one rule or two ;)

It was not intended though and I will follow your advice.

Especially because I'm not completely happy with the state I've reached 
with the S-video input (I thought the cable I've used could be in cause 
but I reused it since then and apparently the thing needs some more work)

Thanks for the hint and just let me know if I can be of any use for some 
tests with our (excuse my french ;) damn standards

Andre



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
