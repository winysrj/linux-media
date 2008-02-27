Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JUVCc-0002Wy-Ky
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 23:56:42 +0100
Message-ID: <47C5EA9B.3020308@gmail.com>
Date: Thu, 28 Feb 2008 02:56:27 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Zaheer Merali <zaheermerali@gmail.com>
References: <1204046724.994.21.camel@amd64.pyotr.org>
	<15e616860802270339s25938affsfede0f985111ee5f@mail.gmail.com>
In-Reply-To: <15e616860802270339s25938affsfede0f985111ee5f@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] DMX_OUT_TSDEMUX_TAP: record two
 streams	from same mux
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

Zaheer Merali wrote:

> So we don't take the whole multiplex into userspace, just the pids we
> need on an as needed basis.

Though this will work for FTA streams, it won't work for scrambled streams.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
