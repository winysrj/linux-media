Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from scing.com ([217.160.110.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1K6P3p-0003wk-K3
	for linux-dvb@linuxtv.org; Wed, 11 Jun 2008 14:04:18 +0200
From: Janne Grunau <janne-dvb@grunau.be>
To: linux-dvb@linuxtv.org
Date: Wed, 11 Jun 2008 14:04:47 +0200
References: <BA86A83C-165B-44C6-908B-14F483018582@onetel.com>
In-Reply-To: <BA86A83C-165B-44C6-908B-14F483018582@onetel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806111404.47324.janne-dvb@grunau.be>
Subject: Re: [linux-dvb] UK Freesat twin tuner USB/PCI/PCI-E
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

On Wednesday 11 June 2008 13:36:42 Tim Hewett wrote:
> Mike,
>
> No need to worry about having two of the same D-SAT device so ling as
> they are both receiving their signal from the same satellite, e.g.
> 28East in your case. One will be adaptor 0 and the other will be
> adaptor 1. If they don't receive the signal from the same satellite
> (say one is on 28East and the other on 19.2East) then it might be
> difficult to identify which is which since they may not be assigned
> the same adaptor number each time the PC is booted.

>From 2.6.26 (or current v4l-dvb hg) on all the frontend modules have a 
adapter_nr module option which allows to specify which adapter numbers 
that frontend should prefer. eg. dvb-usb-dib0700 
adapter_nr=7,6,5,4,3,2,1,0 for reverse allocation of adapter numbers 
for the dvb-usb-dib0700 modul. This only helps if the cards use 
different frontend modules. OTOH the ordering is more stable if the 
devices use the same module.

> |n my experience recording entire transponders is a good idea even if
> you only want one or two channels from it, because every now and
> again the BBC and ITV change the PIDs of their channels - if you
> record by specifying PIDs you may find you get no recording when the
> PIDs change. By recording the whole transponder you get everything
> regardless of PID changes, and then afterwards you can extract the
> channel(s) you want using ts2ps (from dvb-mpegtools) specifying the
> current PIDs for the channel. You need plenty of disk space to do
> this though.

Using an application like MythTV or vdr for recording would solve this 
two. They handle the pid changes during the recording automatically and 
record happily more than one program from the same transponder up to 
the whole transponder. HD speed is might be a little bit more critical 
due to more independent streams but even the whole tranponder data rate 
(max 50mbps) is small compared two the speed of modern HD (above 100 
mbyte/s). MythTV will also happily distribute recordings over multiple 
discs.

Janne


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
