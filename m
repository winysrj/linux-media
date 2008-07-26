Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Sat, 26 Jul 2008 15:43:35 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Yusik Kim <yusikk@gmail.com>
In-Reply-To: <200807261229.42608.yusikk@gmail.com>
Message-ID: <Pine.LNX.4.64.0807261540420.28819@cnc.isely.net>
References: <200807260353.23359.yusikk@gmail.com>
	<488B4524.5070203@linuxtv.org>
	<200807261130.39977.yusikk@gmail.com>
	<200807261229.42608.yusikk@gmail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1950 digital part
Reply-To: Mike Isely <isely@pobox.com>
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

On Sat, 26 Jul 2008, Yusik Kim wrote:

> On Saturday 26 July 2008 11:30:39 Yusik Kim wrote:

   [...]

> 
> Also, I tried re-extracting the firmware with the perl script
> http://www.isely.net/downloads/fwextract.pl
> I downloaded today and used it on the installation CD to get the following 
> files
> 376836 2008-07-26 11:59 v4l-cx2341x-enc.fw
>   12559 2008-07-26 11:59 v4l-cx25840.fw
>     8192 2008-07-26 11:59 v4l-pvrusb2-29xxx-01.fw
>     8192 2008-07-26 11:59 v4l-pvrusb2-73xxx-01.fw
> but still no luck. By the way, the filesize for the old v4l-cx25840.fw was 
> 16382. Everything else the same.

The extraction script uses MD5 sums to verify it has correctly extracted 
the data.  If you're getting firmware files back out, then those files 
are definitely correct.

However with that said, there are multiple versions of some of the 
firmware floating around.  In particular I have come across 4-5 
different cx25840 firmware versions.  All should work however, for what 
you are trying to do.  (Also, if this is a digital mode tuning problem, 
then the cx25840 part is not relevant to the problem.)

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
