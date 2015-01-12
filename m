Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.algroup.co.uk ([83.167.187.67]:33923 "EHLO
	mail.algroup.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbbALOM4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 09:12:56 -0500
Message-ID: <54B3CC8A.7070306@algroup.co.uk>
Date: Mon, 12 Jan 2015 13:30:50 +0000
From: Adam Laurie <adam@algroup.co.uk>
MIME-Version: 1.0
To: Olliver Schinagl <oliver+list@schinagl.nl>,
	Jonathan McCrohan <jmccrohan@gmail.com>,
	Brian Burch <brian@pingtoo.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb-t scan tables
References: <54ADCBBC.4050400@algroup.co.uk> <54AE4333.9070301@schinagl.nl> <54AE4A6D.6080602@pingtoo.com> <54AE4DE6.1040602@schinagl.nl> <92F63096-11DC-434E-81C0-673263E56459@gmail.com> <54AE9066.8010000@algroup.co.uk> <54B24FB9.6010401@schinagl.nl>
In-Reply-To: <54B24FB9.6010401@schinagl.nl>
Content-Type: multipart/mixed;
 boundary="------------060600040405030100020401"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060600040405030100020401
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/01/15 10:26, Olliver Schinagl wrote:
> Hey Adam,
>
> I've merged your changes, but this last patch seems to go against the
> old (obsolete) dvbv3 stuff (that gets auto-generated afaik) and fails to
> apply.
>
> Look at the result on the various repositories and see what needs to be
> changed.

OK, I'll take a look.

>
> Best way to send a patch, is to use git to checkout the tree, and then
> do a git format-patch to send the patch, saves me some work ;)
>

Is that different from the attached?

I've updated the channel numbers as they are now exact and not +/-

cheers,
Adam
-- 
Adam Laurie                         Tel: +44 (0) 20 7993 2690
Suite 7
61 Victoria Road
Surbiton
Surrey                              mailto:adam@algroup.co.uk
KT6 4JX                             http://rfidiot.org

--------------060600040405030100020401
Content-Type: text/x-patch;
 name="stocklandhill.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="stocklandhill.patch"

diff --git a/dvb-t/uk-StocklandHill b/dvb-t/uk-StocklandHill
index 8b9ad5a..5d2ee81 100644
--- a/dvb-t/uk-StocklandHill
+++ b/dvb-t/uk-StocklandHill
@@ -6,7 +6,7 @@
 # date (yyyy-mm-dd)    : 2014-03-25
 #
 #----------------------------------------------------------------------------------------------
-[C26+ BBC A]
+[C26 BBC A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 514000000
 	BANDWIDTH_HZ = 8000000
@@ -18,7 +18,7 @@
 	HIERARCHY = NONE
 	INVERSION = AUTO
 
-[C23+ D3&4]
+[C23 D3&4]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
 	BANDWIDTH_HZ = 8000000
@@ -30,7 +30,7 @@
 	HIERARCHY = NONE
 	INVERSION = AUTO
 
-[C25- SDN]
+[C25 SDN]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 506000000
 	BANDWIDTH_HZ = 8000000
@@ -42,7 +42,7 @@
 	HIERARCHY = NONE
 	INVERSION = AUTO
 
-[C22- ARQ A]
+[C22 ARQ A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
 	BANDWIDTH_HZ = 8000000
@@ -54,7 +54,7 @@
 	HIERARCHY = NONE
 	INVERSION = AUTO
 
-[C28- ARQ B]
+[C28 ARQ B]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 530000000
 	BANDWIDTH_HZ = 8000000
@@ -66,7 +66,7 @@
 	HIERARCHY = NONE
 	INVERSION = AUTO
 
-[C29+ BBC B HD]
+[C29 BBC B HD]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 538000000
 	BANDWIDTH_HZ = 8000000

--------------060600040405030100020401--
