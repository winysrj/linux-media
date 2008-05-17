Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JxTff-0000f4-Lj
	for linux-dvb@linuxtv.org; Sat, 17 May 2008 23:10:28 +0200
Message-ID: <482F49BB.4060300@gmail.com>
Date: Sun, 18 May 2008 01:10:19 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
References: <482EB3E5.7090607@freenet.de>
In-Reply-To: <482EB3E5.7090607@freenet.de>
Cc: "linux-dvb: linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Mantis 2033 still not working with CAM inserted
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

Ruediger Dohmhardt wrote:
> Dear Manu,
> 
> the code from
> 
> http://jusst.de/hg/mantis (10.5.08)
> 
> now works fine for the 2033 without the CAM (here Alphacrypt Light)
> inserted.
> 
> When I insert the CAM, audio and video stop. I need to remove the CAM
> and  I must  reload the module with
> 
>    modprobe -r mantis
> 
> followed by
> 
>    modprobe mantis
> 
> Could you please look into the attached /var/log/messages file.
> Maybe it could provide a hint, what's still wrong.
> 
> The verbose level is set to 3 (options mantis verbose=3)


Applied some changes, couldn't test the changes while being away, but
only build tests. Please do test again, also feel free to play with the
individual changesets as to check for various stage tests.

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
