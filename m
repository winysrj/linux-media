Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns218.ovh.net ([213.186.34.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <webdev@chaosmedia.org>) id 1JszAd-00061b-Ea
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 13:47:51 +0200
Message-ID: <481EF3C5.3060308@chaosmedia.org>
Date: Mon, 05 May 2008 13:47:17 +0200
From: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <481EBD4D.1070905@chaosmedia.org>
	<200805051300.09840.christophpfister@gmail.com>
In-Reply-To: <200805051300.09840.christophpfister@gmail.com>
Subject: Re: [linux-dvb] libdvbapi multiproto patch ?
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



Christoph Pfister wrote:
> No. Only libdvben50221 + the ca part of libdvbapi are used.
>   
>
okay thx, what's libdvben50221 compared to libdvbapi ? Are those two 
libs only used for CAM purposes ?

Anyways, i've checked DvbStream::tuneDvb and seen it uses the frontend 
declarations directly.
Good thing if i don't have to mess with a lib in the middle..

I'll see if i can manage to use some fancy macros and keep ifdef out of 
the main code.

thx
Marc

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
