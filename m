Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1L47Cg-0001Bg-1r
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 06:08:15 +0100
Received: by ug-out-1314.google.com with SMTP id x30so481288ugc.16
	for <linux-dvb@linuxtv.org>; Sat, 22 Nov 2008 21:08:10 -0800 (PST)
Message-ID: <37219a840811222108v2a602a6ev4ee1d766d0f620c3@mail.gmail.com>
Date: Sun, 23 Nov 2008 00:08:10 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Uri Shkolnik" <urishk@yahoo.com>
In-Reply-To: <375787.12947.qm@web38806.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <375787.12947.qm@web38806.mail.mud.yahoo.com>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH 3/5] USB suspend and hibernation support for
	Siano's SMS chip-set based devices.
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

2008/11/19 Uri Shkolnik <urishk@yahoo.com>:
> This patch provides USB suspend and hibernation support for Siano's SMS chipset based USB device
>
> Signed-off-by: Uri Shkolnik <uris@siano-ms.com> hibernation

Uri,

Thanks for posting these patches.

It looks like you diff'd the files in the Siano repository against the
files in the dvb tree.  In the future, please be careful not to tangle
unrelated changes into your patches.  When a patch changes only the
code that it needs to change, it makes it easier for the patches to be
reviewed and merged quicker.

For instance, the patch in your email introduces regressions that
cause compile warnings under 64bit operating systems.  This is caused
by changes in the patch that are not related at all to the
suspend/resume functionality.

I stripped away the unrelated portions of the patch, so the only
changes remaining were those that enable the suspend / resume
functionality, as described in your patch description.

The result changeset is pending merge into the master branch, and is
currently the topmost patch in my sms1xxx tree, here:

http://linuxtv.org/hg/~mkrufky/sms1xxx

I haven't yet had a chance to give a thorough review to the other
patches yet.  I'll try to follow-up soon.

Cheers,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
