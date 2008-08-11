Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1KSV0h-0007Fs-M0
	for linux-dvb@linuxtv.org; Mon, 11 Aug 2008 12:52:27 +0200
Received: by fg-out-1718.google.com with SMTP id e21so950928fga.25
	for <linux-dvb@linuxtv.org>; Mon, 11 Aug 2008 03:52:20 -0700 (PDT)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Mon, 11 Aug 2008 12:52:16 +0200
References: <489C16EF.5030004@siriushk.com> <489D4D5D.2020700@siriushk.com>
	<489F2C4A.4070908@linuxtv.org>
In-Reply-To: <489F2C4A.4070908@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808111252.17061.christophpfister@gmail.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Support for Magic-Pro DMB-TH usb stick
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

Hi Mike,

Am Sonntag 10 August 2008 19:58:34 schrieb Michael Krufky:
<snip>
> Timothy,
>
> I've applied your patch to my cxusb tree, with slight modifications, in
> order to coincide with another patch to the same code.  Please test the
> tree and confirm proper operation before I request a merge into the
> master branch.
>
> http://linuxtv.org/hg/~mkrufky/cxusb
>
> I'll push the Hong Kong scan file to dvb-apps after this tree is merged
> into the master branch.

I didn't really follow the discussion (sorry), but I think if the device 
presents itself as a dvb-t device and is usable as a (pseudo-)dvb-t device 
(tune / scan / watch), the scan file should be in the dvb-t. And in this case 
please change "fec_lo" to "NONE" when you're committing.

> If you have any additional fixes / changes to make before this is merged
> into master, please generate them against this cxusb tree.
>
> Regards,
>
> Mike

Thanks,

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
