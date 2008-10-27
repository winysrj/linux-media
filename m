Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.175])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1KuUtO-0004ka-VL
	for linux-dvb@linuxtv.org; Mon, 27 Oct 2008 17:24:36 +0100
Received: by wf-out-1314.google.com with SMTP id 27so2309524wfd.17
	for <linux-dvb@linuxtv.org>; Mon, 27 Oct 2008 09:24:29 -0700 (PDT)
Message-ID: <854d46170810270924r43304f49o98fff08ea7049372@mail.gmail.com>
Date: Mon, 27 Oct 2008 17:24:27 +0100
From: "Faruk A" <fa@elwak.com>
To: Bitte_antworten@will-hier-weg.de
In-Reply-To: <20081027140211.168320@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081025141920.87960@gmx.net> <200810251712.00078.dkuhlen@gmx.net>
	<20081027140211.168320@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cinergyT2 renamed drivers (was Re: stb0899 drivers)
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

On Mon, Oct 27, 2008 at 3:02 PM,  <Bitte_antworten@will-hier-weg.de> wrote:
> Thanks Dominik, I found it out yesterday. The CinergyT2 is working fine now, but it is nearly impossible to use the PCTV452e with (an unmodified) kaffeine. It simply doesn't lock in more than 90% of my tests. The only channel that works sometimes is "Das Erste" and the lock takes appr. 1 minute.
> So I reverted to multiproto again which works fine (except "NDR")
> Dirk

Hi!

Try this since Dominik's patch not included in Igor's repo, you should
get faster locks on all your channels.

hg clone -r 9263 http://mercurial.intuxication.org/hg/s2-liplianin
wget http://hem.passagen.se/faruks/3650/my_s2api_pctv452e.txt
cd s2-liplianin
patch -p1 < ../my_s2api_pctv452e.txt
make ; # there might be a few warnings.
cd v4l
insmod dvb-core.ko
insmod stb6100.ko verbose=0
insmod stb0899.ko verbose=0
insmod lnbp22.ko
insmod ttpci-eeprom.ko
insmod dvb-usb.ko
insmod dvb-usb-pctv452e.ko


Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
