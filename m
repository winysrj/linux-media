Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1Jfqci-0007cn-Do
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 08:02:39 +0200
Received: by yw-out-2324.google.com with SMTP id 5so112814ywh.41
	for <linux-dvb@linuxtv.org>; Sat, 29 Mar 2008 23:02:27 -0700 (PDT)
Message-ID: <37219a840803292302m191ea890nfefc51135706b017@mail.gmail.com>
Date: Sun, 30 Mar 2008 02:02:27 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Janne Grunau" <janne-dvb@grunau.be>
In-Reply-To: <200803292240.25719.janne-dvb@grunau.be>
MIME-Version: 1.0
Content-Disposition: inline
References: <200803292240.25719.janne-dvb@grunau.be>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to choose
	dvb adapter numbers, second try
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

2008/3/29 Janne Grunau <janne-dvb@grunau.be>:
> Hi,
>
>  I resubmit this patch since I still think it is a good idea to the this
>  driver option. There is still no udev recipe to guaranty stable dvb
>  adapter numbers. I've tried to come up with some rules but it's tricky
>  due to the multiple device nodes in a subdirectory. I won't claim that
>  it is impossible to get udev to assign driver or hardware specific
>  stable dvb adapter numbers but I think this patch is easier and more
>  clean than a udev based solution.
>
>  I'll drop this patch if a simple udev solution is found in a reasonable
>  amount of time. But if there is no I would like to see the attached
>  patch merged.
>
>  Quoting myself for a short desciprtion for the patch:
>
>  > V4L drivers have the {radio|vbi|video}_nr module options to allocate
>  > static minor numbers per driver.
>  >
>  > Attached patch adds a similiar mechanism to the dvb subsystem. To
>  > avoid problems with device unplugging and repluging each driver holds
>  > a DVB_MAX_ADAPTER long array of the preffered order of adapter
>  > numbers.
>  >
>  > options dvb-usb-dib0700 adapter_nr=7,6,5,4,3,2,1,0 would result in a
>  > reversed allocation of adapter numbers.
>  >
>  > With adapter_nr=2,5 it tries first to get adapter number 2 and 5. If
>  > both are already in use it will allocate the lowest free adapter
>  > number.

Personally, I would love to see this merged -- I hope that others will
agree with me.

One critique:

videobuf-dvb is more of a central helper module.  I believe that the
module option should live in the callers of videobuf-dvb (such as
cx88-dvb / saa7134-dvb / cx23885-dvb) rather than within the
videobuf-dvb module, itself.  The array can be passed into
videobuf-dvb the same as was done with dvb-usb-dvb.c

Other than that, I think that this feature would be a valuable
addition to the DVB subsystem.

-Mike Krufky

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
