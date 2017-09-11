Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:57100 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750969AbdIKX0F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 19:26:05 -0400
Date: Tue, 12 Sep 2017 00:25:28 +0100
From: Alan Cox <alan@llwyncelyn.cymru>
To: Vincent Hervieux <vincent.hervieux@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        rvarsha016@gmail.com, dan.carpenter@oracle.com,
        fengguang.wu@intel.com, daeseok.youn@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] staging: atomisp: activate ATOMISP2401 support
Message-ID: <20170912002528.615d0e40@alans-desktop>
In-Reply-To: <cover.1505142435.git.vincent.hervieux@gmail.com>
References: <cover.1505142435.git.vincent.hervieux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 11 Sep 2017 20:49:27 +0200
Vincent Hervieux <vincent.hervieux@gmail.com> wrote:

> Currently atomisp module supports Intel's Baytrail SoC and contains
> some compilation switches to support Intel's Cherrytrail SoC instead.
> The patchset aims to :
> - 1/2: activate ATOMISP2400 or ATOMISP2401 from the menu.
> - 2/2: fix compilation errors for ATOMISP2401.
> I'm not so confident with patch 2/2, as it is only working around the non declared functions by using the 2400 path. As I couln't find any declaration/definition for the ISP2401 missing functions...So any help would be appreciated.
> Also patch 2/2 doesn't correct any cosmetic changes reported by checkpatch.pl as explained in TODO step 6.

Please don't. Right now we know what work is to be done and tested.

Alan
