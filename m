Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KXe1d-00027z-49
	for linux-dvb@linuxtv.org; Mon, 25 Aug 2008 17:30:39 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1709052rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 25 Aug 2008 08:30:31 -0700 (PDT)
Message-ID: <d9def9db0808250830m5aa2d59at2c7bb3788d075e60@mail.gmail.com>
Date: Mon, 25 Aug 2008 17:30:31 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Robin Perkins" <robin.perkins@internode.on.net>
In-Reply-To: <E8C49B92-E40C-499D-9362-923C3A3A1F9A@internode.on.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <E8C49B92-E40C-499D-9362-923C3A3A1F9A@internode.on.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Reverse enginnering using i2c protocol analysers
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

2008/8/23 Robin Perkins <robin.perkins@internode.on.net>:
> Does anyone have any experiences using i2c logic analysers to work out how
> cards work ?
> Is it an effective reverse enginering method ?

not everything is usually bound to i2c..

there are Virtualization methods available nowadays for PCI
passthrough (Intel has one, AMD I'm not sure about the status). As
soon as that is mainstream it will make reverse engineering easier..
Another interesting thing would be drivers could directly be used out
from a operating system which is jailed in a virtual machine.

Qemu has support for PCI passthrough with appropriate patches,
although the host will get killed as soon as DMA gets set up.

USB can easily be captured with usbsnoop.

Markus

> I was looking for them online but most of them seem pretty expensive
> (~$4000) however I found the Total Phase Beagle for about $300. Has anyone
> else tried this adapter out ? (It appears to have software for Linux, OS X
> and Windows which seems pretty good.)
> Thanks,
> Rob
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
