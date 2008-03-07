Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.235])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JXmSI-00027l-Bf
	for linux-dvb@linuxtv.org; Sat, 08 Mar 2008 00:58:27 +0100
Received: by wx-out-0506.google.com with SMTP id s11so733924wxc.17
	for <linux-dvb@linuxtv.org>; Fri, 07 Mar 2008 15:58:21 -0800 (PST)
Message-ID: <d9def9db0803071558j3ac25432icaf500b16be5c4c0@mail.gmail.com>
Date: Sat, 8 Mar 2008 00:58:20 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: Raphael <rpooser@gmail.com>
In-Reply-To: <47D14F62.90406@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <47D14F62.90406@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1250: v4l-dvb need help compiling
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

On 3/7/08, Raphael <rpooser@gmail.com> wrote:
> Hello folks,
> I'm new to the list, and I subscribed mainly because I'm having a
> problem compiling the v4l-dvb drivers.
> I have a pinnacle PCTV HD Pro Stick and that is working fine using the
> em28xx drivers from mcentral.de.
> Currently, I'm trying to get a Hauppage HVR-1250 working. At first when
> I tried compiling v4l-dvb, I got errors about tea575x-tuner.c, and so
> using make menuconfig, I disabled all AM/FM tuners.
> Howver, after that I still get an error during make, this time in
> videodev.c.
> The first error is "unknown field 'dev_attrs' specified in initializer"
> on line 491.
>

I guess you're using the mt2060 based em28xx device.
Support for it for the newer driver package which is available on
mcentral.de is in the pipeline and should be done within 1-2 weeks.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
