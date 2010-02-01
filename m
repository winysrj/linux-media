Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58363 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab0BAMXv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2010 07:23:51 -0500
Received: by wwi18 with SMTP id 18so333875wwi.19
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2010 04:23:50 -0800 (PST)
Message-ID: <4B66C649.7010500@gmail.com>
Date: Mon, 01 Feb 2010 12:17:13 +0000
From: Nameer Kazzaz <nameer.kazzaz@gmail.com>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: paul10@planar.id.au, linux-media <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Christian_H=FCppe?= <christian.hueppe@web.de>
Subject: Re: DM1105: could not attach frontend 195d:1105
References: <3bf14d196e3bc8717d910d09a623f98e@mail.velocitynet.com.au> <8f772b00c9ad2033899eeb1913ee42e0@mail.velocitynet.com.au> <52aaba8d0f6ba9e6928ea68d96565bf4@mail.velocitynet.com.au> <201001311545.09620.liplianin@me.by>
In-Reply-To: <201001311545.09620.liplianin@me.by>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,
dmesg output with patched dm1105.c against current v4l-dvb 'modprob 
dm1105 card=4'

dm1105 0000:05:0f.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
DVB: registering new adapter (dm1105)
dm1105 0000:05:0f.0: MAC dd49b0dc
dm1105 0000:05:0f.0: could not attach frontend
dm1105 0000:05:0f.0: PCI INT A disabled

Thanks
Nameer Kazzaz

Igor M. Liplianin wrote:
> On 20 ?????? 2010 23:20:20 paul10@planar.id.au wrote:
>   
>> Igor wrote:
>>     
>>> Oh, that is wrong. It is registers addresses, Never touch this.
>>>
>>> Let's look on that part of code:
>>>
>>> /* GPIO's for LNB power control */
>>> #define DM1105_LNB_MASK                         0x00000000 // later in
>>>       
>> code write it to
>>
>>     
>>> DM1105_GPIOCTR, all GPIO's as OUT
>>> #define DM1105_LNB_OFF                          0x00020000 // later in
>>>       
>> code write it to
>>
>>     
>>> DM1105_GPIOVAL, set GPIO17 to HIGH
>>>
>>> But you have not to change this.
>>> Right way is to write another entry in cards structure and so on.
>>> Better leave it to me.
>>>
>>> Regards
>>> Igor
>>>       
>> Thanks for all your help, I understand better now.  I have moved to code
>> like that at the bottom.  It still doesn't work, but feels a lot closer.
>>
>> Before I keep playing with values, I want to check I'm on the right track.
>> Does it look right?  Specific questions:
>> 1. I see there is a hw_init function.  Should I be using that?  I put the
>> logic into fe_attach because there was already card-specific logic in
>> there.  But this feels like hw initialisation.
>>
>> 2. Should I set the control to input or output?  I'm assuming input = 1.
>>
>> 3. Would pin 15 be numbered from the left or right - is it 0x4, or 0x2000?
>>
>> Thanks,
>>
>> Paul
>>
>> *** dm1105.c.old        2010-01-13 16:15:00.000000000 +1100
>> --- dm1105.c    2010-01-21 08:13:14.000000000 +1100
>> ***************
>> *** 51,56 ****
>> --- 51,57 ----
>>   #define DM1105_BOARD_DVBWORLD_2002    1
>>   #define DM1105_BOARD_DVBWORLD_2004    2
>>   #define DM1105_BOARD_AXESS_DM05               3
>> + #define DM1105_BOARD_UNBRANDED                4
>>
>>   /* ----------------------------------------------- */
>>   /*
>> ***************
>> *** 171,176 ****
>> --- 172,181 ----
>>   #define DM05_LNB_13V                          0x00020000
>>   #define DM05_LNB_18V                          0x00030000
>>
>> + /* GPIO's for demod reset for unbranded 195d:1105 */
>> + #define UNBRANDED_DEMOD_MASK                  0x00008000
>> + #define UNBRANDED_DEMOD_RESET                 0x00008000
>> +
>>   static unsigned int card[]  = {[0 ... 3] = UNSET };
>>   module_param_array(card,  int, NULL, 0444);
>>   MODULE_PARM_DESC(card, "card type");
>> ***************
>> *** 206,211 ****
>> --- 211,219 ----
>>         [DM1105_BOARD_AXESS_DM05] = {
>>                 .name           = "Axess/EasyTv DM05",
>>         },
>> +       [DM1105_BOARD_UNBRANDED] = {
>> +               .name           = "Unbranded 195d:1105",
>> +         },
>>   };
>>
>>   static const struct dm1105_subid dm1105_subids[] = {
>> ***************
>> *** 229,234 ****
>> --- 237,246 ----
>>                 .subvendor = 0x195d,
>>                 .subdevice = 0x1105,
>>                 .card      = DM1105_BOARD_AXESS_DM05,
>> +       }, {
>> +               .subvendor = 0x195d,
>> +               .subdevice = 0x1105,
>> +               .card      = DM1105_BOARD_UNBRANDED,
>>         },
>>   };
>>
>> ***************
>> *** 698,703 ****
>> --- 710,727 ----
>>                         dm1105dvb->fe->ops.set_voltage =
>> dm1105dvb_set_voltage;
>>
>>                 break;
>> +       case DM1105_BOARD_UNBRANDED:
>> +                 printk(KERN_ERR "Attaching as board_unbranded\n");
>> +               outl(UNBRANDED_DEMOD_MASK, dm_io_mem(DM1105_GPIOCTR));
>> +               outl(UNBRANDED_DEMOD_RESET , dm_io_mem(DM1105_GPIOVAL));
>> +               dm1105dvb->fe = dvb_attach(
>> +                       si21xx_attach, &serit_config,
>> +                       &dm1105dvb->i2c_adap);
>> +                       if (dm1105dvb->fe)
>> +                               dm1105dvb->fe->ops.set_voltage =
>> +                                       dm1105dvb_set_voltage;
>> +
>> +               break;
>>         case DM1105_BOARD_DVBWORLD_2002:
>>         case DM1105_BOARD_AXESS_DM05:
>>         default:
>>     
> Some things are missed, like keep GPIO15 high in set_voltage function.
> Try attached patch against current v4l-dvb tree with modprobe option card=4
> 	modprobe dm1105 card=4
>   

