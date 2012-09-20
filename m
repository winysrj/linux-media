Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:36352 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2ITJnw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 05:43:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 20 Sep 2012 11:43:46 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: <linux-media@vger.kernel.org>
Subject: Re: [PATCHv3 2/9] ir-rx51: Handle signals properly
In-Reply-To: <20120904124356.GB13018@pequod.mess.org>
References: <1346349271-28073-1-git-send-email-timo.t.kokkonen@iki.fi> <1346349271-28073-3-git-send-email-timo.t.kokkonen@iki.fi> <20120901171420.GC6638@valkosipuli.retiisi.org.uk> <50437328.9050903@iki.fi> <504375FA.1030209@iki.fi> <20120902152027.GA5236@itanic.dhcp.inet.fi> <20120902194110.GA6834@valkosipuli.retiisi.org.uk> <5043BCB4.1040308@iki.fi> <20120903123653.GA7218@pequod.mess.org> <20120903214155.GA6393@hardeman.nu> <20120904124356.GB13018@pequod.mess.org>
Message-ID: <24b0d7a51ff4595f65d7307d90cda144@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 4 Sep 2012 13:43:56 +0100, Sean Young <sean@mess.org> wrote:
> This interface is much better but it's also an ABI change. How should
this
> be handled? Should rc-core expose it's own /dev/rc[0-9] device with its
> own ioctls?

That was the plan yes. I've posted a patchbomb in the past to the
linux-media mailing list which implements a rc specific chardev with an
ioctl/read/write based API.

Since the entire patchset is a bit much to digest and merging of patches
has been slow lately, I'm trying to drip-feed the patches. The lirc TX
rework was part of that process. It basically lays the groundwork for later
patches.

//David

