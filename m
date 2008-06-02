Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.dnainternet.fi ([87.94.96.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K38cF-0005E0-4M
	for linux-dvb@linuxtv.org; Mon, 02 Jun 2008 13:54:21 +0200
Message-ID: <4843DF46.6080605@iki.fi>
Date: Mon, 02 Jun 2008 14:53:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Robert Sturrock <rns@unimelb.edu.au>
References: <20080602040632.GI4833@unimelb.edu.au>
In-Reply-To: <20080602040632.GI4833@unimelb.edu.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Leadtek Winfast Gold USB Dongle - USB id 0x6029?
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

Robert Sturrock wrote:
> Hi All.
> 
> I recently acquired a Leadtek Winfast Gold USB Dongle, which unfortunately
> does not seem to be recognised at present.  I think this may have been
> mentioned in a couple of other threads:
> 
>     http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024330.html    
>     http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024931.html
> 
> However, the one I have seems to come up with a USB-id of 6029 (maybe
> this is a particular Australian variant as the other threads mention an
> id of 6f01, not sure).

This is AF9015 reference design based. It will work this driver:
http://linuxtv.org/hg/~anttip/af9015-mxl500x-copy-fw/

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
