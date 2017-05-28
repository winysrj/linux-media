Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51267 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751129AbdE1PEr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 11:04:47 -0400
Date: Sun, 28 May 2017 16:04:30 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 03/16] lirc_dev: correct error handling
Message-ID: <20170528150429.GA18977@gofer.mess.org>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
 <149365463117.12922.15518669536847504845.stgit@zeus.hardeman.nu>
 <20170521085712.GA29355@gofer.mess.org>
 <20170528082337.2hk4zwfi47xzjqea@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170528082337.2hk4zwfi47xzjqea@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 28, 2017 at 10:23:37AM +0200, David Härdeman wrote:
> On Sun, May 21, 2017 at 09:57:13AM +0100, Sean Young wrote:
> >On Mon, May 01, 2017 at 06:03:51PM +0200, David Härdeman wrote:
> >> If an error is generated, nonseekable_open() shouldn't be called.
> >
> >There is no harm in calling nonseekable_open(), so this commit is
> >misleading.
> 
> I'm not sure why you consider it misleading? If there's an error, the
> logic thing to do is to error out immediately and not do any further
> work?

The commit message says that nonseekable_open() should not be called,
suggesting there is a bug which is not the case.


Sean
