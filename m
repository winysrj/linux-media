Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <481B26E2.1050600@web.de>
Date: Fri, 02 May 2008 16:36:18 +0200
From: Torben Viets <viets@web.de>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <4815B2A9.4060209@web.de> <4815F0AF.4010709@linuxtv.org>
	<4815FA2B.5030502@web.de> <4815FF67.6050004@linuxtv.org>
	<4816050D.2040408@web.de> <48161163.9000602@linuxtv.org>
	<4816186B.3030703@web.de> <48161B2D.6090602@linuxtv.org>
	<48176236.1020306@web.de> <481763AA.4030702@linuxtv.org>
	<481767E4.8030608@web.de> <48176969.6070306@linuxtv.org>
	<4817935E.8090801@web.de> <4817ACDA.1010105@web.de>
	<4817BD7F.9000902@linuxtv.org>
In-Reply-To: <4817BD7F.9000902@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1700 Support
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

Steven Toth wrote:
>
>> Hey, I've update, now the dvb works with 2.6.25 ant the v4l-dvb hg, I 
>> was sure that I already tried this combinations...
>
> Good, because it's working for various other peopple too.
>
>>
>> Now, only the analog input have to work (this was the main reason I 
>> bought this card), is it really so hard, because I
>> saw that the HVR-1600 and the HVR-1800 is supported.
>
>
> lol, after all this traffic, bad news for you because analog doesn't 
> work - it never has.
>
> - Steve
>

yes, but better I've got DVB-T , than nothing, but the main reason was 
the analog Mpeg encoder and I thought HVR-1700 and HVR-1800 have the 
same chipset (cx23817). That's why I'm thought it should work. If I make 
a modprobe cx23885 card=2 (this is the Cardid for HVR-1800), I've got 
video0 and video1, but I 'don't know whether it doesn't work or don't 
know which program I've to use. But after your comments I think it is 
useless.

greetings
Torben

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
