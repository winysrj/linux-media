Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from router.whitecitadel.com ([82.68.182.134]
	helo=mail.whitecitadel.com) by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <Paul@WhiteCitadel.com>) id 1LKJCv-0004ft-92
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 22:11:26 +0100
In-Reply-To: <200901060337.29267.nsoranzo@tiscali.it>
References: <200901060337.29267.nsoranzo@tiscali.it>
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <0D5452B4-72F4-4EDA-9C29-1F2D37988823@WhiteCitadel.com>
From: Paul <Paul@WhiteCitadel.com>
Date: Tue, 6 Jan 2009 21:11:18 +0000
To: Nicola Soranzo <nsoranzo@tiscali.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Re: Compile error,
	bug in compat.h with kernel 2.6.27.9 ?
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


On 6 Jan 2009, at 02:37, Nicola Soranzo wrote:

> Fix compile error about ioremap_nocache with kernel 2.6.27.9  
> shipped by Fedora
> 10.
>
> Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>
>
> <snip>

Many thanks, can confirm this resolved the issue with  
2.6.27.9-159.fc10.x86_64 Fedora kernel.
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
