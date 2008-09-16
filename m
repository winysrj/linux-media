Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from tuc.ic3s.de ([80.146.164.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas@ic3s.de>) id 1Kff03-0006DS-Os
	for linux-dvb@linuxtv.org; Tue, 16 Sep 2008 20:10:08 +0200
Message-ID: <48CFF639.40009@ic3s.de>
Date: Tue, 16 Sep 2008 20:08:57 +0200
From: Thomas <thomas@ic3s.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
References: <48CFABD7.8000202@ic3s.de> <48CFB6EC.5080800@iki.fi>
	<48CFBE0E.6060406@ic3s.de> <48CFEC58.2080402@iki.fi>
In-Reply-To: <48CFEC58.2080402@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] problems compiling af9015 on fedora 9
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

problem resolved (also the warnings are gone)

thank you

thomas

Antti Palosaari schrieb:
> Thomas wrote:
>> yes, it is the latest version:
>>
>> hg update
>> 0 files updated, 0 files merged, 0 files removed, 0 files unresolved
>>
>> hg log
>> changeset:   8966:86a15e6b2d89
>> tag:         tip
>> user:        Antti Palosaari <crope@iki.fi>
>> date:        Mon Sep 15 23:18:09 2008 +0300
>> summary:     initial driver for af9015 chipset
>>
>>
>> i have the same error on 2 fedora 9 systems
>> (one of them is running rawhide)
>> and also on my fedora 8 :(
>>
>> these errors appears only on fedora 9:
>>   CC [M]  /home/thomas/af9015-86a15e6b2d89/v4l/af9013.o
>> /home/thomas/af9015-86a15e6b2d89/v4l/af9013.c: In function
>> 'af9013_download_firmware':
>> /home/thomas/af9015-86a15e6b2d89/v4l/af9013.c:1497: warning:
>> assignment discards qualifiers from pointer target type
>>
>>
>>   CC [M]  /home/thomas/af9015-86a15e6b2d89/v4l/af9015.o
>> /home/thomas/af9015-86a15e6b2d89/v4l/af9015.c: In function
>> 'af9015_download_firmware':
>> /home/thomas/af9015-86a15e6b2d89/v4l/af9015.c:665: warning: assignment
>> discards qualifiers from pointer target type
> 
> I removed u64 div from af9013, could you test again? It could fix af9013
> compile error, but it does not remove warning coming from
> download_firmware.
> 
> regards,
> Antti

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
