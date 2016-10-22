Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:46206 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936000AbcJVPE3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Oct 2016 11:04:29 -0400
Date: Sat, 22 Oct 2016 09:04:21 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org Mailing List" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 0/4] reST-directive kernel-cmd / include contentent from
 scripts
Message-ID: <20161022090421.722a6851@lwn.net>
In-Reply-To: <20161022085629.6ebbc4f6@vento.lan>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
        <87oa2xrhqx.fsf@intel.com>
        <20161006103132.3a56802a@vento.lan>
        <87lgy15zin.fsf@intel.com>
        <20161006135028.2880f5a5@vento.lan>
        <8737k8ya6f.fsf@intel.com>
        <8E74FF11-208D-4C76-8A8C-2B2102E5CB20@darmarit.de>
        <20161021160543.264b8cf2@lwn.net>
        <20161022085629.6ebbc4f6@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 22 Oct 2016 08:56:29 -0200
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> The security implications will be the same if either coded as an
> "ioctl()" or as "syscall", the scripts should be audited. Actually,
> if we force the need of a "syscall" for every such script, we have
> twice the code to audit, as both the Sphinx extension and the perl
> script will need to audit, increasing the attack surface.

Just addressing this one part for the moment.  Clearly I've not explained
my concern well.

The kernel-cmd directive makes it possible for *any* RST file to run
arbitrary shell commands.  I'm not concerned about the scripts we add, I
hope we can get those right.  I'm worried about what slips in via a tweak
to some obscure .rst file somewhere.

A quick check says that 932 commits touched Documentation/ since 4.8.  A
lot of those did not come from either my tree or yours; *everybody* messes
around in the docs tree.  People know to look closely at changes to
makefiles and such; nobody thinks to examine documentation changes for
such things. I think there are attackers out there who would like the
opportunity to run commands in the settings where kernels are built; we
need to think pretty hard before we make that easier to do.

See what I'm getting at here?

jon
