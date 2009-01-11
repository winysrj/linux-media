Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp128.rog.mail.re2.yahoo.com ([206.190.53.33]:33680 "HELO
	smtp128.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751602AbZAKSCr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 13:02:47 -0500
Message-ID: <496A343F.7030703@rogers.com>
Date: Sun, 11 Jan 2009 13:02:39 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Malte Gell <malte.gell@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: dvb-t: searching for channels
References: <200901101645.51230.malte.gell@gmx.de> <4968E810.2050307@rogers.com> <200901102040.06001.malte.gell@gmx.de>
In-Reply-To: <200901102040.06001.malte.gell@gmx.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Malte Gell wrote:
> dvbscan is from dvb-1.1.0_CVS20080331
>   

Err, that looks wrong. We haven't used CVS for quite some time (not sure
about the date, but pretty sure it was well before Mar 2008, so I'm
unclear about the copy you have).

In any regard, grab a fresh copy from here: http://www.linuxtv.org/repo/
(you can obtain it via either a tarball or using Mercurial). Build
instructions are also listed on that page (essentially make, make install).

Will this resolve your "Unable to query frontend status" problem? I
don't know, but this will be a good starting point. Failing that, lets
see the relevant output from dmesg.
