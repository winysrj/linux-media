Return-path: <linux-media-owner@vger.kernel.org>
Received: from cooker.cnx.rice.edu ([168.7.5.70]:35821 "EHLO
	cooker.cnx.rice.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025AbZJ3Ude (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 16:33:34 -0400
Date: Fri, 30 Oct 2009 14:55:27 -0500
From: "Ross J. Reedstrom" <reedstrm@rice.edu>
To: Steven Toth <stoth@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Hauppage HVR-2250 Tuning problems
Message-ID: <20091030195527.GC25153@rice.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Steven -
Thanks for all the driver work. Do you want bug reports for the -stable
branch on the list, or both to you and the list? (looked around a bit,
couldn't find a community "how to report a bug")

I've recently installed an HVR-2250 (to replace an HVR-1800 that had
some surface mount component blow a crater out, right near the bus
connector!) in a Mythbuntu box, running mythtv
0.21.0+fixes18207-0ubuntu4~hardy1, kernel 2.6.24-24.61

And have the digital tuning working w/ your stable driver (cloned from
kernellabs on 10/16: I don't know hg well enough to how to report a
specific source set)

It's been working well, until one evening my wife reported that two
shows stopped recording simultaneously. Checking the logs, I see the
occasional pair of i2c errors ( ~ 1 every 12-24 hours):

Oct 23 22:48:04 MediaPC kernel: [679597.153063] saa7164_api_i2c_read() error, ret(2) = 0x13
Oct 23 22:48:04 MediaPC kernel: [679597.153072] tda18271_read_regs: ERROR: i2c_transfer returned: -5

Until about 20 min before it locked up, these show up:
Oct 27 20:22:45 MediaPC kernel: [1015942.952099] Event timed out
Oct 27 20:22:45 MediaPC kernel: [1015942.952107] saa7164_api_i2c_read() error, ret(1) = 0x32
Oct 27 20:22:45 MediaPC kernel: [1015942.952110] s5h1411_readreg: readreg error (ret == -5)

and the occasional:

Oct 27 20:23:06 MediaPC kernel: [1015963.906731] Event timed out
Oct 27 20:23:06 MediaPC kernel: [1015963.906741] saa7164_api_i2c_write() error, ret(1) = 0x32
Oct 27 20:23:06 MediaPC kernel: [1015963.906744] s5h1411_writereg: writereg error 0x19 0xf7 0x0000, ret == -5)

in blocks, one set a second for a few seconds, then a few second gap. 
Note at this point, it's still recording both shows.

There are many, many more read than write errors: 232644 read errors
between 20:22:45 and 20:44:10, 168 write errors.

Finally, this changes to:
Oct 27 20:44:10 MediaPC kernel: [1017225.901272] Event timed out
Oct 27 20:44:10 MediaPC kernel: [1017225.901282] saa7164_api_i2c_read() error, ret(1) = 0x32
Oct 27 20:44:10 MediaPC kernel: [1017225.901286] s5h1411_readreg: readreg error (ret == -5)
Oct 27 20:44:10 MediaPC kernel: [1017225.901301] saa7164_cmd_send() No free sequences
Oct 27 20:44:10 MediaPC kernel: [1017225.901303] saa7164_api_i2c_write() error, ret(1) = 0xc
Oct 27 20:44:10 MediaPC kernel: [1017225.901306] s5h1411_writereg: writereg error 0x19 0xf7 0x0000, ret == -5)

And both recordings lock up.

I rebooted to clear the error,and I'm back to the occasional read error
(~1 a day) Not sure if it's been pushed that hard since (recording off
both tuners simultaneously)

Is this useful info? I've got the whole log, and haven't updated the
code yet. I'm willing to do tests, compile other changesets, etc.

Ross
-- 
Ross Reedstrom, Ph.D.                                 reedstrm@rice.edu
Systems Engineer & Admin, Research Scientist        phone: 713-348-6166
The Connexions Project      http://cnx.org            fax: 713-348-3665
Rice University MS-375, Houston, TX 77005
GPG Key fingerprint = F023 82C8 9B0E 2CC6 0D8E  F888 D3AE 810E 88F0 BEDE
