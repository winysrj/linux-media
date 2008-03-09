Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <pansyg@gmx.at>) id 1JYPQj-0004KI-Gf
	for linux-dvb@linuxtv.org; Sun, 09 Mar 2008 18:35:29 +0100
From: Gernot Pansy <pansyg@gmx.at>
To: linux-dvb@linuxtv.org
Date: Sun, 9 Mar 2008 18:35:01 +0100
References: <20080308124700.581313bc@wanadoo.fr>
In-Reply-To: <20080308124700.581313bc@wanadoo.fr>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803091835.01193.pansyg@gmx.at>
Subject: Re: [linux-dvb] Patching MythTV in order to use it with multiproto
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


the hack is against svn trunk (0.21 branch is also working).

here you will find the latest one:
http://notz.homelinux.com/99_mythtv_multiproto_hack.dpatch 

gernot

On Saturday 08 March 2008 12:47:00 David BERCOT wrote:
> Hi,
>
> On Debian, I've downloaded the source version of MythTV :
> v0.20.2.svn20080126. Then, I've downloaded the patch from
> http://pansy.at/gernot/mythtv-multiproto-hack.diff.gz
>
> But, when I try to apply it, I have these errors :
> # patch <./mythtv-multiproto-hack.diff -p0
> patching file libs/libmythtv/dvbchannel.cpp
> Hunk #1 FAILED at 138.
> Hunk #2 succeeded at 146 (offset -11 lines).
> Hunk #3 FAILED at 452.
> Hunk #4 FAILED at 509.
> Hunk #5 succeeded at 586 with fuzz 1 (offset 19 lines).
> Hunk #6 FAILED at 625.
> Hunk #7 succeeded at 670 (offset 19 lines).
> Hunk #8 succeeded at 800 (offset -33 lines).
> Hunk #9 FAILED at 850.
> 5 out of 9 hunks FAILED -- saving rejects to file
> libs/libmythtv/dvbchannel.cpp.rej
>
> Do have any idea to resolve these errors ?
>
> Thank you very much.
>
> David.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
