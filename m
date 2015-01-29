Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:33162 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbA2LeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 06:34:10 -0500
Message-ID: <1422530027.4604.32.camel@stgolabs.net>
Subject: Re: [PATCH v5] media: au0828 - convert to use videobuf2
From: Davidlohr Bueso <dave@stgolabs.net>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: m.chehab@samsung.com, hans.verkuil@cisco.com,
	dheitmueller@kernellabs.com, prabhakar.csengg@gmail.com,
	sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	ttmesterr@gmail.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Thu, 29 Jan 2015 03:13:47 -0800
In-Reply-To: <54C96D4C.6070200@osg.samsung.com>
References: <1422042075-7320-1-git-send-email-shuahkh@osg.samsung.com>
	 <54C96D4C.6070200@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2015-01-28 at 16:14 -0700, Shuah Khan wrote:
> On 01/23/2015 12:41 PM, Shuah Khan wrote:
> > Convert au0828 to use videobuf2. Tested with NTSC.
> > Tested video and vbi devices with xawtv, tvtime,
> > and vlc. Ran v4l2-compliance to ensure there are
> > no failures. 
> > 
> > Video compliance test results summary:
> > Total: 75, Succeeded: 75, Failed: 0, Warnings: 18
> > 
> > Vbi compliance test results summary:
> > Total: 75, Succeeded: 75, Failed: 0, Warnings: 0
> > 
> > Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> > ---
> 
> Hi Hans,
> 
> Please don't pull this in. Found a bug in stop_streaming() when
> re-tuning that requires re-working this patch.

... and also:

 drivers/media/usb/au0828/Kconfig        |   2 +-
 drivers/media/usb/au0828/au0828-vbi.c   | 122 ++--
 drivers/media/usb/au0828/au0828-video.c | 962 ++++++++++++--------------------
 drivers/media/usb/au0828/au0828.h       |  61 +-
 4 files changed, 443 insertions(+), 704 deletions(-)

in a single patch. Lets be nice to reviewers, we can spare a few extra
hash ids.

