Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from scing.com ([217.160.110.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1Kiab2-0001cP-Vv
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 22:04:25 +0200
From: Janne Grunau <janne-dvb@grunau.be>
To: linux-dvb@linuxtv.org
Date: Wed, 24 Sep 2008 22:04:09 +0200
References: <953A45C4-975B-4A05-8B41-AE8A486D0CA6@ginandtonic.no>
	<8C08530B-BAD7-4E83-B1CA-6AB66EE9F53F@ginandtonic.no>
	<7674.1222283382@kewl.org>
In-Reply-To: <7674.1222283382@kewl.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809242204.09153.janne-dvb@grunau.be>
Subject: Re: [linux-dvb] HVR-4000 and analogue tv
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

On Wednesday 24 September 2008 21:09:42 Darron Broad wrote:
> The problem in mythtv appears to be in OpenV4L2DeviceAsInput(void)
> where is opens the video device twice although I have no confirmed
> it.

If that's the case and the tvtime && cat test supports it it's more a 
driver issue than an issue in mythtv. Using different fd for 
controlling (ioctl) and data transfer (read) is fine and works with 
other drivers.

Janne

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
