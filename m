Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1KEgcI-0005NC-O9
	for linux-dvb@linuxtv.org; Fri, 04 Jul 2008 10:26:09 +0200
Received: from [134.32.30.103] (milan-ofs-a103.milan.oilfield.slb.com
	[134.32.30.103])
	by mail.youplala.net (Postfix) with ESMTP id 1B522D880A7
	for <linux-dvb@linuxtv.org>; Fri,  4 Jul 2008 10:24:43 +0200 (CEST)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <486D9AE8.1030205@internode.on.net>
References: <C74607610AB6D64794BA3820A9567DA705A6C81A@sbscpex06.corp.riotinto.org>
	<486D9AE8.1030205@internode.on.net>
Date: Fri, 04 Jul 2008 09:24:37 +0100
Message-Id: <1215159877.7545.3.camel@acropora>
Mime-Version: 1.0
Subject: Re: [linux-dvb] dvb_usb_dib0700 tuning problems?
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

On Fri, 2008-07-04 at 13:07 +0930, Ian W Roberts wrote:
> Just maybe you'll need to re-compile drivers (although maybe not
> given 
> it's working for one channel). I had to on gutsy and heron.

I would still recommend to use a recent tree for such boards, even when
using 8.04. There has been some nice improvements in the code since
then.

http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500

If you do not want to have to compile the modules at each kernel change
introducing an ABI bump, I would use this, as I do with great pleasure:

http://www.youplala.net/linux/home-theater-pc#toc-automatic-drivers-compilation-of-a-recent-v4l-dvb-tree

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
