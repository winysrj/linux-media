Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns218.ovh.net ([213.186.34.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <webdev@chaosmedia.org>) id 1JzpGc-0002Ag-R3
	for linux-dvb@linuxtv.org; Sat, 24 May 2008 10:38:19 +0200
Message-ID: <4837D3CE.403@chaosmedia.org>
Date: Sat, 24 May 2008 10:37:34 +0200
From: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4836DBC1.5000608@gmail.com>
	<4836E28B.5000405@linuxtv.org>	<4836E4E3.70405@gmail.com>	<854d46170805230936n4b48ae3dy50fb86780eded5d4@mail.gmail.com>
	<20080523205819.6eafe5fa@bk.ru>
In-Reply-To: <20080523205819.6eafe5fa@bk.ru>
Subject: Re: [linux-dvb] [multiproto patch] add support for using multiproto
 drivers with old api
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



Goga777 wrote:
>>>
>> Thank you so much :)
>> I can't believe I'm watching tv in kaffeine with my multiproto card.
>>     
>
> what about dvb-s2 channels on your kaffeine ? how can you watch their ?
>
>   
i've got a kaffeine multiproto patch coming soon, it should fully 
support multiproto api but has been only tested on dvb-s/s2 with my 
cards dvbs fullfeatured and budget dvb-s2

dvb-s2 chans are working fine, other problems are h264 HD / xine / 
ffh264 related, i'm on 64 bit.

i'll have to test my patch against that new multiproto patch and i'll 
probably post my kaffeine patch on kaffeine forum later next week.. Or 
somewhere else if kaffeine guys don't want to see multiproto content 
there as i know they won't support multiproto..

the patch is supposed to be v4l-dvb / multiproto compatible so you don't 
need two different versions of kaffeine if you're switching api versions..

Later

Marc

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
