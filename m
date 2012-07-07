Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm19-vm0.bullet.mail.ird.yahoo.com ([77.238.189.92]:31533 "HELO
	nm19-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751800Ab2GGAm7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 20:42:59 -0400
Message-ID: <1341621777.83042.YahooMailClassic@web29401.mail.ird.yahoo.com>
Date: Sat, 7 Jul 2012 01:42:57 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: bugs in dvbscan/scan, dvb-apps(Re: media_build and Terratec Cinergy T Black.)
To: Antti Palosaari <crope@iki.fi>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <1341608766.83055.YahooMailClassic@web29403.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Fri, 6/7/12, Hin-Tak Leung <htl10@users.sourceforge.net> wrote:

<snipped>
> > > - 'scandvb' segfault at the end on its own.
> > 
> > I didn't see that.
> 
> This is fc17's - it does so in a string function (v*printf)
> - probably easy to fix if/when I get the debuginfo package,
> if it isn't fixed upstream already.

I got hold of the debuginfo, and found the bug - it is in bad_usage() in dvb-apps/util/scan/scan.c, line 2583 (case 2). The format strings contains two %s, but that statement only supply one:

   fprintf (stderr, usage, pname);

Who should I report this to? (not very good with mercury at the moment...).

running scandvb on its own is supposed to result in an input file listing then print usage; on fc17 it segfaults while printing usage; on a mercury source build, it fills the 2nd %s with some random other string from the program itself.

<snipped>
> > There is both dvbscan and scandvb in Fedora dvb-apps.
> It is
> > not clear for me why two similar looking tools. Anyhow
> it is
> > just scandvb which I found working one.
> 
> I just found a dvbv5-scan on my harddisk (fc17) also, and
> dvbscan is in locate.db but gone. Apparently one might be
> 'scan' but too confusing and got its name changed during
> packaging.

Found the reason how/why it was gone while I was looking for debuginfo (see change log entry):
http://koji.fedoraproject.org/koji/buildinfo?buildID=327654

The fedora packager withdrew dvbscan: "drop dvbscan as it's obsolete/broken" - changelog June 26.

