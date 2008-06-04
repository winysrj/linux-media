Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1K416h-0003YV-Qx
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 00:05:24 +0200
Received: by fg-out-1718.google.com with SMTP id e21so175287fga.25
	for <linux-dvb@linuxtv.org>; Wed, 04 Jun 2008 15:05:20 -0700 (PDT)
Message-ID: <854d46170806041505w69a0bebakfa997223cade4381@mail.gmail.com>
Date: Thu, 5 Jun 2008 00:05:19 +0200
From: "Faruk A" <fa@elwak.com>
To: "=?ISO-8859-1?Q?Michael_Sch=F6ller?="
	<michael.schoeller@schoeller-soft.net>
In-Reply-To: <484709F3.7020003@schoeller-soft.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <484709F3.7020003@schoeller-soft.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to get a PCTV Sat HDTC Pro USB (452e) running?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Michael!

You can find dvb-apps patches for the latest API 3.3 here.
http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025222.html

One more thing patches for PCTV 452e posted on the wiki is too old, there i=
s new
and final patches available.
You need this files:
patch_multiproto_pctv452e_tts23600.diff.bz2
patch_multiproto_dvbs2_frequency.diff
You can find it here
http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025539.html

Faruk


On Wed, Jun 4, 2008 at 11:32 PM, Michael Sch=F6ller
<michael.schoeller@schoeller-soft.net> wrote:
> Hi,
> I run into some problems when trying to get my 452e running.
> I followed the infos at
> http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_Sat_HDTV_Pro_USB_%284=
52e%29
>
> and compiled multiproto kernel modules.
> The device seems to be detected and working (even if the kernel now is
> very unstable)
> But I'm not able to do any more.
> I downloaded the newest dvb-apps and compiled it. But scan, szap or
> szap2 are not working.
> Maybe I need some multiproto patch for dvb-apps but I didn't find
> anything useful on the Internet.
>
> Can someone gives me an step by step explanation that I can use. Even I
> ran into errors I could post them and get an solution this way.
>
> My System:
> PS3 running YDL6 (with newest available packaged from the YDL6
> repositories)
>
> Michael
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
