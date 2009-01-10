Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx03.syneticon.net ([78.111.66.105])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mangoo@wpkg.org>) id 1LLc5A-00032J-Nj
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 12:32:49 +0100
Message-ID: <49688743.70605@wpkg.org>
Date: Sat, 10 Jan 2009 12:32:19 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: thomas.schorpp@gmail.com
References: <4963A330.3090903@wpkg.org>	<4963B4AF.3040301@gmail.com>	<4965D821.4090304@wpkg.org>	<496881DD.2080405@wpkg.org>
	<49688623.7030901@gmail.com>
In-Reply-To: <49688623.7030901@gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] random "no frontend was attached"
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

thomas schorpp schrieb:

>>> Did it work for you properly with earlier kernels?
>> I noticed that after I do (without device unplugging/replugging):
>>
>> # rmmod dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common ehci_hcd
>>
>> # modprobe -a dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common ehci_hcd
>>
>>
>> it is detected properly _always_.
>>
>> ?
>>
> 
> no.

With what earlier kernels does it for you?


-- 
Tomasz Chmielewski
http://wpkg.org

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
