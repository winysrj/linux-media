Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1JjcjL-0006Jx-8p
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 18:01:03 +0200
Received: by ti-out-0910.google.com with SMTP id y6so1171421tia.13
	for <linux-dvb@linuxtv.org>; Wed, 09 Apr 2008 09:00:50 -0700 (PDT)
Message-ID: <37219a840804090900q50ac4faakc66a5f8d4bd88c3b@mail.gmail.com>
Date: Wed, 9 Apr 2008 12:00:48 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Manu Abraham" <abraham.manu@gmail.com>
In-Reply-To: <47FCDB9A.5040807@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <200803292240.25719.janne-dvb@grunau.be>
	<47FCDB9A.5040807@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to choose
	dvb adapter numbers, second try
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

On Wed, Apr 9, 2008 at 11:07 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
> Janne Grunau wrote:
>  > Hi,
>  >
>  > I resubmit this patch since I still think it is a good idea to the this
>  > driver option. There is still no udev recipe to guaranty stable dvb
>  > adapter numbers. I've tried to come up with some rules but it's tricky
>  > due to the multiple device nodes in a subdirectory. I won't claim that
>  > it is impossible to get udev to assign driver or hardware specific
>  > stable dvb adapter numbers but I think this patch is easier and more
>  > clean than a udev based solution.
>  >
>  > I'll drop this patch if a simple udev solution is found in a reasonable
>  > amount of time. But if there is no I would like to see the attached
>  > patch merged.
>
>  As i wrote sometime back, adding adapter numbers to adapters is bad.
>
>  In fact, when the kernel advocates udev, working around it is no
>  solution, but finding the problem and fixing the basic problem is more
>  important, rather than workarounds.
>
>  http://www.gentoo.org/doc/en/udev-guide.xml
>  http://reactivated.net/writing_udev_rules.html
>
>  If there is a general udev issue, it should be taken up with udev and
>  not working around within adapter drivers.

Regardless of how broken the issue is within udev, udev is not user-friendly.

Under the current situation, users that have media recording servers
that receive broadcasts from differing delivery systems have no way
ensure that they are using the correct device for their recordings.

For instance:

Users might have VSB devices and QAM devices in their system, both to
receive OTA broadcasts and digital cable.  Likewise, someone else
might have DVB-S devices and DVB-T devices in the same system.

If said user has VSB devices as adapters 0 and 1, QAM-capable devices
as adapters 2 and 3, and DVB-S devices as adapters 5 and 6, they need
to be able to configure their software to know which device to use
when attempting to receive broadcasts from the respective media type.

The argument that "udev should do this -- fix udev instead" is weak,
in my opinion.  Even if udev can be fixed, the understanding of how to
configure it is hopeless.

When support for cx88-alsa and saa7134-alsa appeared, at first, I lost
functionality of my sound card.  I fixed the issue by setting my alsa
driver "index" module option for each respecting device in my build
scripts.  If I didn't have the ability to rectify that issue, I simply
would have yanked out the conflicting device (ie: use NO video card in
the system) or just reboot into Windows and ditch Linux, altogether.

This is a simple patch that adds the same functionality that v4l and
alsa have -- the ability to declare the adapter number of the device
at attach-time, based on a module option.  The change has minimal
impact on the source code, and adds great benefits to the users, and
requires zero maintenance.

The arguments against applying this change are "fix udev instead" and
"we'll have to remove this in kernel 2.7" ... Well, rather than to
have everybody wait around for a "fix" that requires programming
skills in order to use, I say we merge this now, so that people can
use their systems properly TODAY.  If we have to remove this in the
future as a result of some other kernel-wide requirements, then we
will cross that bridge when we come to it.

I see absolutely no harm in implementing this feature now.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
