Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JdlRQ-0006Da-SW
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 13:06:17 +0100
Received: by rn-out-0910.google.com with SMTP id e11so1066793rng.17
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 05:06:11 -0700 (PDT)
Message-ID: <8ad9209c0803240506m7197831bwa8ffc588ec655a4@mail.gmail.com>
Date: Mon, 24 Mar 2008 13:06:11 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1206348478.6370.27.camel@youkaida>
MIME-Version: 1.0
Content-Disposition: inline
References: <1206139910.12138.34.camel@youkaida> <1206185051.22131.5.camel@tux>
	<1206190455.6285.20.camel@youkaida> <1206270834.4521.11.camel@shuttle>
	<1206348478.6370.27.camel@youkaida>
Subject: Re: [linux-dvb] Now with debug info - Nova-T-500 disconnects - They
	are back!
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

On Mon, Mar 24, 2008 at 9:47 AM, Nicolas Will <nico@youplala.net> wrote:
> Guys,
>
>  I was running with the following debug options when I got a disconnect:
>
>  options dvb-usb-dib0700 force_lna_activation=1
>  options dvb-usb-dib0700 debug=1
>  options mt2060 debug=1
>  options dibx000_common debug=1
>  options dvb_core debug=1
>  options dvb_core dvbdev_debug=1
>  options dvb_core frontend_debug=1
>  options dvb_usb debug=1
>  options dib3000mc debug=1
>  options usbcore autosuspend=-1
>
>
>  /var/log/messages is here:
>
>  http://www.youplala.net/~will/htpc/disconnects/messages-with_debug
>
>  and slightly different data:
>
>  http://www.youplala.net/~will/htpc/disconnects/syslog-with_debug
>
>
>
>  Can that help, or would more be needed?
>
>  There was zero remote usage at the time.
>
>  Nico
>
>
>  _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

A bit off-topic but how do you get the date/time thing ? I only get
the time-since-boot and that is so enoying

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
