Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:55971 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761939AbbA1UqZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 15:46:25 -0500
Message-ID: <54C8B7A3.9050801@xs4all.nl>
Date: Wed, 28 Jan 2015 11:19:15 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: sadegh abbasi <sadegh612000@yahoo.co.uk>
Subject: Re: [PATCH v2 1/6] v4l2-ctrls: Add new S8, S16 and S32 compound control
 types
References: <1422436639-18292-1-git-send-email-laurent.pinchart@ideasonboard.com> <1422436639-18292-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1422436639-18292-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/28/15 10:17, Laurent Pinchart wrote:
> Only unsigned compound types are implemented so far, add the
> corresponding signes types.

Nitpick: signes -> signed

Regards,

	Hans

> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>


