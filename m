Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:50085 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751104AbdLDMBa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Dec 2017 07:01:30 -0500
Subject: Re: [PATCH] Support HVR-1200 analog video as a clone of HVR-1500.
 Tested, composite and s-video inputs.
To: Nigel Kettlewell <nigel.kettlewell@googlemail.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <59BEEC39.2030609@googlemail.com>
 <CAGoCfizQS3fg2Sqjtg2ypiCqa5cMQ=irMZ1nwEVJ8+TeBuAZCA@mail.gmail.com>
 <59C1044E.8060805@googlemail.com> <59C16D1E.80308@googlemail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f345f64e-1d2d-5f9f-d225-29d0ec2e0042@xs4all.nl>
Date: Mon, 4 Dec 2017 13:01:24 +0100
MIME-Version: 1.0
In-Reply-To: <59C16D1E.80308@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nigel,

Can you repost this as a proper patch? It doesn't apply (issues with tabs and
whitespace: please use tabs!), and I am missing a "Signed-off-by" line (see
https://elinux.org/Developer_Certificate_Of_Origin).

Thanks!

	Hans

On 09/19/2017 09:16 PM, Nigel Kettlewell wrote:
> [adding kernel mailing lists missed from my reply]
> 
> Thank you, yes I think I cribbed too much from the 1500. I think the 
> tuner part is not necessary: I have no analog over-the-air signal so I 
> cannot test it, hence I have removed the tuner element from the patch 
> (below).
> 
> I have tested DVB-T which works fine. dmesg shows no errors (attached).
> 
> DISPLAY=xxx:0.0 vlc dvb-t://frequency=498000000:bandwidth=8 
> --dvb-adapter=0 --programs=8373
> <works>
> 
> /usr/local/bin/v4l2-ctl --set-input 1
> /usr/local/bin/v4l2-ctl -s 0x000000f7
> cat /dev/video0 > /tmp/svideo.raw
> <ctrl-c>
> ffmpeg -f rawvideo -pix_fmt yuyv422 -r 25 -s:v 720x576 -i 
> /tmp/svideo.raw -vcodec mpeg2video -vb 2000k -y /tmp/svideo.mpg
> <svideo.mpg plays>
> 
> Revised patch:
> 
> ---
>   drivers/media/pci/cx23885/cx23885-cards.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c 
> b/drivers/media/pci/cx23885/cx23885-cards.c
> index 0350f13..1b685f0 100644
> --- a/drivers/media/pci/cx23885/cx23885-cards.c
> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
> @@ -196,7 +196,22 @@ struct cx23885_board cx23885_boards[] = {
>          },
>          [CX23885_BOARD_HAUPPAUGE_HVR1200] = {
>                  .name           = "Hauppauge WinTV-HVR1200",
> +               .porta          = CX23885_ANALOG_VIDEO,
>                  .portc          = CX23885_MPEG_DVB,
> +               .input          = {{
> +                       .type   = CX23885_VMUX_COMPOSITE1,
> +                       .vmux   =       CX25840_VIN7_CH3 |
> +                                       CX25840_VIN4_CH2 |
> +                                       CX25840_VIN6_CH1,
> +                       .gpio0  = 0,
> +               }, {
> +                       .type   = CX23885_VMUX_SVIDEO,
> +                       .vmux   =       CX25840_VIN7_CH3 |
> +                                       CX25840_VIN4_CH2 |
> +                                       CX25840_VIN8_CH1 |
> +                                       CX25840_SVIDEO_ON,
> +                       .gpio0  = 0,
> +               } },
>          },
>          [CX23885_BOARD_HAUPPAUGE_HVR1700] = {
>                  .name           = "Hauppauge WinTV-HVR1700",
> @@ -2260,6 +2275,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>          case CX23885_BOARD_HAUPPAUGE_HVR1290:
>          case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
>          case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:
> +       case CX23885_BOARD_HAUPPAUGE_HVR1200:
>          case CX23885_BOARD_HAUPPAUGE_HVR1500:
>          case CX23885_BOARD_MPX885:
>          case CX23885_BOARD_MYGICA_X8507:
> --
> 2.9.4
> 
>> Nigel Kettlewell <mailto:nigel.kettlewell@googlemail.com>
>> 19 September 2017 12:49
>> Thank you, yes I think I cribbed too much from the 1500. I think the 
>> tuner part is not necessary: I have no analog over-the-air signal so I 
>> cannot test it, hence I have removed the tuner element from the patch 
>> (below).
>>
>> I have tested DVB-T which works fine. dmesg shows no errors (attached).
>>
>> DISPLAY=xxx:0.0 vlc dvb-t://frequency=498000000:bandwidth=8 
>> --dvb-adapter=0 --programs=8373
>> <works>
>>
>> /usr/local/bin/v4l2-ctl --set-input 1
>> /usr/local/bin/v4l2-ctl -s 0x000000f7
>> cat /dev/video0 > /tmp/svideo.raw
>> <ctrl-c>
>> ffmpeg -f rawvideo -pix_fmt yuyv422 -r 25 -s:v 720x576 -i 
>> /tmp/svideo.raw -vcodec mpeg2video -vb 2000k -y /tmp/svideo.mpg
>> <svideo.mpg plays>
>>
>> Revised patch:
>>
>> ---
>>  drivers/media/pci/cx23885/cx23885-cards.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c 
>> b/drivers/media/pci/cx23885/cx23885-cards.c
>> index 0350f13..1b685f0 100644
>> --- a/drivers/media/pci/cx23885/cx23885-cards.c
>> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
>> @@ -196,7 +196,22 @@ struct cx23885_board cx23885_boards[] = {
>>         },
>>         [CX23885_BOARD_HAUPPAUGE_HVR1200] = {
>>                 .name           = "Hauppauge WinTV-HVR1200",
>> +               .porta          = CX23885_ANALOG_VIDEO,
>>                 .portc          = CX23885_MPEG_DVB,
>> +               .input          = {{
>> +                       .type   = CX23885_VMUX_COMPOSITE1,
>> +                       .vmux   =       CX25840_VIN7_CH3 |
>> +                                       CX25840_VIN4_CH2 |
>> +                                       CX25840_VIN6_CH1,
>> +                       .gpio0  = 0,
>> +               }, {
>> +                       .type   = CX23885_VMUX_SVIDEO,
>> +                       .vmux   =       CX25840_VIN7_CH3 |
>> +                                       CX25840_VIN4_CH2 |
>> +                                       CX25840_VIN8_CH1 |
>> +                                       CX25840_SVIDEO_ON,
>> +                       .gpio0  = 0,
>> +               } },
>>         },
>>         [CX23885_BOARD_HAUPPAUGE_HVR1700] = {
>>                 .name           = "Hauppauge WinTV-HVR1700",
>> @@ -2260,6 +2275,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>>         case CX23885_BOARD_HAUPPAUGE_HVR1290:
>>         case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
>>         case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:
>> +       case CX23885_BOARD_HAUPPAUGE_HVR1200:
>>         case CX23885_BOARD_HAUPPAUGE_HVR1500:
>>         case CX23885_BOARD_MPX885:
>>         case CX23885_BOARD_MYGICA_X8507:
>> --
>> 2.9.4
>>
>>
>>
>> Devin Heitmueller <mailto:dheitmueller@kernellabs.com>
>> 18 September 2017 13:57
>> On Sun, Sep 17, 2017 at 5:42 PM, Nigel Kettlewell
>>
>> I'm not confident the tuner config for this board is correct. The
>> HVR-1200 is much closer to the HVR-1250 as opposed to the HVR-1500,
>> and IIRC it didn't have an xc3028.
>>
>> I don't dispute that with the patch in question the composite/s-video
>> are probably working ok, but I wouldn't recommend accepting this patch
>> as-is until the tuner is verified for DVB-T and analog (ideally both).
>>
>> Can you provide the output of dmesg on device load? If it's filled
>> with a bunch of errors showing xc3028 firmware load failures, that
>> would be a smoking gun that it doesn't have the xc3028.
>>
>> Devin
>>
>> Nigel Kettlewell <mailto:nigel.kettlewell@googlemail.com>
>> 17 September 2017 22:42
>> I propose the following patch to support Hauppauge HVR-1200 analog 
>> video, nothing more than a clone of HVR-1500. Patch based on Linux 4.9 
>> commit 69973b830859bc6529a7a0468ba0d80ee5117826
>>
>> I have tested composite and S-Video inputs.
>>
>> With the change, HVR-1200 devices have a /dev/video<n> entry which is 
>> accessible in the normal way.
>>
>> Let me know if you need anything more.
>>
>> Nigel Kettlewell
>>
>>
>>
>> ---
>>  drivers/media/pci/cx23885/cx23885-cards.c | 24 ++++++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c 
>> b/drivers/media/pci/cx23885/cx23885-cards.c
>> index 99ba8d6..5be38f1 100644
>> --- a/drivers/media/pci/cx23885/cx23885-cards.c
>> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
>> @@ -195,7 +195,30 @@ struct cx23885_board cx23885_boards[] = {
>>         },
>>         [CX23885_BOARD_HAUPPAUGE_HVR1200] = {
>>                 .name           = "Hauppauge WinTV-HVR1200",
>> +               .porta          = CX23885_ANALOG_VIDEO,
>>                 .portc          = CX23885_MPEG_DVB,
>> +               .tuner_type     = TUNER_XC2028,
>> +               .tuner_addr     = 0x61, /* 0xc2 >> 1 */
>> +               .input          = {{
>> +                       .type   = CX23885_VMUX_TELEVISION,
>> +                       .vmux   =       CX25840_VIN7_CH3 |
>> +                                       CX25840_VIN5_CH2 |
>> +                                       CX25840_VIN2_CH1,
>> +                       .gpio0  = 0,
>> +               }, {
>> +                       .type   = CX23885_VMUX_COMPOSITE1,
>> +                       .vmux   =       CX25840_VIN7_CH3 |
>> +                                       CX25840_VIN4_CH2 |
>> +                                       CX25840_VIN6_CH1,
>> +                       .gpio0  = 0,
>> +               }, {
>> +                       .type   = CX23885_VMUX_SVIDEO,
>> +                       .vmux   =       CX25840_VIN7_CH3 |
>> +                                       CX25840_VIN4_CH2 |
>> +                                       CX25840_VIN8_CH1 |
>> +                                       CX25840_SVIDEO_ON,
>> +                       .gpio0  = 0,
>> +               } },
>>         },
>>         [CX23885_BOARD_HAUPPAUGE_HVR1700] = {
>>                 .name           = "Hauppauge WinTV-HVR1700",
>> @@ -2262,6 +2285,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>>         case CX23885_BOARD_HAUPPAUGE_HVR1290:
>>         case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
>>         case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:
>> +       case CX23885_BOARD_HAUPPAUGE_HVR1200:
>>         case CX23885_BOARD_HAUPPAUGE_HVR1500:
>>         case CX23885_BOARD_MPX885:
>>         case CX23885_BOARD_MYGICA_X8507:
>> -- 
>> 2.9.4
>>
> 
