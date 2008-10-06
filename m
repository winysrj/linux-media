Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1Kmwjv-0004ge-9o
	for linux-dvb@linuxtv.org; Mon, 06 Oct 2008 22:31:36 +0200
Received: by nf-out-0910.google.com with SMTP id g13so1179712nfb.11
	for <linux-dvb@linuxtv.org>; Mon, 06 Oct 2008 13:31:31 -0700 (PDT)
Message-ID: <37219a840810061331jc29b051l1a6223d946391db6@mail.gmail.com>
Date: Mon, 6 Oct 2008 16:31:31 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Herbert Graeber" <lists@graeber-clan.de>
In-Reply-To: <200810062216.18729.lists@graeber-clan.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <200810062216.18729.lists@graeber-clan.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] MSI Digi Vox mini III
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

2008/10/6 Herbert Graeber <lists@graeber-clan.de>:
> Current linux dvb doesn't support the MSI Digi VOX mini III DVB-T usb stick
> (1462:8807).
>
> I have got the af9015 driver from the mercurial repository
> http://linuxtv.org/hg/~anttip/af9015, added the USB ID mentioned above to
> the file af9015/linux/drivers/media/dvb/dvb-usb/af9015.c and then the DVB-T
> stick works fine.

You can really help out other users by posting a patch to this mailing
list, so that others can also benefit from your work.

To generate a patch, do "hg diff > msi-digivox-mini-iii.patch"

You should also include your sign-off with your patch, so that it can
be included in the official development repository, and eventually be
merged into the linux kernel.  You should provide the sign-off in the
form:

Signed-off-by: Your Name <email@addre.ss>

For more info, please see:

http://linuxtv.org/hg/v4l-dvb/file/tip/README.patches

Cheers,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
