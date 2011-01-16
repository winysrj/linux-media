Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2019 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1APRzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 12:55:33 -0500
Received: from tschai.localnet (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p0GHtRTn096268
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 16 Jan 2011 18:55:32 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.38] v4l2-ctrls: fix missing read-only check causing kernel oops
Date: Sun, 16 Jan 2011 18:55:22 +0100
References: <201101161636.34558.hverkuil@xs4all.nl>
In-Reply-To: <201101161636.34558.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101161855.22328.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, January 16, 2011 16:36:34 Hans Verkuil wrote:
> Hi Mauro,
> 
> This fixes a nasty little bug that I just found with v4l2-compliance.
> 
> I'm writing lots of compliance tests for control handling at the moment and
> the results are rather, erm, disheartening to use a polite word :-(

Added this fix as well:

      v4l2-ctrls: queryctrl shouldn't attempt to replace V4L2_CID_PRIVATE_BASE IDs

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit a9ac9ac36d6b199074f9545b25154fa4771ed3f4:
>   Hans Verkuil (1):
>         [media] v4l2-ctrls: v4l2_ctrl_handler_setup must set is_new to 1
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/hverkuil/media_tree.git ctrl-fix
> 
> Hans Verkuil (1):
>       v4l2-ctrls: fix missing 'read-only' check
> 
>  drivers/media/video/v4l2-ctrls.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
