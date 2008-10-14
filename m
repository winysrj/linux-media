Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Kpld6-0006Oc-Do
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 17:16:13 +0200
Message-ID: <48F4B7B7.4080107@iki.fi>
Date: Tue, 14 Oct 2008 18:16:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jelle de Jong <jelledejong@powercraft.nl>
References: <48F48920.1000206@powercraft.nl>
	<48F48F67.2020802@powercraft.nl>	<48F4A5D9.7010701@powercraft.nl>
	<48F4B25B.9070109@iki.fi> <48F4B576.8010509@powercraft.nl>
In-Reply-To: <48F4B576.8010509@powercraft.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Afatech DVB-T - Installation Guide - v0.1.1j (not
 working)
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

Jelle de Jong wrote:
> Antti Palosaari wrote:
>> hello Jelle,
>> sorry for top-posting...
>>
>> Error from attached file:
>>
>> [   57.163981] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
>> [   57.277990] af9015: command failed:2
>> [   57.278001] mt2060 I2C read failed
>>
>> goes to the fact that I2C-communication towards tuner is behind I2C-gate 
>> of the AF9015/AF9013. MT2060 you use does not have I2C-gate implemented. 
>> Use newer MT2060 module for correct functionality.
>>
>> See for more information:
>> http://palosaari.fi/linux/v4l-dvb/controlling_tuner.txt
>> http://palosaari.fi/linux/v4l-dvb/controlling_tuner_af9015_dual_demod.txt
>>
>> reagrds
>> Antti
> 
> Thanks for the information, since one of my specializations is embedded
> hardware development, I do understand the presented issues.
> 
> Should there not be an option to the MT2060 module to use the I2C-gate
> or not? What can I do to get this device working now?

There is no option for I2C-gate, gate will be called every time when 
access to tuner is needed. If you already use MT2060 coming with AF9015 
driver it should work. I doubt that you are mixing em2880 driver and 
af9015 and wrong tuner driver is coming from em2880. But I am not sure. 
Could you make clean install to see whether or not it is working.

hg clone http://linuxtv.org/hg/v4l-dvb/
make
make install (root privileges)
replug stick
reboot
plug stick

It should work (hopefully)

reagrds
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
