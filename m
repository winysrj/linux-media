Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KYr43-0001zG-SS
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 01:38:08 +0200
Received: by nf-out-0910.google.com with SMTP id g13so168610nfb.11
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 16:38:04 -0700 (PDT)
Message-ID: <412bdbff0808281638h7e911b37n4d5043bf40b42d65@mail.gmail.com>
Date: Thu, 28 Aug 2008 19:38:04 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Thomas Goerke" <tom@goeng.com.au>
In-Reply-To: <007f01c90965$344da360$9ce8ea20$@com.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <004f01c90921$248fe2b0$6dafa810$@com.au>
	<412bdbff0808280824s288de72el297dda0556d6ca4d@mail.gmail.com>
	<007f01c90965$344da360$9ce8ea20$@com.au>
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

On Thu, Aug 28, 2008 at 7:24 PM, Thomas Goerke <tom@goeng.com.au> wrote:
> Devin,  I looked at the dmesg output and it showed no errors.  So I tested
> it again using both symbolic link and hard copy.  This time it worked
> correctly.  I am not sure what was causing the problem before but rolling
> back to the .10 definitely fixed it.  Apologies for the multicast on this
> but all seems ok now using the .20 firmware.

Hmmm...  You're the second person to see that behavior.  Weird.

Did you apply the patch I sent out for the driver as well, or did you
just replace the firmware file?

Devin


-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
