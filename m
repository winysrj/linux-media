Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41488 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934036Ab1J3Ohs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 10:37:48 -0400
Received: by bkbzt4 with SMTP id zt4so1507926bkb.19
        for <linux-media@vger.kernel.org>; Sun, 30 Oct 2011 07:37:47 -0700 (PDT)
Message-ID: <4EAD6139.40803@gmail.com>
Date: Sun, 30 Oct 2011 15:37:45 +0100
From: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: budget-av problem with inserted CAM (KNC1 DVB-C TDA10024)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello! (again)

Am I the only one with a KNC1 DVB-C TDA10024(clone) card that is trying 
to use a CAM(smit)?
Is there anyone else that have got this to work? In the code it says 
it's compatible with TDA10023 som the KNC1 DVB-C MK3 card should be 
identical? (It's identical in code anyway)

Symtoms: TS streams gets corrupted when CAM is inserted. This is both 
with unencrypted and encrypted channels. When it's not inserted 
unencrypted streams works without any problems.
(works without a problem in my Philips TV and the TV is connected to the 
output of the PCI-card so it cannot be a signal problem).

When searching the net I found a reference to a old patch that said 
something about having a different clock whenever the CAM is inserted 
but that code got removed a number of commits later(it was also for the 
TDA10021).

So am I alone?
