Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from chokecherry.srv.cs.cmu.edu ([128.2.185.41])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rajesh@cs.cmu.edu>) id 1JNKik-0001af-FC
	for linux-dvb@linuxtv.org; Fri, 08 Feb 2008 05:20:14 +0100
Received: from [192.168.1.129] (cm29.delta204.maxonline.com.sg [59.189.204.29])
	(authenticated bits=0)
	by chokecherry.srv.cs.cmu.edu (8.13.6/8.13.6) with ESMTP id
	m184K4Aw011393
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Thu, 7 Feb 2008 23:20:12 -0500 (EST)
Message-ID: <47ABD87B.1040602@cs.cmu.edu>
Date: Fri, 08 Feb 2008 12:20:11 +0800
From: Rajesh Balan <rajesh@cs.cmu.edu>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47AB0219.8050408@cs.cmu.edu> <47AB0337.3050208@cs.cmu.edu>
In-Reply-To: <47AB0337.3050208@cs.cmu.edu>
Subject: [linux-dvb] Solved!: Re: HVR1300 not detected by ir_kbd_i2c module
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Darron Broad pointed me to the patches available at

http://dev.kewl.org/hauppauge/   (get the sfe version for the 1300). The patches applied cleanly about the v4l main tree mercurial source.

That fixed the problem. both ir-kbd-i2c and lirc-i2c detect and initialize the IR receiver on the HVR1300 now. 

Thanks for your help Darron!

Rajesh


Rajesh Balan wrote:
> forgot to add. I've tried the current hg sources of both the main v4l 
> repo and the hvr1300 specific repo. neither works.
>
> Rajesh
>
> Rajesh Balan wrote:
>   
>> Hi,
>>
>> my new HVR-1300 is not being detected by the ir_kbd_i2c.ko module. I've 
>> tracked down the relevant info in the ir_probe component of the module.
>>
>> ir-kbd-i2c: in ir_probe. adap->id=40004
>> ir-kbd-i2c: in ir_probe. adap->id=1001b
>> ir-kbd-i2cprobe 0x18 @ cx88[0]: no
>> ir-kbd-i2cprobe 0x6b @ cx88[0]: no
>> ir-kbd-i2cprobe 0x71 @ cx88[0]: no
>>
>> and then it exits.
>>
>> as for my card itself, it loads all the other modules fine. The 
>> intialization is exactly the same as shown at   
>> http://de.pastebin.ca/raw/891927
>>
>> except that the ir-kbd-i2c parts are not there and this line is different
>>
>> tveeprom 0-0050: Hauppauge model 96019, rev C6A0, serial# 446394
>>
>> my rev number is D6D3.
>>
>> What do I do to help debug this?
>>
>> Rajesh
>>
>>
>>
>>
>>
>>
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
