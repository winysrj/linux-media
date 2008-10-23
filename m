Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 202.7.249.79.dynamic.rev.aanet.com.au ([202.7.249.79]
	helo=home.singlespoon.org.au)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <paulc@singlespoon.org.au>) id 1Kstm0-0005Q7-7o
	for linux-dvb@linuxtv.org; Thu, 23 Oct 2008 08:34:22 +0200
Message-ID: <49001A8D.2000400@singlespoon.org.au>
Date: Thu, 23 Oct 2008 17:32:45 +1100
From: Paul Chubb <paulc@singlespoon.org.au>
MIME-Version: 1.0
To: Mike Adolf <mlnx@mho.com>, linux dvb <linux-dvb@linuxtv.org>
References: <48FED6CB.7030603@mho.com> <48FEC5F6.8000809@singlespoon.org.au>
	<48FFA0E1.4010906@mho.com>
In-Reply-To: <48FFA0E1.4010906@mho.com>
Subject: Re: [linux-dvb] Problem making v4l driver tree
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

Mike,
          I usually find that it failing to find the include files 
indicates that the kernel source/headers are not installed correctly. I 
find that for my distro doing a make kernel-links with perhaps a depmod 
thrown in fixes this kind of problem. I don't know about the IRQ loop 
but then honestly I don't know much about this stuff.

Cheers Paul

Mike Adolf wrote:
> Paul Chubb wrote:
>   
>> Mike,
>>          the make file is looking for the .config from your installed
>> kernel. On some distributions like Gentoo it is where it is expected
>> because Gentoo users compile another kernel at the drop of a hat.
>> Other distros like ubuntu ship the config file but it is not in the
>> right place. For ubuntu you would look in the /boot directory. It will
>> be called something like config-<kernel revision>. Copy it to the name
>> .config in the specified directory:
>>
>> /lib/modules/2.6.25.16-0.1-pae/build/.config
>>
>> You will need to find out what your distro does to ship the config
>> file, get a copy and put it there.
>>
>> HTH
>>
>> Paul
>>
>> Mike Adolf wrote:
>>     
>>> According to the Mythtv Wiki on the pctv 800i card you need to extract
>>> firmware from windows file and download "v4l-dvb-c800683faf86.tar.gz",
>>> and do a make and make install to get the latest tree of drivers
>>> installed.  However, when I did the make I got the following  error.
>>> ------
>>> Updating/Creating .config
>>> Preparing to compile for kernel version 2.6.25
>>> File not found: /lib/modules/2.6.25.16-0.1-pae/build/.config at
>>> ./scripts/make_kconfig.pl line 32, <IN> line 4.
>>> make[1]: *** No rule to make target `.myconfig', needed by
>>> `config-compat.h'.  Stop.
>>> -----
>>> I am use to resolving dependency errors but don't know what to do with
>>> this one. I am using SuSe 11.   Since I do get good video but no sound,
>>> would it be a good idea to do an 'Install-sound' only-once I get it
>>> to make?
>>>
>>> Mike
>>>
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>
>>>   
>>>       
>>     
> I tried that and then it could not find
> /lib/modules/2.6.25.16-0.1-pae/build/include/linux/netdevice.h.
> Maybe I won't need to install the v4l tree.  I say this because in dmesg
> I noticed the error
>
> cx88[0]/1: IRQ loop detected, disabling interrupts
>
> Now all I have to do is find out how to resolve it. Any ideas?
>
> Thanks
> Mike
>
>   


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
