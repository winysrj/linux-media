Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:60947 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550AbbIMTTq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 15:19:46 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 58ACA2A009D
	for <linux-media@vger.kernel.org>; Sun, 13 Sep 2015 21:18:32 +0200 (CEST)
Message-ID: <55F5CC08.1010300@xs4all.nl>
Date: Sun, 13 Sep 2015 21:18:32 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/4] v4l2: add support for the SMPTE 2084 transfer function
References: <1442171721-13058-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1442171721-13058-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/2015 09:15 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This transfer function is used in High Dynamic Range content. It can be signaled
> via the new HDMI Dynamic Range and Mastering InfoFrame (defined in CEA-861.3).

Forgot to mention: this patch series sits up top of the series adding DCI-P3 colorspace
support.

Also, a version of v4l-utils that understands both this new transfer function and
the DCI-P3 colorspace is available here:

http://git.linuxtv.org/cgit.cgi/hverkuil/v4l-utils.git/log/?h=dcip3

Regards,

	Hans
