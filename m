Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from xsmtp0.ethz.ch ([82.130.70.14])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cluck@student.ethz.ch>) id 1K7Ucz-0006XF-IO
	for linux-dvb@linuxtv.org; Sat, 14 Jun 2008 14:13:06 +0200
Message-ID: <4853B5CD.3050906@ethz.ch>
Date: Sat, 14 Jun 2008 14:13:01 +0200
From: Claudio Luck <cluck@ethz.ch>
MIME-Version: 1.0
To: Andrea <mariofutire@googlemail.com>
References: <g2unka$ivi$1@ger.gmane.org>
In-Reply-To: <g2unka$ivi$1@ger.gmane.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to use a DVB FRONTEND in read only?
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

Andrea wrote:
> I would like to open the dvb in readonly and take whatever frequency is currently tuned:
> 
> 1) I open the frontend in read only
> 2) query the current frequency to check is there is a lock
> 3) I open the demux, set some filters and read from the demux.
> 
> There is a *big* issue here:
> 
> The card streams packets *only* and *as long* as the frontend is opened in read/write (by some other 
> application) and tuned.
> If my application opens the frontend in readonly and there is no other application running, the 
> ioctl FE_GET_INFO still returns FE_HAS_LOCK but no data goes through the demux.
> As soon as the frontend is tuned, the data arrives.
> 
> Am I correct? How can I detect if the dvb is running or not?


Check for open filehandles on demux device:

root@iptv:~# ls -l /proc/*/fd/* | grep demux
lrwx------ 1 vlc  vlc  64 2008-06-14 14:02 /proc/19876/fd/6 ->
/dev/dvb/adapter0/demux0
lrwx------ 1 vlc  vlc  64 2008-06-14 14:02 /proc/19892/fd/6 ->
/dev/dvb/adapter1/demux0

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
