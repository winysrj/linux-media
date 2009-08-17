Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4834 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926AbZHQU1N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 16:27:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif capture driver
Date: Mon, 17 Aug 2009 22:27:11 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
References: <1250283702-5582-1-git-send-email-m-karicheri2@ti.com> <200908172046.34453.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE40145300E82@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40145300E82@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908172227.11300.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 17 August 2009 22:10:04 Karicheri, Muralidharan wrote:
> Hans,
> 
> Would you like the architecture specific changes against v4l-dvb linux-next tree or linux-davinci ? I will rework both the vpfe and vpif patches as per your comment.

v4l-dvb linux-next. The current v4l-dvb at least compiles against that one, so
that is the most appropriate tree to do the patches against.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
