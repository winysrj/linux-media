Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3309 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2L1KZ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 05:25:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [patch 00/03 v2] driver for Masterkit MA901 usb radio
Date: Fri, 28 Dec 2012 11:24:51 +0100
Cc: linux-media@vger.kernel.org, dougsland@gmail.com
References: <1352703366.5567.18.camel@linux>
In-Reply-To: <1352703366.5567.18.camel@linux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201212281124.51772.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon November 12 2012 07:56:06 Alexey Klimov wrote:
> Hi all,
> 
> This is second version of small patch series for ma901 usb radio driver.
> Initial letter about this usb radio was sent on October 29 and can be
> found here: http://www.spinics.net/lists/linux-media/msg55779.html
> 
> Changes:
>         - removed f->type check and set in vidioc_g_frequency()
>         - added maintainers entry patch

For the whole patch series:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

PS: Sorry for the late reply. The 'Date:' line of these emails was November 12, but
they were sent on November 27! So my email client sorted them way down in the list,
out of sight. You might want to check the date in the future...
