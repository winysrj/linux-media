Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:33262 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab0KPXbM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 18:31:12 -0500
Date: Wed, 17 Nov 2010 00:31:09 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: media_tree.git weirdness
Message-ID: <20101116233109.GA28334@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

the current state of the staging/for_v2.6.38 branch seems a bit weird
with regard to the three patches to use raw decoding for the Encore FM
5.3, resulting cleanups to saa7134 and removal of ir-common.

I still see drivers/media/rc/ir-functions.c in my local repo (and using
the web interface), and the cleanups to saa7134 do not seem to be
there...

-- 
David Härdeman
