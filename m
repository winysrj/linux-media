Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.240])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <blammo.doh@gmail.com>) id 1JzcI1-0003Zz-4I
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 20:46:53 +0200
Received: by an-out-0708.google.com with SMTP id c31so238450anc.125
	for <linux-dvb@linuxtv.org>; Fri, 23 May 2008 11:46:48 -0700 (PDT)
Message-ID: <91dcd1980805231146o76da8b6erf4860fbe270935c7@mail.gmail.com>
Date: Fri, 23 May 2008 11:46:47 -0700
From: Blammo <blammo.doh@gmail.com>
To: "Simon Baxter" <linuxtv@nzbaxters.com>
In-Reply-To: <084701c88174$812f0170$7501010a@ad.sytec.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <084701c88174$812f0170$7501010a@ad.sytec.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Signal strength via SNMP?
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

2008/3/8 Simon Baxter <linuxtv@nzbaxters.com>:
> I'd like to graph the cable dvb-c signal strength in cacti.

I too, would love to find a way to do this.. At this point I'm
part-way-down a path of bash scripts to generate output I can pull in
via a script instead into RRDTool.. Somewhat of a pain, and would be
FAR easier to do it via SNMP directly. You don't have to fight
contention on the DVB device, etc.

Ideally, I'd like to graph all the fields, signal, status, snr, ber,
unc, lock, but for now I'd just be happy to graph success of channels,
like so:

pbsHD: 100
fox: 100
cbs: 100
abc: 100
nbc: 100
nbc-weather: 100
upn: 10

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
