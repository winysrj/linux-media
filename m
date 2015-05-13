Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:33035 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932611AbbEMI2R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 04:28:17 -0400
Message-ID: <55530B17.4050606@xs4all.nl>
Date: Wed, 13 May 2015 10:28:07 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH v6 06/11] cec: add HDMI CEC framework
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com> <1430760785-1169-7-git-send-email-k.debski@samsung.com>
In-Reply-To: <1430760785-1169-7-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Here is the first cec-compliance bug report:

CEC_G_CAPS doesn't zero the reserved field!

cec.c needs a memset there.

I think this is missing in cec.c for all structs with a reserved
field in them. Only G_EVENT looks to be OK.

Regards,

	Hans
