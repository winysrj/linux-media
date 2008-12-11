Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f16.google.com ([209.85.219.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jordi.moles@gmail.com>) id 1LAur5-00083v-Hm
	for linux-dvb@linuxtv.org; Fri, 12 Dec 2008 00:22:05 +0100
Received: by ewy9 with SMTP id 9so1444581ewy.17
	for <linux-dvb@linuxtv.org>; Thu, 11 Dec 2008 15:21:29 -0800 (PST)
Message-ID: <4941A076.3060107@gmail.com>
Date: Fri, 12 Dec 2008 00:21:26 +0100
From: Jordi Molse <jordi.moles@gmail.com>
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
References: <493FFD3A.80209@cdmon.com>	<alpine.DEB.2.00.0812101844230.989@ybpnyubfg.ybpnyqbznva>	<4940032D.90106@cdmon.com>	<alpine.DEB.2.00.0812101956220.989@ybpnyubfg.ybpnyqbznva>	<49401C73.1010208@gmail.com>	<1228955664.3468.21.camel@pc10.localdom.local>	<494066C2.90105@gmail.com>	<1228958740.3468.28.camel@pc10.localdom.local>	<4940C9D6.2020704@cdmon.com>	<alpine.DEB.2.00.0812111415560.989@ybpnyubfg.ybpnyqbznva>	<49411A6E.2020107@gmail.com>
	<49412BF9.5010401@cdmon.com>
	<alpine.DEB.2.00.0812111626260.989@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.00.0812111626260.989@ybpnyubfg.ybpnyqbznva>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] lifeview pci trio (saa7134) not working	through
 diseqc anymore
Reply-To: jordi.moles@gmail.com
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

En/na BOUWSMA Barry ha escrit:
> On Thu, 11 Dec 2008, Jordi Moles Blanco wrote:
>
>   
>> well... i did what i could....
>>     
>
> Thanks, that I did not have to explain how to find the
> kernel source  :-)
>
>
>
>   
>> i extracted the files and run "make". everything worked fine. The problem was
>> that i didn't now how to "load" that new compiled module instead of the
>> "default one"
>>     
>
> If you want to do it the way I do, which is to test the
> newly-built kernel modules without actually installing
> them (in case I have more problems with the new than with
> the old), the way I do it is...
>
> % lsmod
> (lists all the loaded kernel modules)
>
> then I `rmmod' every module related to my particular
> device and dvb/video/whatever is related, if I've been
> updating that part of the source.
>
> Then I load by hand, specifying the path to the
> modules I've just built, like
> # insmod /usr/local/src/v4l-dvb-last-before-2.6.16/v4l/[modname].ko
>
> Keeping an eye on `dmesg' to show dependencies, which
> you have experienced below...
>
>
>   
>> i mean.... if i run "modprobe saa7134"_dvb i'm accessing to the default module
>> that comes with the kernel. is that right? so... i didn't how to load the new
>> module.
>>     
>
> Yes, this is correct.  If you do not care to keep your
> old modules, you can do a
> # make install
> which should overwrite your old distro modules with the
> new ones you've built, as you have done below...
>
>
>   
>> and "make install" so that i could load the new module by just doing "modproe
>> saa7134_dvb". is this right?
>>     
>
>   
>> [  240.715593] saa7134: disagrees about version of symbol v4l_compat_ioctl32
>>     
>
> I've seen this before on the list, but personally I don't
> know the precise solution -- check the archives, if
> someone else doesn't provide the answer.
>
>
>   
>> [  240.715604] saa7134: Unknown symbol v4l_compat_ioctl32
>> [  240.776343] saa7134_dvb: Unknown symbol saa7134_tuner_callback
>> [  240.776410] saa7134_dvb: Unknown symbol saa7134_ts_register
>> [  240.776643] saa7134_dvb: Unknown symbol saa7134_set_gpio
>> [  240.776703] saa7134_dvb: Unknown symbol saa7134_ts_qops
>> [  240.776845] saa7134_dvb: Unknown symbol saa7134_i2c_call_clients
>> [  240.776983] saa7134_dvb: Unknown symbol saa7134_ts_unregister
>>     
>
> For the unknown symbols, as I mentioned above, that
> means that needed modules aren't loaded -- as I note,
> the way I do things (not recommended!) is to load
> everything manually, mainly because I want to test
> new hacks without losing my old modules.
>
> I would then have to
> # insmod /path/to/new/modules/[related-module].ko
> where the related-modules are usually listed in the
> `lsmod' output -- or else I just guess and load
> anything that looks interesting and relevant.
>
> As a wild guess, you need to load 
>  ...drivers/media/video/compat_ioctl32.ko
> in order to get v4l_compat_ioctl32; 
>  ...drivers/media/video/saa7134/saa7134.ko
> probably contains the various saa7134_foo symbols
> which are needed by saa7134_dvb...
>
>
>   
>> any idea how to fix this?
>>     
>
> Check the mailing list archives, is my suggestion,
> since my personal answer is `no', not having
> experienced this myself...
>
> Anyway, I'm happy that you're able to work your way
> through this without too much help, and I hope you
> are learning something useful at the same time...
>
>
> barry bouwsma
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   

Hi, thanks again for the help you are offering me.

However, i haven't been able to get diseqc working and i don't think i 
will....

let's go through all the thing...

i've got a lifeview flydvb pci trio card (saa7134) which has different 
chips, to tune satellite, digital terrestrial tv and also radio.

i used to have this card running in a dual boot with windows xp, where 
everything worked like a charm, and another one where i kept installing 
linux distros without any luck until "kubuntu hardy" came out. At that 
point, as the card with diseqc worked "out of the box", i decided to 
erase all data and move to ubuntu.

then i upgraded the system and also moved the tower from its place to 
next to the tv (to be a medicenter computer :) ). Then i couldn't view 
the channels anymore. I tried to retune with no luck... I check all the 
cables, just in case one of them was in bad shape. I even replaced the T 
connectors, just in case.

Then is when i first posted here with all my diseqc problems.

Since that moment i've reinstalled the whole system several times and 
even compiled the latest linux-dvb modules, but no matter what i do... i 
can only tune what is on switch 1 of my diseqc, never switch 2.

so... is it possible that somehow i've broken the card someone? the 
truth is that what used to work in windows... doesn't work anymore... 
this evening i went back to windows just to check if the card, the 
diseqc and everything was fine... and i had so many problems to get the 
satellite working as before. i used to use progdvb, which supported 
diseqc for my card and now it just can't tune through diseqc, none of 
the two satellites. other software does know how to get through diseqc, 
but only switch 1.

is it then possible that it's "half-broken"? i mean.. it's still able to 
tune, but not through diseqc because.....................

i'm no satellite or linux expert, but now i can confirm that while i 
still can view satellite channels in windows, it's not working as it 
used to anymore...

i've checked cables and i don't think it's an issue from the diseq 
thing, cause i've got two and both give the same problem.

well.. i guess i won't be able to use diseqc anymore... but if only 
someone could through some light on this...... at least how come i've 
broken it...

thanks.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
