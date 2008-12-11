Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from correo.cdmon.com ([212.36.74.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jordi@cdmon.com>) id 1LAn69-0002Ao-4T
	for linux-dvb@linuxtv.org; Thu, 11 Dec 2008 16:05:05 +0100
Message-ID: <49412BF9.5010401@cdmon.com>
Date: Thu, 11 Dec 2008 16:04:25 +0100
From: Jordi Moles Blanco <jordi@cdmon.com>
MIME-Version: 1.0
References: <493FFD3A.80209@cdmon.com>	<alpine.DEB.2.00.0812101844230.989@ybpnyubfg.ybpnyqbznva>	<4940032D.90106@cdmon.com>	<alpine.DEB.2.00.0812101956220.989@ybpnyubfg.ybpnyqbznva>	<49401C73.1010208@gmail.com>	<1228955664.3468.21.camel@pc10.localdom.local>	<494066C2.90105@gmail.com>	<1228958740.3468.28.camel@pc10.localdom.local>	<4940C9D6.2020704@cdmon.com>	<alpine.DEB.2.00.0812111415560.989@ybpnyubfg.ybpnyqbznva>
	<49411A6E.2020107@gmail.com>
In-Reply-To: <49411A6E.2020107@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] lifeview pci trio (saa7134) not working	through
 diseqc anymore
Reply-To: jordi@cdmon.com
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

En/na Jordi Molse ha escrit:
> En/na BOUWSMA Barry ha escrit:
>   
>> On Thu, 11 Dec 2008, Jordi Moles Blanco wrote:
>>
>>   
>>     
>>> would you mind telling me what linux system are you working with? i'm 
>>> desperate for this to work, i will change to any distro that makes 
>>> diseqc work.
>>>     
>>>       
>> If you are willing to get your hands dirty with kernel
>> source and possibly a source-control system, then you
>> may be able to get a working system, without the need to
>> change distributions -- maybe.
>>
>> The drawback to the convenience of packaged distributions
>> is that they are frozen at a particular point in time,
>> which can lock you out of improvements.  That's one of
>> the tradeoffs for the convenience about not having to
>> worry about these things, which is great, when it works.
>>
>>
>> The linux-dvb source should be self-contained for all
>> that you need to get your device working.  (But not
>> always...)  So, the easiest way would be for you to
>> build the linux-dvb source as modules against your
>> present kernel version, whatever that may be.
>>
>> This will also allow you to go back in time, should
>> your device fail to work with the latest source, and
>> go back to the point where it did work -- and thereby
>> help the developers to get the latest source to work
>> again.
>>
>>
>> Anyway, you will need to update/download...
>> the sources for the kernel you are using
>> the latest linux-dvb source or tarball
>>
>> The latter can be found at
>> http://linuxtv.org/hg/v4l-dvb/archive/tip.tar.bz2
>> or, slightly larger,
>> http://linuxtv.org/hg/v4l-dvb/archive/tip.tar.gz
>>
>> This is the latest source; if you look around the
>> linuxtv.org site, you will also see a way to download
>> the entire history of the source which will help you
>> go back in time -- such as I've done today in order
>> to try to see if my production 2.6.14-ish machine
>> can use the last useable release without problems.
>>
>>
>> Are you comfortable working with the command line?
>> I hope so, because that's exclusively what I use.
>> When you've downloaded one of the above archives,
>> you'll need to extract it into a suitable playground,
>> perhaps like
>> % cd ~/
>> % mkdir src
>> % cd src
>> % tar z(or j or y)xvf ~/tip.tar.(whatever)
>> % cd (whatever-has-been-created)
>> % make
>>
>> This expects you to have downloaded the source for
>> your kernel as well -- if you're unsure of how to get
>> this, someone familiar with your distribution should
>> be able to help, if there isn't anything on the wiki
>> to give details of building this.
>>
>> If you don't have the proper kernel source, your attempt
>> to `make' will fail with lots of complaints.
>>
>> If you do have the source, it's also possible your
>> attempted `make' will fail, and probably someone here
>> or elsewhere can help fix what's needed (if the source
>> is not found where it is expected, for example)
>>
>>
>> If all goes will, you will have the very latest kernel
>> modules that support your device, and can try them, to
>> see if they work, or if there are still problems.
>>
>>
>> barry bouwsma
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>   
>>     
> hi,
>
> thanks for all the information provided, it's great!!..
>
> i'm not and experienced user, but i get along well with command shell, 
> and i'm able to run gcc and install thing form the scratch.
>
> i'll give a try to see if i can compile and use those modules you suggest.
>
> i'll report back with what i've found.
>
> thanks.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   

well... i did what i could....

the thing is that it seemed to work right until the end....

i extracted the files and run "make". everything worked fine. The 
problem was that i didn't now how to "load" that new compiled module 
instead of the "default one"

i mean.... if i run "modprobe saa7134"_dvb i'm accessing to the default 
module that comes with the kernel. is that right? so... i didn't how to 
load the new module.

what i did then was "make distclean"

and then i compiled with "make all"

and "make install" so that i could load the new module by just doing 
"modproe saa7134_dvb". is this right?

well....

when loading i get this message:

********************
FATAL: Error inserting saa7134 
(/lib/modules/2.6.24-19-generic/kernel/drivers/media/video/saa7134/saa7134.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error running install command for saa7134
FATAL: Error inserting saa7134_dvb 
(/lib/modules/2.6.24-19-generic/kernel/drivers/media/video/saa7134/saa7134-dvb.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
*********************

and this is what dmesg says about it:

*********************
[  240.715593] saa7134: disagrees about version of symbol 
v4l_compat_ioctl32
[  240.715604] saa7134: Unknown symbol v4l_compat_ioctl32
[  240.776343] saa7134_dvb: Unknown symbol saa7134_tuner_callback
[  240.776410] saa7134_dvb: Unknown symbol saa7134_ts_register
[  240.776643] saa7134_dvb: Unknown symbol saa7134_set_gpio
[  240.776703] saa7134_dvb: Unknown symbol saa7134_ts_qops
[  240.776845] saa7134_dvb: Unknown symbol saa7134_i2c_call_clients
[  240.776983] saa7134_dvb: Unknown symbol saa7134_ts_unregister

*********************


right now, i'm running on kernel 2.6.24-19-generic

any idea how to fix this?

thanks.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
