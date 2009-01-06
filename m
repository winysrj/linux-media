Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]
	helo=shogun.pilppa.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lamikr@pilppa.org>) id 1LKDNt-00083H-3u
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 15:58:23 +0100
Date: Tue, 6 Jan 2009 16:58:16 +0200 (EET)
From: Mika Laitio <lamikr@pilppa.org>
To: Goga777 <goga777@bk.ru>
In-Reply-To: <20090105002404.3f385576@bk.ru>
Message-ID: <Pine.LNX.4.64.0901061653470.7224@shogun.pilppa.org>
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
	<20090103193718.GB3118@gmail.com> <20090104111429.1f828fc8@bk.ru>
	<Pine.LNX.4.64.0901041435090.1668@shogun.pilppa.org>
	<op.um8hljd6rj95b0@localhost>
	<20090104175638.2a92018b@bk.ru> <op.um82p6r7rj95b0@localhost>
	<20090105002404.3f385576@bk.ru>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S Channel searching problem
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

> of course you should install 2 patches for vdr 170
>
> http://www.linuxtv.org/pipermail/vdr/attachments/20080413/1054bcfb/attachment-0001.bin
> vdr-1.7.0-h264-syncearly-framespersec-audioindexer-fielddetection-speedup.diff.bz2
>
> http://www.linuxtv.org/pipermail/vdr/attachments/20081007/edcd3fcc/attachment-0001.obj
> vdr-1.7.0-s2api-07102008-h264-clean.patch.gz

Ok tested now with S2API drivers from liplianis repository with
vdr-1.7.0 and those 2 patches applied. Result is that the scanning fails 
just in a similar way than what it happens with vdr-1.7.2 either with 
dv4-v4l or with liplianis version of S2API drivers.

If I had first tuned for example to arte with vdr-1.6.0 or szap and then 
closed vdr-1.6.0/szap, I can watch arte with vdr-1.7.0 or with vdr-1.7.2

But switching to some other dvb-t or dvb-s channels will fail.

(hvr-1300 + hvr-4000)

Mika

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
