Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pentafluge.infradead.org ([213.146.154.40])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+cb85485ae34f2f3dd4ef+1638+infradead.org+dwmw2@pentafluge.srs.infradead.org>)
	id 1JQpsq-0001OK-QQ
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 21:13:08 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: clive <clive@winpe.com>
In-Reply-To: <47B88314.3030405@winpe.com>
References: <47B88314.3030405@winpe.com>
Date: Sun, 17 Feb 2008 20:13:02 +0000
Message-Id: <1203279182.3011.11.camel@pmac.infradead.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB Radio
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


On Sun, 2008-02-17 at 18:55 +0000, clive wrote:
> Is there a way to determine which channels are radio channels from the
> channels.conf file?

Channels where the video PID is zero but the audio PID isn't:

grep '^[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:0:[^0:]*:[^:]*$' channels.conf

-- 
dwmw2


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
