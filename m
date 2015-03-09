Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:35167 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754685AbbCIQHL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:07:11 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id D1DBB2A007E
	for <linux-media@vger.kernel.org>; Mon,  9 Mar 2015 17:07:06 +0100 (CET)
Message-ID: <54FDC52A.9090300@xs4all.nl>
Date: Mon, 09 Mar 2015 17:07:06 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/29] vivid: add support for 4:2:0 formats
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/09/2015 04:44 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series adds support for most of the 4:2:0 formats that V4L2 has.
> In addition, it fixes various bugs, adds some new features and refactors
> the test pattern generation code.
> 
> The first 8 patches fix bugs and add support for new red/blue checkerboard
> patterns.
> 
> Patches 9-19 add 4:2:0 support to the test pattern generator code.
> 
> Patches 20-25 refactors the test pattern generation function which become
> much, much too large.
> 
> Patches 26-28 add vivid driver support for the 4:2:0 formats and the last
> patch finally enables support for the new formats.
> 
> Besides the new 4:2:0 formats support was also added for PIX_FMT_GREY and
> some missing 4:2:2 formats.

Before I forget: an updated v4l-utils with qv4l2 support for all the new
formats is here:

http://git.linuxtv.org/cgit.cgi/hverkuil/v4l-utils.git/log/?h=yuv420

Regards,

	Hans
