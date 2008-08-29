Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KYsin-00081P-Qg
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 03:24:18 +0200
Received: by ik-out-1112.google.com with SMTP id c21so398648ika.1
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 18:24:14 -0700 (PDT)
Message-ID: <412bdbff0808281824o72c6668ieb43aa3f678ef09e@mail.gmail.com>
Date: Thu, 28 Aug 2008 21:24:14 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Thomas Goerke" <tom@goeng.com.au>
In-Reply-To: <008101c90971$ca7e5080$5f7af180$@com.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <004f01c90921$248fe2b0$6dafa810$@com.au>
	<412bdbff0808280824s288de72el297dda0556d6ca4d@mail.gmail.com>
	<007f01c90965$344da360$9ce8ea20$@com.au>
	<412bdbff0808281638h7e911b37n4d5043bf40b42d65@mail.gmail.com>
	<008001c9096a$f315df10$d9419d30$@com.au>
	<412bdbff0808281731t7641e4d1kf86058e071c7d5fb@mail.gmail.com>
	<008101c90971$ca7e5080$5f7af180$@com.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge WinTV-NOVA-T-500 New Firmware
	(dvb-usb-dib0700-1.20.fw) causes problems
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

On Thu, Aug 28, 2008 at 8:54 PM, Thomas Goerke <tom@goeng.com.au> wrote:
> I have applied the latest patch, swapped back to the .20firmware and now get
> the following output from dmesg:
<snip>

Ok, so it looks like there are i2c errors accessing the dib3000 and
mt2060.  That's bad, but at least it's exercising the new code.

Let me look at the code and see what I can find out.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
