Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <glenn.l.mcgrath@gmail.com>) id 1KhIhn-0004qS-Hw
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 08:46:05 +0200
Received: by ti-out-0910.google.com with SMTP id w7so658088tib.13
	for <linux-dvb@linuxtv.org>; Sat, 20 Sep 2008 23:44:56 -0700 (PDT)
Message-ID: <141058d50809202344l77fb888w71dbe53b76846ea3@mail.gmail.com>
Date: Sun, 21 Sep 2008 16:44:56 +1000
From: "Glenn McGrath" <glenn.l.mcgrath@gmail.com>
To: "Alex Ferrara" <alex@receptiveit.com.au>
In-Reply-To: <17918C45-7B7B-47DE-89F3-4A10CE36467C@receptiveit.com.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <17918C45-7B7B-47DE-89F3-4A10CE36467C@receptiveit.com.au>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Dvico dual digital express - Poor tuner performance
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

On Sun, Sep 21, 2008 at 3:35 PM, Alex Ferrara <alex@receptiveit.com.au> wrote:
> I am currently seeing inconsistent performance with the dvico dual
> digital express. Some channels tune just fine, and others have the
> impression of a very low signal strength.

I have the same card in regional Australia, i had a similar problem
problem, its working fine now though.

One of my issue was that i had not scanned the channels properly, did
you generate your initial-tuning-data yourself and use scan to
generate the channels.conf, or use somebody elses initial-tuning-data
?

It could be that the frequency in your channels.conf isnt accurate
enough, from what ive experienced if you set the frequency in the
channels.conf to be the center frequency of channel + 125kHz you
should be ok.

Also, there is an app called femon from dvb-apps package which will
display the signal strength of the currently tunned channel, i just
started that going and moved my indoor digital antenna around till i
got max strength.


Glenn

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
