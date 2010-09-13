Return-path: <mchehab@localhost.localdomain>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1243 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0IMKVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 06:21:49 -0400
Received: from tschai.localnet (186.84-48-119.nextgentel.com [84.48.119.186])
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id o8DALlWQ084110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 13 Sep 2010 12:21:48 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.37] Documentation fixes & updates
Date: Mon, 13 Sep 2010 12:21:48 +0200
References: <201009111711.05528.hverkuil@xs4all.nl>
In-Reply-To: <201009111711.05528.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131221.48509.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

On Saturday, September 11, 2010 17:11:05 Hans Verkuil wrote:
> The following changes since commit 57fef3eb74a04716a8dd18af0ac510ec4f71bc05:
>   Richard Zidlicky (1):
>         V4L/DVB: dvb: fix smscore_getbuffer() logic
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/hverkuil/v4l-dvb.git misc1
> 
> Hans Verkuil (5):
>       V4L Doc: removed duplicate link
>       V4L Doc: fix DocBook syntax errors.
>       V4L Doc: document V4L2_CAP_RDS_OUTPUT capability.
>       V4L Doc: clarify the V4L spec.
>       V4L Doc: correct the documentation for VIDIOC_QUERYMENU.
> 
>  Documentation/DocBook/v4l/common.xml               |   93 +++++--------------
>  Documentation/DocBook/v4l/controls.xml             |    3 -
>  Documentation/DocBook/v4l/pixfmt-packed-rgb.xml    |    2 +-
>  Documentation/DocBook/v4l/pixfmt.xml               |    4 +-
>  Documentation/DocBook/v4l/vidioc-g-dv-preset.xml   |    3 +-
>  Documentation/DocBook/v4l/vidioc-g-dv-timings.xml  |    3 +-
>  .../DocBook/v4l/vidioc-query-dv-preset.xml         |    2 +-
>  Documentation/DocBook/v4l/vidioc-querycap.xml      |    7 ++-
>  Documentation/DocBook/v4l/vidioc-queryctrl.xml     |   18 +++--
>  9 files changed, 49 insertions(+), 86 deletions(-)
> 
> 

Disregard this pull request. I'm preparing a new one with Andy's suggestions
included and more doc fixes relating to the control framework.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
