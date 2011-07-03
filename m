Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:59493 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab1GCMaI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jul 2011 08:30:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QdLoM-0002F3-Az
	for linux-media@vger.kernel.org; Sun, 03 Jul 2011 14:30:06 +0200
Received: from ppp121-45-71-247.lns20.adl6.internode.on.net ([121.45.71.247])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 03 Jul 2011 14:30:06 +0200
Received: from arthur.marsh by ppp121-45-71-247.lns20.adl6.internode.on.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 03 Jul 2011 14:30:06 +0200
To: linux-media@vger.kernel.org
From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: Fwd: 0bda:2838 Ezcap DVB USB adaptor - no device files created
 / RTL2831U/RTL2832U
Date: Sun, 03 Jul 2011 13:43:23 +0930
Message-ID: <4E0FEC63.1080004@internode.on.net>
References: <4E0EC37F.1010201@internode.on.net> <4E0F7E5F.3040702@hoogenraad.net> <CACPK8Xd5HzdVSX6=QKoNjWMWCOMTKh7s=1==j9aDki6zJcFBBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Joel Stanley <joel@jms.id.au>
In-Reply-To: <CACPK8Xd5HzdVSX6=QKoNjWMWCOMTKh7s=1==j9aDki6zJcFBBw@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Joel Stanley wrote, on 03/07/11 12:17:
> Hello Jan,
>
> On Sun, Jul 3, 2011 at 05:53, Jan Hoogenraad
> <jan-conceptronic@hoogenraad.net>  wrote:
>> I have decided AGAINST making it runnable on newer kernels, as there are
>> some people working right now on a new release.
>
> I appreciate that you would prefer efforts to go towards a upstream
> driver. In the mean time I've updated the git tree[1] on my website.
> There were no real changes required; just a re-build with an updated
> dvb-usb.h and dvb_frontend.h from the kernel tree. Checkout the
> linux-3 branch.

Thanks, I rebuilt this against the linux-3 branch and now see the device 
tree:

# ls -alR /dev/dvb
/dev/dvb:
total 0
drwxr-xr-x  4 root root   80 Jul  3 13:33 .
drwxr-xr-x 15 root root 3140 Jul  3 13:33 ..
drwxr-xr-x  2 root root  120 Jul  3 13:33 adapter0
drwxr-xr-x  2 root root  120 Jul  3 13:33 adapter1

/dev/dvb/adapter0:
total 0
drwxr-xr-x  2 root root     120 Jul  3 13:33 .
drwxr-xr-x  4 root root      80 Jul  3 13:33 ..
crw-rw----+ 1 root video 212, 0 Jul  3 13:33 demux0
crw-rw----+ 1 root video 212, 1 Jul  3 13:33 dvr0
crw-rw----+ 1 root video 212, 3 Jul  3 13:33 frontend0
crw-rw----+ 1 root video 212, 2 Jul  3 13:33 net0

/dev/dvb/adapter1:
total 0
drwxr-xr-x  2 root root     120 Jul  3 13:33 .
drwxr-xr-x  4 root root      80 Jul  3 13:33 ..
crw-rw----+ 1 root video 212, 4 Jul  3 13:33 demux0
crw-rw----+ 1 root video 212, 5 Jul  3 13:33 dvr0
crw-rw----+ 1 root video 212, 7 Jul  3 13:33 frontend0
crw-rw----+ 1 root video 212, 6 Jul  3 13:33 net0

but haven't had time to test it further yet.
I'd be interested to hear more about the new release.

Arthur.

