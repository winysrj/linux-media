Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1KJRNz-0001IP-1T
	for linux-dvb@linuxtv.org; Thu, 17 Jul 2008 13:11:15 +0200
Received: by fk-out-0910.google.com with SMTP id f40so4497081fka.1
	for <linux-dvb@linuxtv.org>; Thu, 17 Jul 2008 04:10:54 -0700 (PDT)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Thu, 17 Jul 2008 13:10:48 +0200
References: <487C3D71.1000409@fastmail.fm>
In-Reply-To: <487C3D71.1000409@fastmail.fm>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807171310.48366.christophpfister@gmail.com>
Cc: Ian MacKinnell <ianm_97@fastmail.fm>
Subject: Re: [linux-dvb] dvbscan initial file DVB-T Australia/Sydney
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

Hi,

Am Dienstag 15 Juli 2008 08:02:25 schrieb Ian MacKinnell:
> Hi
>
> Using the file au-Sydney_North_Shore that comes with dvb_utils in
> Debian/Ubuntu
> (/usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Sydney_North_Shore),
> the scan utility does not find any of the Seven-Network channels,
> although it finds all the other digital TV and radio channels in Sydney.
>
> After some experimenting with the scan utility, I changed the file
> /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Sydney_North_Shore as
> follows:
>
> # Seven VHF6
> -T 177500000 7MHz 2/3 NONE QAM64 8k 1/16 NONE
> +T 177500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>
> and scan now identifies all the Channel Seven network stations
> perfectly, as well as all the other Sydney channels found earlier.
>
> Please change the Channel Seven entry in the au-Sydney_North_Shore file
> accordingly and also can you remove the redundant au-sydney_north_shore
> file - it is an older, obsolete version.

Both of these issues aren't present in our repository [1]; your dvb-utils 
version is outdated (at least debian testing provides fairly recent stuff).

> NB: all the other VHF TV channels in Sydney have 3/4 as the 4th field -
> I simply changed Channel Seven to be the same as them, and that worked.

Christoph


[1] http://linuxtv.org/hg/dvb-apps

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
