Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48159 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab2FHApC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 20:45:02 -0400
Received: by obbtb18 with SMTP id tb18so1622261obb.19
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2012 17:45:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <28466140.1339113229381.JavaMail.root@elwamui-cypress.atl.sa.earthlink.net>
References: <28466140.1339113229381.JavaMail.root@elwamui-cypress.atl.sa.earthlink.net>
Date: Thu, 7 Jun 2012 20:45:02 -0400
Message-ID: <CAGoCfiy5RLXA5NoQXF7R7fJ=VwGzyvwAWSfJk7fXTif9t9Gttg@mail.gmail.com>
Subject: Re: hdpvr lockup with audio dropouts
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: sitten74490@mypacks.net
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 7, 2012 at 7:53 PM,  <sitten74490@mypacks.net> wrote:
> Apparently there is a known issue where the HD-PVR cannot handle the loss of audio signal over SPDIF while recording.  If this happens, the unit locks up requiring it to be power cycled before it can be used again. This behavior can easily be reproduced by pulling the SPDIF cable during recording.  My question is this:  are there any changes that could be made to the hdpvr driver that would make it more tolerant of brief audio dropouts?

Does it do this under Windows?  If it does, then call Hauppauge and
get them to fix it (and if that results in a firmware fix, then it
will help Linux too).  If it works under Windows, then we know it's
some sort of driver issue which would be needed.

It's always good when it's readily reproducible.  :-)

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
