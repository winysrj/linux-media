Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:34699 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759400AbcAKKwf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 05:52:35 -0500
Subject: Re: [RFC PATCH v0] Add tw5864 driver
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Linux Media <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	devel@driverdev.osuosl.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1451785302-3173-1-git-send-email-andrey.utkin@corp.bluecherry.net>
Cc: Andrey Utkin <andrey.od.utkin@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56938969.30104@xs4all.nl>
Date: Mon, 11 Jan 2016 11:52:25 +0100
MIME-Version: 1.0
In-Reply-To: <1451785302-3173-1-git-send-email-andrey.utkin@corp.bluecherry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

On 01/03/2016 02:41 AM, Andrey Utkin wrote:
> (Disclaimer up to scissors mark)
> 
> Please be so kind to take a look at a new driver.
> We aim to follow high standards of kernel development and possibly to get this driver in mainline kernel.
> The device is multichannel video and audio capture and compression chip TW5864 of Intersil/Techwell.
> 
> The code is in repo https://github.com/bluecherrydvr/linux , branch "tw5864", subdir drivers/staging/media/tw5864 .
> This branch is regularly rebased during development, so that there's a single commit adding this driver on top of current linux-next.
> Direct link to subdir: https://github.com/bluecherrydvr/linux/tree/tw5864/drivers/staging/media/tw5864
> 
> 
> Implementation status
> 
> * H.264 streaming work stable, including concurrent work of multiple channels on same chip;
> * Audio streaming functionality is not implemented, but is considered for future;
> * The chip has motion detection capability, but of same sensitivity level for whole frame; this was considered quite limiting for our needs and we have implemented per-grid-cell sensitivity with a bit of heuristic processing of motion vector data exposed by hardware. Datasheet-suggested mechanism is not used currently.
> 
> Testing status
> 
> * Runtime tests on my test machine show that video streaming works stable. Multichannel streaming was working, but I haven't test this with latest revision lately yet.
> * Runtime performance will be tested later also on few early-adopters' CCTV machines.
> * checkpatch.pl -f on files reports no warnings, errors or style issues;
> * checkpatch.pl on patch reports no warnings, errors or style issues;
> * sparse reports nothing;
> * compilation shows no warnings (gcc 4.9.3);
> * compilation with EXTRA_CFLAGS=-W shows a lot of warnings from included headers (over 9000 lines of output). Seems this technique from Documentation/SubmitChecklist is not practical in this case
> * Other Documentation/SubmitChecklist advises weren't thoroughly worked out.

Did you also test with v4l2-compliance? Before I accept the driver I want to see the
output of 'v4l2-compliance' and 'v4l2-compliance -s'. Basically there shouldn't be
any failures.

I did a quick scan over the source and I saw nothing big. When you post the new
version I will go over it more carefully and do a proper review.

Regards,

	Hans
