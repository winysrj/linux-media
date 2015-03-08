Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:34472 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbbCHKon (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2015 06:44:43 -0400
Date: Sun, 8 Mar 2015 10:44:41 +0000
From: Sean Young <sean@mess.org>
To: Kamil Debski <k.debski@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de,
	'Hans Verkuil' <hansverk@cisco.com>
Subject: Re: [RFC v2 3/7] cec: add new framework for cec support.
Message-ID: <20150308104441.GA3764@gofer.mess.org>
References: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
 <1421942679-23609-4-git-send-email-k.debski@samsung.com>
 <20150123110747.GA3084@gofer.mess.org>
 <086501d05828$b88bf320$29a3d960$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <086501d05828$b88bf320$29a3d960$%debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Fri, Mar 06, 2015 at 05:14:50PM +0100, Kamil Debski wrote:
> 3) As you suggested - load an empty keymap whenever the pass through mode is
> enabled.
> I am not that familiar with the RC core. Is there a simple way to switch to
> an empty map
> from the kernel? There is the ir_setkeytable function, but it is static in
> rc-main.c, so it
> cannot be used in other kernel modules. Any hints, Sean?

Why is it problematic if keypresses are passed to the input layer? 

You can only set the default keymap for an rc-device from kernel space; from
user space you can clear the table using input ioctl, see:

http://git.linuxtv.org/cgit.cgi/v4l-utils.git/tree/utils/keytable/keytable.c#n1277

You can select MAP_EMPTY as the default keymap if that is appropriate; using
ir-setkeytable(1) a different keymap can be selected.


Sean
