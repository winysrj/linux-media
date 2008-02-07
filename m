Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas.schorpp@googlemail.com>) id 1JND2c-0003W5-4C
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 21:08:15 +0100
Received: by ti-out-0910.google.com with SMTP id y6so24398tia.13
	for <linux-dvb@linuxtv.org>; Thu, 07 Feb 2008 12:07:44 -0800 (PST)
Message-ID: <47AB650B.2020001@googlemail.com>
Date: Thu, 07 Feb 2008 21:07:39 +0100
From: thomas schorpp <thomas.schorpp@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47AB3603.20303@gmail.com>
	<387ee2020802070901w2e3f3896n51fa97acbf01683e@mail.gmail.com>
In-Reply-To: <387ee2020802070901w2e3f3896n51fa97acbf01683e@mail.gmail.com>
Subject: Re: [linux-dvb] How to force adaptor order when using 2 DVB cards?
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

John Drescher wrote:
> On Feb 7, 2008 11:46 AM, Eduard Huguet <eduardhc@gmail.com> wrote:
>> Hi,
>>     I currently have a media center computer set up using Gentoo 64 bit
>> and a Hauppauge Nova-T 500 card (dual DVB-T receiver). Now I'm trying to
>> add a new card (DVB-S), and here my problems begin: not mentioning the
>> experimental state of the driver (this is a different story that doesn't
>> matter now), my problem is that the new card porks the order in which
>> the device nodes were created in /dev. And even worse, the actual order
>> ing schema is different between a cold boot and rebooting:
>>
>> Cold boot:
>>   =B7 DVB:0: DVB-S tuner from Avermedia A700
>>   =B7 DVB:1,2: DVB-T tuners from Nova-T
>>
>> Reboot:
>>   =B7 DVB:0: 1st DVB-T tuner from Nova-T
>>   =B7 DVB:1: DVB-S tuner from A700
>>   =B7 DVB:2: 2nd DVB-T tuner from Nova-T
>>
>> I guess that on a cold boot the Nova-T 500 takes longer to initialize
>> (due to the firmware being loaded), so its adaptors gets both created
>> later.
>>
>> Is there any way to avoid this? My MythTV setup currently expects to
>> find the 2 Nova-T 500 adaptors on DVB:0 and DVB:1, and In expected the
>> new DVB-S adaptor to be created as DVB:2. However, it seems this is not
>> the case.
>>
>> Is there any way to force the numbering schema or the 2 adaptors?
> =

> Create a udev rule.
> =

> http://reactivated.net/writing_udev_rules.html
> =

> John
> =


no, this would be too lowlevel.
man modprobe.conf -> install.
y
tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
