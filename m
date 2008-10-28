Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KuklC-0007JD-8H
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 10:21:10 +0100
Message-ID: <4906D97D.5050603@gmail.com>
Date: Tue, 28 Oct 2008 13:21:01 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: oleg roitburd <oroitburd@gmail.com>
References: <48F525CD.70801@gmail.com>	
	<20081015224128.5320eaee@pedra.chehab.org>	
	<4900CB6B.4010005@linuxtv.org>	
	<b42fca4d0810280113q6045f284v167ab234367d8a97@mail.gmail.com>	
	<4906D19B.7080800@gmail.com>
	<b42fca4d0810280207s54d6a81er691d2ea58d2d04a3@mail.gmail.com>
In-Reply-To: <b42fca4d0810280207s54d6a81er691d2ea58d2d04a3@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] STB0899 update (TT S2 3200)
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

oleg roitburd wrote:
> 2008/10/28 Manu Abraham <abraham.manu@gmail.com>:
>> oleg roitburd wrote:
>>
>>> I have tried driver from v4l-dvb tree ( http://linuxtv.org/hg/v4l-dvb/
>>> , changeset 9471      8486cbf6af4e)
>>> Driver is not working. Thank you Manu. I hope you have this card and
>>> tried your driver before you make PULL request.
>> People have reported success. Care to state what doesn't work ?
>>
> 
> I have tried with scan-s2 (http://mercurial.intuxication.org/hg/scan-s2/)
> It has tuned only one transponder on Astra 19.2. All other failed
> (HotBird 13E, Sirius 5E)
> 
> ./scan-s2 -o vdr -t 3 dvb-s/Astra-19.2E > ../channels.conf-19.2E
> API major 5, minor 0
> scanning dvb-s/Astra-19.2E
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 12551500 V 22000000 22000000
> ----------------------------------> Using DVB-S
>>>> tune to: 12551:vS0C56:S0.0W:22000:
> DVB-S IF freq is 1951500
> WARNING: >>> tuning failed!!!

Please try again from http://jusst.de/hg/v4l-dvb

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
