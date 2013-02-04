Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab3BDNKy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Feb 2013 08:10:54 -0500
Message-ID: <510FB409.3080304@redhat.com>
Date: Mon, 04 Feb 2013 14:13:45 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 1/8] stk-webcam: various fixes.
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/04/2013 01:36 PM, Hans Verkuil wrote:
> This patch series updates this driver to the control framework, switches
> it to unlocked_ioctl, fixes a variety of V4L2 compliance issues.

Good stuff!

> It compiles, but to my knowledge nobody has hardware to test this :-(
>
> If anyone has hardware to test this, please let me know!

I've recently done some changes to stk-webcam because of upside-down issues
with it, and my changes where (eventually) tested by the upside-down
bug-reporter. I'll send you his mail-address in a private mail.

I would like to suggest to keep this series as RFC only until this is
actually tested, since this driver is still being actively used, so regressing
on it would be bad.

Regards,

Hans
