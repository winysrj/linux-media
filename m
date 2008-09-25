Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Darron Broad <darron@kewl.org>
To: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48DAD9C2.2050007@linuxtv.org> 
References: <200808181427.36988.ajurik@quick.cz> <48A9BAFE.8020501@linuxtv.org>
	<Pine.LNX.4.64.0809221254150.21880@shogun.pilppa.org>
	<48D7BC64.2020002@linuxtv.org>
	<Pine.LNX.4.64.0809250053260.11057@shogun.pilppa.org>
	<48DAD9C2.2050007@linuxtv.org>
Date: Thu, 25 Sep 2008 09:41:54 +0100
Message-ID: <14352.1222332114@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-4000 driver problems - i2c error
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <48DAD9C2.2050007@linuxtv.org>, Steven Toth wrote:

hi.

>Mika Laitio wrote:
>>> The ~stoth/hg/s2 has no DVB-T support on the HVR4000 yet. Those 
>>> patches will appear very shortly in ~stoth/hg/s2-mfe.
>> 
>> Thanks,
>> 
>> I build and installed drivers from s2-mfe branch and now atleast the 
>> dvb-t and dvb-s scan were working both for hvr-1300 and hvr-4000.
>> With hvr-4000, the scan worked with
>> "./scan -a 1 -f 1 "... parameters.

>>>>  WIth liplianinis multiproto version the selection between DVB-S and 
>>>> DVB-T
>>>>  works by using the "options cx88-dvb frontend=1" but I am seeing the 
>>>> i2c
>>>>  errors described below.

This was an option added to the SFE driver which has now
become obsolete. A new patch for this can be created easily
enough though. The i2c errors you are probably reporting
here have also been fixed in MFE (see below). 

>>>>  Could you have any URL and changeset tag to patch in some repository 
>>>> where
>>>>  this I2C thing has been fixed?
>>>
>>> I'm speculating that your issue is the same issue I fixed sometime ago 
>>> (2-3 months in the master repo). I'd suggest you wait for the ~ 
>>> stoth/hg/s2-mfe patches to appear later tonight and test again.
>>>
>>> That tree (and ~stoth/hg/s2 for that matter) have the i2c fix I'm 
>>> referring to.
>> 
>> I tried to find the fix by checking from the log your commits for cx88 
>> couple of months ago and could not find the one you were referring.
>> Then I remembered that in 2.6.25 kernel, similar errors for HVR-1300 
>> could be fixed by defining the radio information for the board structure.
>> 
>> So I tried the same trick also for hvr-4000, and that made dvb-t working 
>> without I2C errors also for HVR4000. ( with liplianis version of 
>> multiproto tree.)
>> 
>> --- cx88-cards.c_old    2008-09-25 00:51:18.000000000 +0300
>> +++ cx88-cards.c    2008-09-24 10:44:15.000000000 +0300
>> @@ -1480,6 +1480,10 @@
>>          }},
>>          /* fixme: Add radio support */
>>          .mpeg           = CX88_MPEG_DVB,
>> +        .radio = {
>> +            .type   = CX88_RADIO,
>> +            .gpio0    = 0xe780,
>> +        },

I put this is the patch also. Radio doesn't work though. There is
not enough information as to how to fix it as yet.

>>      [CX88_BOARD_HAUPPAUGE_HVR4000LITE] = {
>>          .name           = "Hauppauge WinTV-HVR4000(Lite) DVB-S/S2",
>> 
>> In S2 and S2-mfe, the dvb-t worked even without radio data defined for 
>> hvr-4000.
>> 
>> Other non-API related changes that I could found between multiproto and 
>> s2 trees for CX88 were pretty small. Is this udelay really needed?
>> 
>> @@ -2594,8 +2598,9 @@
>>          break;
>>      case CX88_BOARD_HAUPPAUGE_HVR3000: /* ? */

The above has been reverted for the hvr-3000.

>>      case CX88_BOARD_HAUPPAUGE_HVR4000:
>> -        /* Init GPIO for DVB-S/S2/Analog */
>> -        cx_write(MO_GP0_IO,core->board.input[0].gpio0);
>> +        /* Init GPIO */
>> +        cx_write(MO_GP0_IO, core->board.input[0].gpio0);
>> +        udelay(1000);
>>          break;
>> 
>>      case CX88_BOARD_PROLINK_PV_8000GT:
>> @@ -2939,6 +2944,7 @@
>>          cx88_card_list(core, pci);
>>      }
>> 
>> +    memset(&core->board, 0, sizeof(core->board));
>>      memcpy(&core->board, &cx88_boards[core->boardnr], 
>> sizeof(core->board));
>> 
>>      info_printk(core, "subsystem: %04x:%04x, board: %s [card=%d,%s]\n",
>> 
>> Those did not help
>
>Thanks.
>
>I'm going to rebase the s2-mfe tree from master (containing the s2api). 
>Darron also has a i2c related fix (which isn't perfect) but does address 
>an issue like this.

I am about to prepare a new patch-set for the above but in the meantime
you can look at this:
	http://dev.kewl.org/hauppauge/gate_control-8894.diff

This fixes some loading time i2c errors and also errors with
moving from DVB-T to analogue TV.

Other errors found which occur when moving from DVB-S to DVB-T
are work in progress and will be fixed later.

>I'll rebase and push both of those patches into ~stoth/s2-mfe, if you 
>can retest after this then that would be useful.
>
>Watch for changes to this tree tonight, it may help.

cya!

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
