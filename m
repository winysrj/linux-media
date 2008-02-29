Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JV6tx-0007ug-UL
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 16:11:58 +0100
Received: by wr-out-0506.google.com with SMTP id 68so6126287wra.13
	for <linux-dvb@linuxtv.org>; Fri, 29 Feb 2008 07:11:52 -0800 (PST)
Message-ID: <d9def9db0802290711l344bee24q79ed52ab2a15c6c4@mail.gmail.com>
Date: Fri, 29 Feb 2008 16:11:51 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jelle de Jong" <jelledejong@powercraft.nl>
In-Reply-To: <d9def9db0802290703x1094eb64l8accec0f2da2bc7f@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <47C81C1E.5080400@powercraft.nl>
	<d9def9db0802290703x1094eb64l8accec0f2da2bc7f@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] how can I create a czap config file without an
	sample config file for my environment
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

On Fri, Feb 29, 2008 at 4:03 PM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> Hi Jelle,
>
>
>  On Fri, Feb 29, 2008 at 3:52 PM, Jelle de Jong
>  <jelledejong@powercraft.nl> wrote:
>  > Hello all,
>  >
>  >  I wanted to create the channel config files for my environment, but
>  >  there is no scan example configuration that works for my environment, I
>  >  do have the websites with tabels of the frequencys. How do i create my
>  >  channel.conf ....
>  >
>  >  sudo apt-get install dvb-utils
>  >
>  >  # dvb-c channels:
>  >  firefox http://www.upc.nl/frequencies_gm.php?GM=0493 &
>  >

I haven't had a look at that link first, this seems to be an analogue
TV frequency list and not DVB-C.

http://mcentral.de/wiki/index.php5/Tvtime

you might try to install this tvtime version, it's patched to work
with your device and autodetect the corresponding audio device.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
