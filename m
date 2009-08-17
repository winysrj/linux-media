Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3181 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZHQSqk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 14:46:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif capture driver
Date: Mon, 17 Aug 2009 20:46:34 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
References: <1250283702-5582-1-git-send-email-m-karicheri2@ti.com> <200908151409.44219.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE40145300B49@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40145300B49@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908172046.34453.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 17 August 2009 16:52:20 Karicheri, Muralidharan wrote:
> Hans,
> 
> They are applied against davinci tree (also mentioned in the patch). General procedure what I follow is to create platform code against davinci tree and v4l patches against v4l-dvb linux-next tree. The architecture part of linux-next is not up to date.
> 
> Davinci tree is at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git

I must have missed the mention of this tree.

I have a problem, though, as the current v4l-dvb repository doesn't compile
against the linux-davinci git tree. And the only way I can get it to compile
is to apply all five patches first.

However, the whole tree should still compile after each patch is applied. And
that goes wrong with your second patch where the Kconfig and Makefile are
modified when the new sources aren't even added yet!

What I would like to see is a patch series that starts with one patch that
makes the current v4l-dvb tree compile again, then the arch patch is added,
then a series of v4l-dvb patches in such an order that everything compiles
after each step.

Merging this is already complicated enough without breaking compilation in
this way.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
