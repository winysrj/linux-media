Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1Kd3XI-0004ix-DU
	for linux-dvb@linuxtv.org; Tue, 09 Sep 2008 15:45:41 +0200
Received: by yw-out-2324.google.com with SMTP id 3so213675ywj.41
	for <linux-dvb@linuxtv.org>; Tue, 09 Sep 2008 06:45:35 -0700 (PDT)
Message-ID: <854d46170809090645k56f0befgda4dcee489a15128@mail.gmail.com>
Date: Tue, 9 Sep 2008 15:45:33 +0200
From: "Faruk A" <fa@elwak.com>
To: "Renaud Pagin" <renaud.pagin@gmail.com>
In-Reply-To: <ed53dcb30809090533p7b951fb6s9699a3eab9e3545b@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <ed53dcb30809090533p7b951fb6s9699a3eab9e3545b@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT connect S3650 working set ?
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

Hi!

This drivers doesn't work with the latest multiproto and kernel ( 2.6.26/27).
you need to download multiproto changeset 9036 ->
http://jusst.de/hg/multiproto/archive/fbcc9fa65f56.tar.bz2
and apply the patch from wiki, that patch includes all the patch
posted here on this mailing list.
It should work with kernel 2.6.24 and 25, i have test with kernel
2.6.26 dvb-usb and dvb-usb-pctv452e is broken.

For me it was working perfectly fine before my vacation when i came
back i did system upgrade, it upgdrade
every software to the latest including the kernel but i rollback to
kernel 2.6.25-4 thats what i had before. The card is working but
the weird thing is there are packet losses from the TS similar to the
first version of this driver when it was first posted.

Cheers
Faruk

> Hello,
>
> Since more then 2 days i try to get working this device.
>
> I followed the linux wiki ( S3650 ) , misc message on the ML , plenty patchs
> found here and there.
>
> And i have not found any solution working so far.
>
> Where i can find the last patch working with the last head mercurial of
> multiproto ?
>
> Thanks !
>
> Best regards

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
