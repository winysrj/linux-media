Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1NG7Ld-00013I-7B
	for linux-dvb@linuxtv.org; Thu, 03 Dec 2009 09:47:38 +0100
Received: by ewy7 with SMTP id 7so145582ewy.12
	for <linux-dvb@linuxtv.org>; Thu, 03 Dec 2009 00:47:03 -0800 (PST)
Date: Thu, 3 Dec 2009 09:47:01 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Leszek Koltunski <leszek@koltunski.pl>
In-Reply-To: <8cd7f1780912030012h609a7a5w72d054ac5749eab1@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.0912030943130.4548@ybpnyubfg.ybpnyqbznva>
References: <8cd7f1780912030012h609a7a5w72d054ac5749eab1@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] /dev/dvb/adapter0/net0 <-- what is this for and how
 to use it?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

On Thu, 3 Dec 2009, Leszek Koltunski wrote:

> One question: in /dev/dvb/adapter0 I can see
> 
> leszek@satellite:~$ ls -l /dev/dvb/adapter0/
> total 0
> crw-rw----+ 1 root video 212, 4 2009-12-02 18:22 ca0
> crw-rw----+ 1 root video 212, 0 2009-12-02 18:22 demux0
> crw-rw----+ 1 root video 212, 1 2009-12-02 18:22 dvr0
> crw-rw----+ 1 root video 212, 3 2009-12-02 18:22 frontend0
> crw-rw----+ 1 root video 212, 2 2009-12-02 18:22 net0
> 
> What is this 'net0' device and how do I use it? Can I use it to directly
> multicast my (FTA) satellite stream to my lan by any chance?

No, it can be used for receiving IP datastreams broadcast by
satellite.


> I have found no documentation about this...

There is a guide I've found to setting this up (a few years ago)
but I can't give an off-the-top-of-my-head pointer to this.

Unless you want to receive a satellite-delivered multicast or
unicast stream -- I'm not sure if there are any out there of
interest to non-subscribers -- it something you wouldn't need
to use.


barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
