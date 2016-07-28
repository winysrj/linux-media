Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0098.outbound.protection.outlook.com ([104.47.32.98]:63841
	"EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751448AbcG1XpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2016 19:45:01 -0400
From: "Bird, Timothy" <Tim.Bird@am.sony.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Shimizu, Kazuhiro" <Kazuhiro.Shimizu@sony.com>,
	"Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
	"Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
	"Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
	"Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>,
	"Berry, Tom" <Tom.Berry@sony.com>,
	"Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>,
	"Rowand, Frank" <Frank.Rowand@am.sony.com>,
	"tbird20d@gmail.com" <tbird20d@gmail.com>
Subject: Sony tuner chip driver questions
Date: Thu, 28 Jul 2016 22:12:10 +0000
Message-ID: <ECADFF3FD767C149AD96A924E7EA6EAF053BB5DA@USCULXMSG02.am.sony.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Linux-media people... :-)

A group at Sony would like to develop a proper kernel driver
for a TV/tuner chip that Sony produces, and we'd like to ask some questions
before we get started.

FYI - I'm kicking off the conversation thread, but I'm not a TV or media-driver
person, so please excuse anything that sounds strangely worded or is just
a really dumb question.  I have experts CC:ed who can clarify anything I
misstate. :-)

First some background:
The chip is in the same family as other chips for which there
are currently some kernel drivers in mainline, produced by
3rd parties (not Sony). The drivers already in the tree are
linux/media/dvb-frontend/cxd2820.c, cxd2841er.c, and ascot2e.c.

Currently Sony provides a user-space driver to its customers, but
we'd like to switch to an in-kernel driver.

The chip has a tuner and demodulator included.

First, we will be delivering the actual video data over SPI.  Currently,
we only see examples of doing this over PCI and USB busses.  Are
there any examples of the appropriate method to transfer video
data (or other high-volume data) over SPI?  If not, are there any
recommendations or tips for going about this?

Second, the current drivers for the cxd2820 and cxd2841 seem to
use a lot of hard-coded register values (and don't appear to use
device tree).  We're not sure if these drivers are the best examples
to follow in creating a new dvb driver for Linux.  Is there a 
recommended driver or example that shows the most recent or
preferred good structure for such drivers, that we should use
in starting ours?  

Is DVB is the correct kernel subsystem to use for this driver, or
is V4L more appropriate?

If we have multiple files in our driver, should we put them all in
the dvb-frontend directory, or should they be sprinkled around
in different directories based on function?  Or should we create
a 'sony' directory somewhere to hold them?

What debugging tools, if any, are available for testing dvb drivers
in the kernel?

Do any current tuner drivers support dual-tuner configurations?

Thanks for any assistance or information you can provide to help us
get started.
 -- Tim Bird
Senior Staff Software Engineer, Sony North America

P.S.  We are ramping up the project now, but will likely get to 
major development effort in a month or two.




