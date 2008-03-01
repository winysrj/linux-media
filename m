Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JVNkj-0006tV-HD
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 10:11:33 +0100
Received: by ug-out-1314.google.com with SMTP id o29so1228101ugd.20
	for <linux-dvb@linuxtv.org>; Sat, 01 Mar 2008 01:11:30 -0800 (PST)
Message-ID: <47C91DBE.4050409@googlemail.com>
Date: Sat, 01 Mar 2008 09:11:26 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: Florian Lohoff <flo@rfc822.org>
References: <47C8A135.9070209@googlemail.com>
	<20080301085538.GA4003@paradigm.rfc822.org>
In-Reply-To: <20080301085538.GA4003@paradigm.rfc822.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help using DMX_SET_BUFFER_SIZE
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

Florian Lohoff wrote:
> On Sat, Mar 01, 2008 at 12:20:05AM +0000, Andrea wrote:
>> on the dvr (I think), but it does not make much of a change. The ioctl call returns success.
>> I've printed a lot of debug output (adding a few dprintk) and this is what I see when I run gnutv.
>> Now, I set the buffer to 1024 * 1024 which is nowhere in the log.
>> I cannot see in the log the 2 functions (demux and dvr) handling this ioctl call:
>> dvb_demux_do_ioctl and dvb_dvr_do_ioctl (I've added some printk as well).
> 
> In 2.6.25-rc3 the dvr kernel side looks like this:
> 
> 1015         switch (cmd) {
> 1016         case DMX_SET_BUFFER_SIZE:
> 1017                 // FIXME: implement
> 1018                 ret = 0;
> 1019                 break;
> 
> i guess its clear why it doesnt make a difference ;)
> 
> Flo

Yes I had noticed that and I was trying to see what I can do.
My problem is that I replace the // FIXME with a printk() and it does not get called
How is it supposed to work?

I open /dev/dvb/adapter0/dvr0, I get back a file descriptor and the I call the ioctl with that file 
descriptor.

This code comes from gnutv_data.c plus my additional code

		// open dvr device
		dvrfd = dvbdemux_open_dvr(adapter_id, 0, 1, 0);
		if (dvrfd < 0) {
			fprintf(stderr, "Failed to open DVR device\n");
			exit(1);
		}

		if (buffer_size > 0)
		{
		  int res = dvbdemux_set_buffer(dvrfd, buffer_size);
		  if (res < 0) {
		    fprintf(stderr, "Failed to set ring buffer size\n");
		    exit(1);
		  }
		}

Regardless of what is implemented or not, would that be correct?

Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
