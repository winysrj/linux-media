Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.228])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KPcMF-00023y-9a
	for linux-dvb@linuxtv.org; Sun, 03 Aug 2008 14:06:44 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1814937rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 03 Aug 2008 05:06:38 -0700 (PDT)
Message-ID: <d9def9db0808030506p5376b42ft73aa9df67b3ebf89@mail.gmail.com>
Date: Sun, 3 Aug 2008 14:06:37 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: mailgk@xs4all.nl
In-Reply-To: <1217763477.3847.14.camel@gk-sem3.gkall.nl>
MIME-Version: 1.0
Content-Disposition: inline
References: <1217763477.3847.14.camel@gk-sem3.gkall.nl>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Pinnacle pctv hybrid pro stick 340e support
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

On Sun, Aug 3, 2008 at 1:37 PM, Gerard <mailgk@xs4all.nl> wrote:
> Hello,
>
> Just bought and searched for support for the Pinnacle pctv hybrid pro
> stick 340e, not found.
>
> I have placed the lsusb -v output on
> http://www.gkall.nl/pinnacle-pctv-hybrid-pro-stick-340e.html
>
> information is in pinnacle-pctv-hybrid-pro-stick-340e.txt
>
>
> output from kernel.log
>
> Aug  2 16:48:25 gk-sem3 kernel: [26398.325169] usb 2-3: new high speed
> USB device using ehci_hcd and address 7
> Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: configuration #1
> chosen from 1 choice
> Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: New USB device
> found, idVendor=2304, idProduct=023d
> Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: New USB device
> strings: Mfr=1, Product=2, SerialNumber=3
> Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: Product: PCTV
> 340e
> Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: Manufacturer:
> YUANRD
> Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: SerialNumber:
> 060096D0F0
>
> I can do some test, intention is to get it working on a acer aspire one
> netbook.
>
> According to an other lsusb -v output it could be a dibcom chip??
>
> Question is if there is already some driver information?
>

Manufacturer: YUANRD

this might give a further hint (according to your logfiles), guess
it's something like Yuan Research and Development

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
