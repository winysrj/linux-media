Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KQ1AC-0008He-AK
	for linux-dvb@linuxtv.org; Mon, 04 Aug 2008 16:35:57 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K52009FYZ6W5G90@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 04 Aug 2008 10:35:21 -0400 (EDT)
Date: Mon, 04 Aug 2008 10:35:20 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080804113406.44F511BF28D@ws1-1.us4.outblaze.com>
To: stev391@email.com
Message-id: <489713A8.9080007@linuxtv.org>
MIME-version: 1.0
References: <20080804113406.44F511BF28D@ws1-1.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
 H - DVB Only support
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

>      case CX23885_BOARD_HAUPPAUGE_HVR1800:
>      case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
>      case CX23885_BOARD_HAUPPAUGE_HVR1700:
> +    case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
>          request_module("cx25840");
>          break;
>      }

Steve, thanks for look at this.

I took a quick look at your patch. Obviously the callback stuff you're 
planning to re-work will be based Antons patch, which I plan to push 
tonight after more testing.... So I'm ignoring this.

Minor nitpick... Don't request module cx25840 above unless you plan to 
use it. If you are planning to add analog support, make this a second 
patch after the digital stuff gets merged.

Other than that, it will be great to have another product supported in 
the tree.

Regards,

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
