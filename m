Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3417 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3BDNfn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2013 08:35:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Arvydas Sidorenko <asido4@gmail.com>
Subject: Re: [RFC PATCH 1/8] stk-webcam: various fixes.
Date: Mon, 4 Feb 2013 14:35:26 +0100
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl> <CALF0-+VvLRmLJB3g=sM4nMPmR=fQS_BnS_j2UmPPwKzt-112KA@mail.gmail.com>
In-Reply-To: <CALF0-+VvLRmLJB3g=sM4nMPmR=fQS_BnS_j2UmPPwKzt-112KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302041435.26878.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon February 4 2013 14:23:55 Ezequiel Garcia wrote:
> Hello Hans,
> 
> On Mon, Feb 4, 2013 at 9:36 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > This patch series updates this driver to the control framework, switches
> > it to unlocked_ioctl, fixes a variety of V4L2 compliance issues.
> >
> > It compiles, but to my knowledge nobody has hardware to test this :-(
> >
> > If anyone has hardware to test this, please let me know!
> >
> 
> I've sent a patch for stk-webcam recently and Arvydas Sidorenko (in
> Cc) was kind enough to test it.
> 
> @Arvydas: If you're not too busy, we'd really appreciate a lot
> if you can test this series.

Hi Arvydas,

Yes indeed, it would be great if you could test this!

Note that the patch series is also available in my git tree:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/stkwebcam

Besides the normal testing that everything works as expected, it would also
be great if you could run the v4l2-compliance tool. It's part of the v4l-utils
repository (http://git.linuxtv.org/v4l-utils.git) and it tests whether a driver
complies to the V4L2 specification.

Just compile the tool from the repository (don't use a distro-provided version)
and run it as 'v4l2-compliance -d /dev/videoX' and mail me the output. You will
get at least one failure at the end, but I'd like to know if there are other
issues remaining.

Regards,

	Hans
