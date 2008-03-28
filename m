Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JfGoM-0005Hm-6G
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 16:48:13 +0100
Received: by ti-out-0910.google.com with SMTP id y6so123994tia.13
	for <linux-dvb@linuxtv.org>; Fri, 28 Mar 2008 08:47:54 -0700 (PDT)
Message-ID: <8ad9209c0803280847s42d77386t7f122b48dbb78051@mail.gmail.com>
Date: Fri, 28 Mar 2008 16:47:52 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <8ad9209c0803280846q53e75546g2007d4e8be98fb8e@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <1206139910.12138.34.camel@youkaida>
	<af2e95fa0803261142r33a0cdb1u31f9b8abc2193265@mail.gmail.com>
	<1206563002.8947.2.camel@youkaida>
	<8ad9209c0803261352s664d40fdud2fcbf877b10484b@mail.gmail.com>
	<1206566255.8947.5.camel@youkaida> <1206605144.8947.18.camel@youkaida>
	<af2e95fa0803271044lda4ac30yb242d7c9920c2051@mail.gmail.com>
	<47EC13BE.6020600@simmons.titandsl.co.uk>
	<1206655986.17233.8.camel@youkaida>
	<8ad9209c0803280846q53e75546g2007d4e8be98fb8e@mail.gmail.com>
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

On Fri, Mar 28, 2008 at 4:46 PM, Patrik Hansson <patrik@wintergatan.com> wrote:
>
> On Thu, Mar 27, 2008 at 11:13 PM, Nicolas Will <nico@youplala.net> wrote:
>  >
>  >  On Thu, 2008-03-27 at 21:38 +0000, Chris Simmons wrote:
>  >  >
>  >  > On an somewhat unrelated note, I was wondering about the firmware.  Am
>  >  > I
>  >  > right in thinking this is closed-source (from Hauppauge)?  Could this
>  >  > mess be caused by the firmware falling over -> device dies -> usb
>  >  > disconnect or other symptoms (like losing a tuner) depending on how
>  >  > the
>  >  > USB layer responds?  Not that I have a clue..
>  >
>  >  There is certainly a link with the firmware.
>  >
>  >  Patrick had solved issues by releasing a new version.
>  >
>  >  This is why it is so important that he gets involved as soon as he can
>  >  find time.
>  >
>  >  Nico
>  >
>  >
>  >
>  >
>  >  _______________________________________________
>  >  linux-dvb mailing list
>  >  linux-dvb@linuxtv.org
>  >  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>  >
>
>  Tried to collect some info from logs.
>  messages:
>  http://pastebin.com/f5cc1bc26
>  syslog:
>  http://pastebin.com/f402477c9
>  debug:
>  http://pastebin.com/f187de73a
>

Should have added that the mythfrontend was not watching tv.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
