Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.226])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JV6lu-0006Yo-RU
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 16:03:39 +0100
Received: by wr-out-0506.google.com with SMTP id 68so6118917wra.13
	for <linux-dvb@linuxtv.org>; Fri, 29 Feb 2008 07:03:04 -0800 (PST)
Message-ID: <d9def9db0802290703x1094eb64l8accec0f2da2bc7f@mail.gmail.com>
Date: Fri, 29 Feb 2008 16:03:03 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jelle de Jong" <jelledejong@powercraft.nl>
In-Reply-To: <47C81C1E.5080400@powercraft.nl>
MIME-Version: 1.0
Content-Disposition: inline
References: <47C81C1E.5080400@powercraft.nl>
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

Hi Jelle,

On Fri, Feb 29, 2008 at 3:52 PM, Jelle de Jong
<jelledejong@powercraft.nl> wrote:
> Hello all,
>
>  I wanted to create the channel config files for my environment, but
>  there is no scan example configuration that works for my environment, I
>  do have the websites with tabels of the frequencys. How do i create my
>  channel.conf ....
>
>  sudo apt-get install dvb-utils
>
>  # dvb-c channels:
>  firefox http://www.upc.nl/frequencies_gm.php?GM=0493 &
>
>  # dvb-t channels:
>  firefox http://www.digitenne.nl/pagina_49.html &
>
>  # make directorys to store channel configurations
>  mkdir --verbose ~/.{t,c}zap
>
>  scan --help
>  sudo scan -A 1/usr/share/doc/dvb-utils/examples/scan/dvb-t/..... >
>  ~/.tzap/channels.conf
>  sudo scan -A 2 /usr/share/doc/dvb-utils/examples/scan/dvb-c/.... >
>  ~/.czap/channels.conf
>

In case you want to use DVB-C, the Pinnacle Hybrid Pro 330e does NOT
support DVB-C, only analogue TV.
This device only supports DVB-T and analogue TV (which has nothing to
do with DVB-C or DVB-S)
You might try kaffeine for scanning for DVB-T channels.

for creating a custom scanfile you need some information about the
dvb-t transponder.
T 482000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
T 762000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE

the Pinnacle 330e is capable of autodetecting everything beside the
first 2 entries (frequency, bandwidth)

There are tools available for creating scanfiles and running the
bruteforce method:
http://www.johannes-bauer.com/dvbt/
look at Schritt 4, or tar xfvj dvbt-scanaid-0.03.tar.bz2

http://www.johannes-bauer.com/dvbt/dvbt-scanaid-0.03.tar.bz2

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
