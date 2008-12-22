Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout-xforward.kundenserver.de ([212.227.17.6])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <holger+linux-dvb@rusch.name>) id 1LEfO2-00057H-BB
	for linux-dvb@linuxtv.org; Mon, 22 Dec 2008 08:39:36 +0100
Message-ID: <494F4415.9070008@rusch.name>
Date: Mon, 22 Dec 2008 08:39:01 +0100
From: Holger Rusch <holger+linux-dvb@rusch.name>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
References: <cae4ceb0812091511s668dcc5fj793e7efc113fedfd@mail.gmail.com>	<493F8A81.7040802@rusch.name>
	<494E61B4.2040006@rusch.name>	<412bdbff0812210831w2c8930eal5181c766857b0aa8@mail.gmail.com>	<494E8B97.7030608@rusch.name>
	<412bdbff0812211152g147aa755xc100988a01a70f5@mail.gmail.com>
In-Reply-To: <412bdbff0812211152g147aa755xc100988a01a70f5@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy DT USB XS Diversity (Quality with
 linux worse then with Windows)
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

Hi Devin & All,

Devin Heitmueller schrieb:
> Ok, so you've got the latest code and firmware (there is only one
> version of the 1.20 firmware).  And we know it's not the LNA then.

Well, at least something. :)

> You said the SNR is < 45%, but as far as I can see the SNR function
> isn't implemented on the dib7000p or the dib7000m, so it should always
> be zero.  Are you sure you weren't referring to strength?  Also, what
> application are you using to watch the stream?

Yes, SNR is zero all the time. I am revering to the first "bar" signal 
strength. Its between 41 and 44 on all my channels.

I rerouted my antenna cable (it was close to an ups and other devices), 
but the strength didnt change. The bar was close to red in femon.

I made some recordings and watched one of them. NO missed frames or 
distortions this time.

But I never had any in Windows and i got them often with v4l.

Iam usind vdr to record and vlc on windows to watch the 00x.vdr files 
directly.

Maschine is a 2GB RAM, CPU AMD 4850, setup which idles most the time.

Thanks for any further tips.

-- 
+ Contact? => http://site.rusch.name/ +

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
