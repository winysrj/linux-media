Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KWZs3-00068C-5x
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 18:52:21 +0200
Received: by ug-out-1314.google.com with SMTP id q7so213260uge.16
	for <linux-dvb@linuxtv.org>; Fri, 22 Aug 2008 09:52:15 -0700 (PDT)
Message-ID: <412bdbff0808220952y16d36f3by646f0000991de4d3@mail.gmail.com>
Date: Fri, 22 Aug 2008 12:52:15 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Nicolas Will" <nico@youplala.net>
In-Reply-To: <1219423493.29624.9.camel@youkaida>
MIME-Version: 1.0
Content-Disposition: inline
References: <1219330331.15825.2.camel@dark> <48ADF515.6080401@nafik.cz>
	<1219360304.6770.34.camel@youkaida>
	<1219423326.29624.8.camel@youkaida>
	<1219423493.29624.9.camel@youkaida>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib0700 and analog broadcasting
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

On Fri, Aug 22, 2008 at 12:44 PM, Nicolas Will <nico@youplala.net> wrote:
> In /etc/modprobe.d/options, I have:
> # Load DVB-T before DVB-S
> install cx88-dvb /sbin/modprobe dvb-usb-dib0700; /sbin/modprobe
> --ignore-install cx88-dvb
>
> # Hauppauge WinTV NOVA-T-500
> options dvb-usb-dib0700 force_lna_activation=1
> options usbcore autosuspend=-1

Interesting.  I installed the firmware, and although it hasn't helped
my particular issue (and it's behaving identically to 1.10), it hasn't
crashed my environment.  On the other hand, my failures occur fairly
early in the initialization so the problem may be further into startup
than I have gotten with my device.  I am running 8.04 with the latest
kernel and v4l-dvb code.

Does it happen right after you plug the device in, or does it not
occur until you start a video application?

If it occurs immediately on connect, perhaps you could jump out of X11
to the console before plugging it in, to see if there is any panic
output prior to the reboot.

Also, I can't think of why this would happen, but could you send the
md5sum of your firmware file so we can make sure it wasn't corrupted?

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
