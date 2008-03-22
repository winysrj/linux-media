Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hu-out-0506.google.com ([72.14.214.237])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas.schorpp@googlemail.com>) id 1Jd5vx-0003Rg-5z
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 16:47:02 +0100
Received: by hu-out-0506.google.com with SMTP id 28so1061643hug.11
	for <linux-dvb@linuxtv.org>; Sat, 22 Mar 2008 08:46:57 -0700 (PDT)
Message-ID: <47E529EE.901@googlemail.com>
Date: Sat, 22 Mar 2008 16:46:54 +0100
From: thomas schorpp <thomas.schorpp@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <200803212024.17198.christophpfister@gmail.com>	<47E4EE00.9080207@gmail.com>
	<200803221413.24352.christophpfister@gmail.com>
In-Reply-To: <200803221413.24352.christophpfister@gmail.com>
Subject: Re: [linux-dvb] CI/CAM fixes for knc1 dvb-s cards
Reply-To: thomas.schorpp@googlemail.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Christoph Pfister wrote:
> Am Samstag 22 M=E4rz 2008 schrieb e9hack:
>> Christoph Pfister schrieb:
>>> Hi,
>>>
>>> Can somebody please pick up those patches (descriptions inlined)?
>>>
>>> Thanks,
>>>
>>> Christoph
>> diff -r 1886a5ea2f84 -r f252381440c1
>> linux/drivers/media/dvb/ttpci/budget-av.c ---
>> a/linux/drivers/media/dvb/ttpci/budget-av.c	Fri Mar 21 08:04:55 2008 -03=
00
>> +++ b/linux/drivers/media/dvb/ttpci/budget-av.c	Fri Mar 21 19:29:15 2008
>> +0100 @@ -178,7 +178,7 @@ static int ciintf_read_cam_control(struc
>>   	udelay(1);
>>
>>   	result =3D ttpci_budget_debiread(&budget_av->budget, DEBICICAM, addre=
ss &
>> 3, 1, 0, 0); -	if ((result =3D=3D -ETIMEDOUT) || ((result =3D=3D 0xff) &=
& ((address
>> & 3) < 2))) { +	if ((result =3D=3D -ETIMEDOUT) || ((result =3D=3D 0xff) =
&&
>> ((address & 3) =3D=3D 1))) { ciintf_slot_shutdown(ca, slot);
>>   		printk(KERN_INFO "budget-av: cam ejected 3\n");
>>   		return -ETIMEDOUT;
>>
>>
>> IMHO you should remove the test for 0xff . Without your patch, it wasn't
>> possible to read 0xff from address 0 and 1. Now it isn't possible to read
>> 0xff from address 1.
> =

> Address 1 is the status register; bits 2-5 are reserved according to en50=
221 =

> and should be zero, so this case is less problematic with regards to 0xff =

> checking.
> =

> On second thoughts it's probably better to remove the check altogether, =

> because a) budget-av isn't here to check standards conformance - the high=
er =

> layers know better how to deal with the content and b) who should care if=
 the =

> other status bits work correctly ;)

Better remove all CI stuff from that wrong place.
Why is all that CI and tuner frontend (which dvb budget card has got a anal=
ogtv demod?) =

code in the budget__AV__ module ?
Pls move it to budget__CI__  and budget modules, and have the budget_av/_ci =

stuff detected there and loaded and utilized *if* needed, the current ci-co=
de  =

blocks saa7113 analog capture on plus cards and could, according to manu's =
research, =

confuse a knc1 dvb-s2 card completely.

and who needs cam polling? do we have got a majority of users hotswapping c=
ams?
i want that be clarified before sending rejectable patches.

>> -Hartmut
> =

> Christoph

y
tom

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
