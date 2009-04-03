Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfilter7.ihug.co.nz ([203.109.136.7]:30666 "EHLO
	mailfilter7.ihug.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbZDCI4N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 04:56:13 -0400
Message-ID: <49D5CF7C.2060704@yahoo.co.nz>
Date: Fri, 03 Apr 2009 21:57:32 +1300
From: Kevin Wells <wells_kevin@yahoo.co.nz>
MIME-Version: 1.0
To: Jonas Kvinge <linuxtv@closetothewind.net>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge WinTV-HVR-4000 / Nova-HD-S2
References: <49D56335.2020506@closetothewind.net>
In-Reply-To: <49D56335.2020506@closetothewind.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jonas Kvinge wrote:
> Whats the command to extract the firmware from the new driver release at
> http://www.wintvcd.co.uk/drivers/88x_2_123_27056_WHQL.zip
>
> The driver at http://www.wintvcd.co.uk/drivers/88x_2_122_26109_WHQL.zip
> is no longer available, so the link on
> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000 is broken.
>   
Hi Jonas,

I can't remember the exact command off the top of my head. But I can
tell you how to work it out.

The problem is how to determine the offset to use. Look at this hex dump
from the start of each firmware file:

    dvb-fe-cx24116-1.20.79.0.fw:
        00000000  02 11 f9 ec 33 50 03 12

    dvb-fe-cx24116-1.22.82.0.fw:
        00000000  02 11 fb ec 33 50 03 12

    dvb-fe-cx24116-1.23.86.1.fw:
        00000000  02 12 02 ec 33 50 03 12

Note the magic `33 50 03 12` bytes that appear at offset 4 in each
firmware file. You can use that to determine the offset of the firmware
in the `hcw88bda.sys` file (at least for the existing firmware files).

I used `hd hcw88bda.sys | more` and typed `/33 50 03 12` in `more` to
find the offset. Make sure to subtract 4 from the offset of the `33 50
03 12` bytes. Convert the offset from hex to decimal and use that as the
`skip` amount for the `dd` command.

Verify the extracted firmware using `md5sum`.

Perhaps when you get it to work you could update the wiki page you
mentioned.

Kevin

