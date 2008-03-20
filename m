Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1Jc8GE-0007xk-WA
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 01:04:01 +0100
Received: by wr-out-0506.google.com with SMTP id c30so676691wra.14
	for <linux-dvb@linuxtv.org>; Wed, 19 Mar 2008 17:03:50 -0700 (PDT)
Message-ID: <d9def9db0803191703i7ae2af9dje793216ce729a124@mail.gmail.com>
Date: Thu, 20 Mar 2008 01:03:49 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Matthijs De Smedt" <matthijs@orfu.net>
In-Reply-To: <e45d04010803191531g119753d5n22accf13e1b4b096@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <e45d04010803190957k5dc862aeod3fed3cf5848e8fa@mail.gmail.com>
	<e2d627830803191424v36a4ffacxe629f49b8490b28d@mail.gmail.com>
	<e45d04010803191531g119753d5n22accf13e1b4b096@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy CI USB
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

On 3/19/08, Matthijs De Smedt <matthijs@orfu.net> wrote:
> Hello Derk,
>
> Thanks for the interesting information. I've looked at the
> specification. It's very comprehensive concerning the implementation
> of CI, but does not contain anything about the USB2CI device itself.
> Also, this thing is complicated.
>
> I have no idea how to reverse engineer the BDA driver. I have no
> experience with reverse engineering nor the technologies used here. If
> nobody wants to work on this I might give it a shot, but without specs
> I doubt I'll get very far.
>

You can find some small hints at:
* http://mcentral.de/wiki/index.php5/USBVideo
* http://mcentral.de/wiki/index.php5/Usbreplay

back then I used it for reversing some Isochronous and usb control
message driven devices, bulk aren't really verified with it. I'm sure
you can get some ideas from it.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
