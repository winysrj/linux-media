Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marko.ristola@kolumbus.fi>) id 1KWcLi-0001Ix-2j
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 21:31:08 +0200
Message-ID: <48AF13F1.8040202@kolumbus.fi>
Date: Fri, 22 Aug 2008 22:30:57 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Ola Ekedahl <ola.ekedahl@fra.se>
References: <48ABB045.5050301@fra.se>
	<20080820082010.GA5582@gmail.com>	<48AD16A1.5040703@fra.se>
	<48AE500A.1060204@fra.se>
In-Reply-To: <48AE500A.1060204@fra.se>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto, multiproto_plus & mantis
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Hi,

Here are two ways to accomplish the compilation problem,
the second one might be the easier one for you.


One commonly working way to fix odd compilation problems:
1. Check out from linuxtv.org v4l-dvb-linuxtv (the main branch).
2. Check from there the file v4l-dvb-linuxtv/linux/drivers/media/???/s400.c

There you will probably find the fix for the s400.c problem.
Then you just copy that fix into multiproto s400.c version and compile 
the multiproto version again.

So the wisdom is, that usually v4l-dvb-linuxtv will gain all 
compatibility fixes for many kernels.


Another way to fix compilation problem is to try to disable s400.c 
altogether:
Add into v4l/versions.txt s400.c driver's definition under [2.6.99] and 
remove it from other places in versions.txt.

Idea is that you inform compilation system that s400 doesn't work yet in 
your kernel, but instead it will work under 2.6.99.
Kernel compilation system desides to skip the compilation of the broken 
driver and because you don't need
s400.c, it doesn't matter for you.

Happy hunting.

Regards,
Marko Ristola

Ola Ekedahl kirjoitti:
> Seriously, no one knows what might be wrong? Is it the kernel or might 
> it be the compilation software?
>
>   
>> Gregoire Favre skrev:
>>   
>>     
>>> On Wed, Aug 20, 2008 at 07:48:53AM +0200, Ola Ekedahl wrote:
>>>   
>>>     
>>>       
>>>> Hi,
>>>>
>>>> I have been trying to compile the three different trees in Fedora 7, but 
>>>> all fails with alot of warnings and errors. What are the recomended 
>>>> specification for the kernel, wont it compile with the kernel in Fedora 7?
>>>>     
>>>>       
>>>>         
>>> AFAIK the only actively maintened tree is :
>>> http://liplianindvb.sourceforge.net/cgi-bin/hgwebdir.cgi/liplianindvb/
>>>
>>> Wanny try this one ?
>>>   
>>>     
>>>       
>> I tried to compile the driver, but it failed too. I got the following 
>> error after quite some time:
>>
>>   LD [M]  /home/kurt/Desktop/liplianindvb/v4l/sms1xxx.o
>>   CC [M]  /home/kurt/Desktop/liplianindvb/v4l/s400.o
>> /home/kurt/Desktop/liplianindvb/v4l/s400.c: In function 's400_ir_init':
>> /home/kurt/Desktop/liplianindvb/v4l/s400.c:508: error: 'struct 
>> input_dev' has no member named 'dev'
>> make[3]: *** [/home/kurt/Desktop/liplianindvb/v4l/s400.o] Error 1
>> make[2]: *** [_module_/home/kurt/Desktop/liplianindvb/v4l] Error 2
>> make[2]: Leaving directory `/usr/src/kernels/2.6.21-1.3194.fc7-i686'
>> make[1]: *** [default] Error 2
>> make[1]: Leaving directory `/home/kurt/Desktop/liplianindvb/v4l'
>> make: *** [all] Error 2
>>
>>
>>
>> Anyone have any idea? Is it because of the dist Im running?
>>
>> Best regards
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>   
>>     
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
