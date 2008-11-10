Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nschwmtas01p.mx.bigpond.com ([61.9.189.137])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jhhummel@bigpond.com>) id 1KzKyf-0000OH-Iz
	for linux-dvb@linuxtv.org; Mon, 10 Nov 2008 01:50:02 +0100
Received: from nschwotgx01p.mx.bigpond.com ([58.173.115.237])
	by nschwmtas01p.mx.bigpond.com with ESMTP id
	<20081110004918.YEIH23566.nschwmtas01p.mx.bigpond.com@nschwotgx01p.mx.bigpond.com>
	for <linux-dvb@linuxtv.org>; Mon, 10 Nov 2008 00:49:18 +0000
Received: from harriet.localdomain ([58.173.115.237])
	by nschwotgx01p.mx.bigpond.com with ESMTP id
	<20081110004917.RJXO15831.nschwotgx01p.mx.bigpond.com@harriet.localdomain>
	for <linux-dvb@linuxtv.org>; Mon, 10 Nov 2008 00:49:17 +0000
From: Jonathan <jhhummel@bigpond.com>
To: linux-dvb@linuxtv.org
Date: Mon, 10 Nov 2008 11:49:17 +1100
References: <200811091437.13920.plr.vincent@gmail.com>
In-Reply-To: <200811091437.13920.plr.vincent@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811101149.17244.jhhummel@bigpond.com>
Subject: Re: [linux-dvb] [PATCH] WinFast DTV2000 H: add support for missing
	analog inputs
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

THAT'S GREAT VINCENT!!!!

Just out of interest, does anyone know how long it takes these to flow through 
to distributions such as Ubuntu?

Thanks

Jon

On Mon, 10 Nov 2008 12:37:13 am Vincent Pelletier wrote:
> WinFast DTV2000 H: add support for missing analog inputs
>
> From: Vincent Pelletier <plr.vincent@gmail.com>
>
> Add support for the following inputs:
>  - radio tuner
>  - composite 1 & 2 (only 1 is physically available, but composite 2 is also
>    advertised by windows driver)
>  - svideo
>
> Signed-off-by: Vincent Pelletier <plr.vincent@gmail.com>
>
> ---
>
> GPIO values retrieved using RegSpy under Windows XP with vendor's driver &
> software.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
