Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from einhorn.in-berlin.de ([192.109.42.8] ident=root)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stefan@lucke.in-berlin.de>) id 1KKdXa-0004vL-7p
	for linux-dvb@linuxtv.org; Sun, 20 Jul 2008 20:21:50 +0200
Received: from jarada.farpoint.de (p57BB4CCE.dip.t-dialin.net [87.187.76.206])
	(authenticated bits=0)
	by einhorn.in-berlin.de (8.13.6/8.13.6/Debian-1) with ESMTP id
	m6KILgQ0007170
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-dvb@linuxtv.org>; Sun, 20 Jul 2008 20:21:42 +0200
From: Stefan Lucke <stefan@lucke.in-berlin.de>
To: linux-dvb@linuxtv.org
Date: Sun, 20 Jul 2008 20:21:40 +0200
References: <0202365bcadaf441ee4f74d6fe6f315a@81.116.196.113>
In-Reply-To: <0202365bcadaf441ee4f74d6fe6f315a@81.116.196.113>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807202021.41130.stefan@lucke.in-berlin.de>
Subject: Re: [linux-dvb] win TV Nova T hauppauge on eeepc 701
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

On Friday 18 July 2008, - Aladar65 - wrote:
> someone has never installed the win TV Nova T hauppauge on eeepc 701 with
> xandros?

If you are talking about the small usb device with usbid 2040:7070 , the
answer is yes.

If you are trying to get it run with vdr package shiped from asus you'll
need some additional kernel modules and some binary editing of vdr
with khexedit (changing from asus usb ids to hauppauge usbids).


-- 
Stefan Lucke

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
