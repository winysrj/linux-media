Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp108.rog.mail.re2.yahoo.com ([68.142.225.206])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <cityk@rogers.com>) id 1L4TC3-0006r7-RO
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 05:37:05 +0100
Message-ID: <492A2F4B.2050407@rogers.com>
Date: Sun, 23 Nov 2008 23:36:27 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <20081115234054.0cc58cbb@symphony> <49206686.1080209@rogers.com>
	<49271C77.6090009@gmail.com>
In-Reply-To: <49271C77.6090009@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] SAA7162 status
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

Manu Abraham wrote:
> The SAA716x driver is supposed to support the following PCIe chips
>
> SAA7160
> SAA7161
> SAA7162
>
> The SAA716x development repository is at http://jusst.de/hg/saa716x
> It is quite a work in progress, as of now. There are also some DVB-S2
> cards based on the SAA7160.
>   

Thanks for the update Manu. 

> Also, the SAA7164 chip is not supported by the SAA716x driver as it is a
> completely different chip altogether.
>   

Yep, includes MPEG encoder ... I just couldn't remember, from prior
conversations, whether the above driver could be extended to cover the
7164 as well, or whether it was a different matter altogether.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
