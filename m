Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vps1.tull.net ([66.180.172.116])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <nick@tull.net>) id 1LmQmQ-0004YM-2Y
	for linux-dvb@linuxtv.org; Wed, 25 Mar 2009 11:56:19 +0100
Date: Wed, 25 Mar 2009 21:55:00 +1100
From: Nick Andrew <nick-linuxtv@nick-andrew.net>
To: damien benoist <damien_benoist@yahoo.com>
Message-ID: <20090325105500.GA15523@mail.local.tull.net>
References: <399594.31785.qm@web50512.mail.re2.yahoo.com>
	<445861.72728.qm@web24402.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <445861.72728.qm@web24402.mail.ird.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] xine interupts (buffering) after kernel upgrade
Reply-To: linux-media@vger.kernel.org
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

G'day Damien,

On Mon, Mar 23, 2009 at 05:55:57PM +0000, damien benoist wrote:
> My tuner is: "lifeview TV Walker Swift SE"
> It's been working without problems for about 2 years now
> with different kernels.

What's the output from "lsusb -v" ?

> It works well with kernel 2.6.26.2.
> I have the following problem with kernel 2.6.28.8:
> (I've had it with some other 2.6.28.x and if I remember well with
> some 2.6.27.x)

I think you'll need to narrow the target down to within 1 kernel
revision.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
