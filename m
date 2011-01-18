Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53937 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab1ARWRN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 17:17:13 -0500
Received: by qyj19 with SMTP id 19so3730336qyj.19
        for <linux-media@vger.kernel.org>; Tue, 18 Jan 2011 14:17:12 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 18 Jan 2011 23:17:11 +0100
Message-ID: <AANLkTi=bv+NkwS+ASUDeAjbpNht8+YJaPRKYF7TTZDes@mail.gmail.com>
Subject: Upstreaming syntek driver
From: Luca Tettamanti <kronos.it@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Nicolas VIVIEN <progweb@free.fr>
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,
I'm a "lucky" owner of a Syntek USB webcam (embedded on my Asus
laptop); as you might know Nicolas (CC) wrote a driver for these
cams[1][2], but it's still not included in mainline kernel.
Since I'd rather save myself and the other users the pain of compiling
an out-of-tree driver I'm offering my help to make the changes
necessary to see this driver upstreamed; I'm already a maintainer of
another driver (in hwmon), so I'm familiar with the development
process.
>From a quick overview of the code I've spotted a few problems:
- minor style issues, trivially dealt with
- missing cleanups in error paths, idem
- possible memory leak, reported on the bug tracker - requires investigation
- big switch statements for all the models, could be simplified with
function pointers

Another objection could be that the initialization is basically
writing magic numbers into magic registers... I guess that Nicolas
recorded the initialization sequence with a USB sniffer. No solution
for this one; does anybody have a contact inside Syntek?

Are there other issues blocking the inclusion of this driver?

Luca
[1] http://syntekdriver.sourceforge.net/
[2] http://syntekdriver.svn.sourceforge.net/viewvc/syntekdriver/trunk/
