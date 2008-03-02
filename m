Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JVxHz-0003IR-SK
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 00:08:17 +0100
Received: by nf-out-0910.google.com with SMTP id d21so3521952nfb.11
	for <linux-dvb@linuxtv.org>; Sun, 02 Mar 2008 15:08:08 -0800 (PST)
Message-ID: <47CB3352.5060607@googlemail.com>
Date: Sun, 02 Mar 2008 23:08:02 +0000
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

I've been thinking a little about how to implement that and I came across this issue:
(given my limited experience of dvb kernel developing the following might not be 100% correct...)

Usually everything (frontend, demux) is set up and only afterwards a dvr is opened.

That means that a dvr is live immediately and its buffer gets filled immediately.
So it is a bit tricky to change the size of the buffer while the buffer is operating.
The demux on the other hand does not operate immediately.

Possible solutions:

1) open the DVR before starting the demux. So that it is possible to change the dvr buffer size
it is usually done the other way round.

2) enable the resize of a live ring buffer.
Currently:

dvb_dvr_write DOES     lock the mutex (dmxdev->mutex)
dvb_dvr_read  DOES NOT lock the mutex (the code to lock the mutex is there, but commented out, why?)

Is it enough to lock the mutex in dvb_dvr_read?
Then the new function to change the buffer size could just lock the mutex, change the size and unlock.

3) don't bother.

I personally prefer option 2), which gives me the chance to learn how all that works.
I'd like to have an opinion about this matter, maybe just to improve my knowledge of the dvb mechanism.

Anyone?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
