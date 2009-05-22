Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45538 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752850AbZEVMIb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 08:08:31 -0400
Content-Type: text/plain; charset="iso-8859-1"
Date: Fri, 22 May 2009 14:08:31 +0200
From: twta@gmx.net
Message-ID: <20090522120831.245430@gmx.net>
MIME-Version: 1.0
Subject: Dump transport stream
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello to all,

i am using a TT3200 card and the kernel modules (S2API) from the
repository (OS is opensuse 11).
Scan-s2 and szap-s2 works fine.
Tuning a channel with szap-s2 and store the data with
"cat /dev/dvb/adapter0/dvr0 > /tmp/recording.ts" also works fine.

Is it possible to dump the complette transportstream (not only one PID) to a file, like dumpTS with the old api???

Regards Chris
-- 
Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonanschluss für nur 17,95 Euro/mtl.!* http://portal.gmx.net/de/go/dsl02
