Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jighp-00021V-Ju
	for linux-dvb@linuxtv.org; Mon, 07 Apr 2008 04:03:38 +0200
Message-ID: <47F980D5.3030202@iki.fi>
Date: Mon, 07 Apr 2008 05:03:01 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: rvm <rvm3000@gmail.com>
References: <f474f5b70804021720i7926ea17q77b3ef551fb0841f@mail.gmail.com>	<47F44538.2090508@iki.fi>	<f474f5b70804051654h3ee0bdd5u6eb19db2ac626845@mail.gmail.com>	<47F90CA3.1090102@iki.fi>
	<f474f5b70804061846o66a3126aidcde58b4889b926c@mail.gmail.com>
In-Reply-To: <f474f5b70804061846o66a3126aidcde58b4889b926c@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle PCTV 71e
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

rvm wrote:
> 2008/4/6, Antti Palosaari <crope@iki.fi>:
>> rvm wrote:
>>
>>> But I was able to compile it in a kubuntu running in a virtual machine
>>> in windows. Yes, now it recognizes the usb stick, and more or less
>>> works. Kaffeine finds channels but then it only displays random lines
>>> instead of the image.
>>>
>>> With mplayer it's better, image is almost good, but it gets corrupted
>>> (blocks appear) very often, which doesn't happen in Windows.
>>>
>>> The main problem is that when mplayer is closed, the device doesn't
>>> work anymore. It's like the /dev/dvb/* had gone. Unplugin and plugin
>>> the stick doesn't fix the problem, it's necessary to reboot :(
>>>
>>  Can you test again. I did some updates and hopefully it will fix that last
>> problem.
> 
> Yes, that problem seems fixed. Thanks.

Thanks for testing.

> Still I'm getting the video (and audio) corrupted, could it be because
> of the firmware? I used this one:
> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw

No, it is no firmware issue. Firmware 4.95 is latest one and OK.

Can you say which tuner your device has? You can see that from 
message.log (dmesg). Please copy paste some lines.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
