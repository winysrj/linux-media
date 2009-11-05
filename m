Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd16922.kasserver.com ([85.13.137.202]:53276 "EHLO
	dd16922.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbZKEHnl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 02:43:41 -0500
Received: from dd16922.kasserver.com (kasmail1.kasserver.com [85.13.137.172])
	by dd16922.kasserver.com (Postfix) with SMTP id 62EB710FC244
	for <linux-media@vger.kernel.org>; Thu,  5 Nov 2009 08:37:38 +0100 (CET)
In-Reply-To: <26256.64.213.30.2.1257398603.squirrel@webmail.exetel.com.au>
Subject: =?UTF-8?B?QnVpbGRpbmcgYSBkaXN0cmlidXRpb24gd2l0aCB2NGwtZHZiIA==?=
from: vdr@helmutauer.de
to: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20091105073738.62EB710FC244@dd16922.kasserver.com>
Date: Thu,  5 Nov 2009 08:37:38 +0100 (CET)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

For my (hopefully) soon to be released Version of Gen2VDR (Gentoo based Distribution with xbmc& VDR ), i have to decide which v4l drivers I have to choose.
As always I do not use the kernel modules, because the v4l.dvb repository is more flexible and more uptodate.
My knowledge about the difference of some v4l-dvb trees is the following:

- v4l-dvb is the main tree
- liplianin is needed for several DVB-S(2) cards (Skystar2 HD e.g), but does not work with KNC One DVB-S2.
- For the TT 1600 S2 powarmans repository is the best
- MediaPointer DVB-S2 Dual lowprofile has its own repository.
- For reelmultedia's netceiver a patch is necessary

Please add your comments to these statements, and tell me whats correct and what not.
I know I have to build several dvb driver packages for the distri, but it would be helpful to take the best one's ;)

Any help is appreciated.

Helmut Auer



