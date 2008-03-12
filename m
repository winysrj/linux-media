Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JZWwZ-0007Lg-E5
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 20:48:56 +0100
Received: by el-out-1112.google.com with SMTP id o28so1726711ele.2
	for <linux-dvb@linuxtv.org>; Wed, 12 Mar 2008 12:48:51 -0700 (PDT)
Message-ID: <8ad9209c0803121248w58cfad71l5e12aaf059218861@mail.gmail.com>
Date: Wed, 12 Mar 2008 20:48:50 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <af2e95fa0803121240u20e210a8p26c84a968cd2c9e7@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080311110707.GA15085@mythbackend.home.ivor.org>
	<af2e95fa0803121240u20e210a8p26c84a968cd2c9e7@mail.gmail.com>
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

2008/3/12 Henrik Beckman <henrik.list@gmail.com>:
> 2.6.22-14 with patches,  stable for me.
>
> /Henrik
>
>
>
>
> On Tue, Mar 11, 2008 at 12:07 PM, <ivor@ivor.org> wrote:
> > Not sure if this helps or adds that much to the discussion... (I think
> this was concluded before)
> > But I finally switched back to kernel 2.6.22.19 on March 5th (with current
> v4l-dvb code) and haven't had any problems with the Nova-t 500 since.
> Running mythtv with EIT scanning enabled.
> >
> > Looking in the kernel log I see a single mt2060 read failed message on
> March 6th and 9th and a single mt2060 write failed on March 8th. These
> events didn't cause any problems or cause the tuner or mythtv to fail
> though.
> >
> > Ivor.
> >
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
>
>
> _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Henrik:
What options (if any) are you using in modprobe.d ?
Do you mean that you have patched the kernel or the v4l-dvb tree ?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
