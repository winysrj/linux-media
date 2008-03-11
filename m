Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JZ6p8-0002u4-I1
	for linux-dvb@linuxtv.org; Tue, 11 Mar 2008 16:55:32 +0100
Received: by wa-out-1112.google.com with SMTP id m28so3075332wag.13
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 08:55:24 -0700 (PDT)
Message-ID: <8ad9209c0803110855w2d469ab9x1e4e4f5a70799d80@mail.gmail.com>
Date: Tue, 11 Mar 2008 16:55:24 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1205234401.7463.10.camel@acropora>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080311110707.GA15085@mythbackend.home.ivor.org>
	<1205234401.7463.10.camel@acropora>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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

Have you applied any patches to the v4l-dvb source before compiling ?

On 3/11/08, Nicolas Will <nico@youplala.net> wrote:
>
> On Tue, 2008-03-11 at 11:07 +0000, ivor@ivor.org wrote:
> > Not sure if this helps or adds that much to the discussion... (I think
> > this was concluded before)
> > But I finally switched back to kernel 2.6.22.19 on March 5th (with
> > current v4l-dvb code) and haven't had any problems with the Nova-t 500
> > since. Running mythtv with EIT scanning enabled.
> >
> > Looking in the kernel log I see a single mt2060 read failed message on
> > March 6th and 9th and a single mt2060 write failed on March 8th. These
> > events didn't cause any problems or cause the tuner or mythtv to fail
> > though.
>
> ah.
>
> So this begs the question:
>
> What changed between 2.6.22 and 2.6.24? huh... funny, heh?
>
> So, if 2.6.24 is finger pointed, I'm interested in a solution, as I have
> a planned upgrade to it in about a month's time.
>
> Nico
>
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
