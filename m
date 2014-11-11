Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:42079 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038AbaKKWld (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 17:41:33 -0500
Message-ID: <54629099.5060607@earthlink.net>
Date: Tue, 11 Nov 2014 16:41:29 -0600
From: The Bit Pit <thebitpit@earthlink.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH]  KWorld UB435Q V3 (ATSC) tuner
References: <545D25E8.5080701@earthlink.net> <20141111155627.63713572@recife.lan>
In-Reply-To: <20141111155627.63713572@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I initially was unable to make my tuner work with the released driver
because I was using a USB-2 slot on my ASUS Z87-EXPERT motherboard.  It
sometimes initialized on USB-2 according to information in dmesg.  When
I tried w_scan, it always immediately disconnected.  Frustrated, I tried
USB-3 -- and my patches worked perfectly including a functioning LED,

Today, I retested the linux 3.16.7 release driver on USB-3 and it works.

More comments below.

On 11/11/2014 11:56 AM, Mauro Carvalho Chehab wrote:
> Hi,
>
> Em Fri, 07 Nov 2014 14:04:56 -0600
> The Bit Pit <thebitpit@earthlink.net> escreveu:
>
>> From Wilson Michaels <thebitpit@earthlink.net>
>>
>> This patch fixes the KWorld UB435-Q V3 (ATSC) tuner functions:
>> 1) The LED indicator now works.
>> 2) Start up initialization is faster.
>> 3) Add "lgdt330x" device name i2c_devs array used for debugging
>> 4) Correct comments about the UB435-Q V3
>>
>> Signed-off-by: Wilson Michaels <thebitpit@earthlink.net>
>>
>> #
>> # On branch media_tree/master
>> # Your branch is up-to-date with 'r_media_tree/master'.
>> #
>> # Changes to be committed:
>> # modified:   drivers/media/usb/em28xx/em28xx-cards.c
>> # modified:   drivers/media/usb/em28xx/em28xx-i2c.c
>> #
>> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c
>> b/drivers/media/usb/em28xx/em28xx-cards.c
>> index 3c97bf1..96835de 100644
>> --- a/drivers/media/usb/em28xx/em28xx-cards.c
>> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
>> @@ -189,11 +189,19 @@ static struct em28xx_reg_seq kworld_a340_digital[] = {
>>         {       -1,             -1,     -1,             -1},
>>  };
>>  
>> +/*
>> + * KWorld UB435-Q V3 (ATSC) GPIOs map:
>> + * EM_GPIO_0 - i2c disable/enable (1 = off, 0 = on)
>> + * EM_GPIO_1 - LED disable/enable (1 = off, 0 = on)
>> + * EM_GPIO_2 - currently unknown
>> + * EM_GPIO_3 - currently unknown
>> + * EM_GPIO_4 - currently unknown
>> + * EM_GPIO_5 - TDA18272/M tuner (1 = active, 0 = in reset)
>> + * EM_GPIO_6 - LGDT3304 ATSC/QAM demod (1 = active, 0 = in reset)
>> + * EM_GPIO_7 - currently unknown
>> + */
> This is wrong.
>
> At least here on my Kworld UB435-Q v3, I'm pretty sure that
> the LED is controlled by EM_GPIO_7.
>
> This is something easy to test with:
>
> # v4l2-dbg -s 0x80 0x80
> Register 0x00000080 set to 0x80
> # v4l2-dbg -s 0x80 0x00 
> Register 0x00000080 set to 0x0
I was concerned that the test was also setting bits other than EM_GPIO_7
so I read the register first then set only the EM_GPIO_7 bit:

# v4l2-dbg -g 0x80
ioctl: VIDIOC_DBG_G_REGISTER
Register 0x00000080 = feh (254d  11111110b)
# v4l2-dbg -s 0x80 0x7e
Register 0x00000080 set to 0x7e
# v4l2-dbg -s 0x80 0xfe
Register 0x00000080 set to 0xfe

This actually controls the LED.  You are correct and I am wrong,  My
incorrect initialization was leaving the LED turned on.


>
> And the patch below to force the creation of a video device, allowing
> the usage of the VIDIOC_DBG_S_REGISTER ioctl at the /dev/video0 interface:
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 0db880c..120c689 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -3342,6 +3342,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>  		}
>  	}
>  
> +/* HACK! */
> +has_video=1;
>  	if (!(has_vendor_audio || has_video || has_dvb)) {
>  		retval = -ENODEV;
>  		goto err_free;
Helpful hack ;-)
>
>>  static struct em28xx_reg_seq kworld_ub435q_v3_digital[] = {
>> -       {EM2874_R80_GPIO_P0_CTRL,       0xff,   0xff,   100},
>> -       {EM2874_R80_GPIO_P0_CTRL,       0xfe,   0xff,   100},
>> -       {EM2874_R80_GPIO_P0_CTRL,       0xbe,   0xff,   100},
>> -       {EM2874_R80_GPIO_P0_CTRL,       0xfe,   0xff,   100},
>> +       {EM2874_R80_GPIO_P0_CTRL,       0x6e,   ~EM_GPIO_4,     10},
>>         {       -1,                     -1,     -1,     -1},
>>  };
> Also, the above sequence were obtained from the original driver,
> by sniffing its traffic. 
>
> Perhaps you have a different model?
Same model, my error made it seem to work properly.
>
>> @@ -532,7 +540,7 @@ static struct em28xx_led kworld_ub435q_v3_leds[] = {
>>         {
>>                 .role      = EM28XX_LED_DIGITAL_CAPTURING,
>>                 .gpio_reg  = EM2874_R80_GPIO_P0_CTRL,
>> -               .gpio_mask = 0x80,
>> +               .gpio_mask = 0x02,
>>                 .inverted  = 1,
>>         },
>>         {-1, 0, 0, 0},
> The above is wrong, as 0x80 is where the led is, as shown above.
I agree.
>
>> @@ -2182,7 +2190,7 @@ struct em28xx_board em28xx_boards[] = {
>>         },
>>         /*
>>          * 1b80:e34c KWorld USB ATSC TV Stick UB435-Q V3
>> -        * Empia EM2874B + LG DT3305 + NXP TDA18271HDC2
>> +        * Empia EM2874B + LG DT3305 + NXP TDA18272/M
> I think I didn't actually open the hardware, to check what's
> inside, but you're probably right: for sure it has a 18272 tuner.
I did open up my hardware, the part is marked TDA18272/M.
>>          */
>>         [EM2874_BOARD_KWORLD_UB435Q_V3] = {
>>                 .name           = "KWorld USB ATSC TV Stick UB435-Q V3",
>> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c
>> b/drivers/media/usb/em28xx/em28xx-i2c.c
>> index 1048c1a..5bc6ef1 100644
>> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
>> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
>> @@ -877,6 +877,7 @@ static struct i2c_client em28xx_client_template = {
>>   * incomplete list of known devices
>>   */
>>  static char *i2c_devs[128] = {
>> +       [0x1c >> 1] = "lgdt330x",
>>         [0x3e >> 1] = "remote IR sensor",
>>         [0x4a >> 1] = "saa7113h",
>>         [0x52 >> 1] = "drxk",
> You can send this on a separate patch.
Yes, I will send it.
> Regards,
> Mauro
>

