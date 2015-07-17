Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:47000 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758538AbbGQOrD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 10:47:03 -0400
Message-ID: <55A91528.8030007@xs4all.nl>
Date: Fri, 17 Jul 2015 16:46:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv2 0/9] SDR transmitter API
References: <1437030298-20944-1-git-send-email-crope@iki.fi>
In-Reply-To: <1437030298-20944-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2015 09:04 AM, Antti Palosaari wrote:
> v2:
> * Allow device open even another device node is active. This means you
> could use transmitter device even receiver is active and other way
> around, just streaming is blocked to single node.
> 
> * Removed V4L2_CID_RF_TUNER_RF_GAIN_AUTO control as it was not used.
> 
> * Changed RF gain documentation.

FYI: I added support for SDR output to v4l2-ctl and v4l2-compliance here:

http://git.linuxtv.org/cgit.cgi/hverkuil/v4l-utils.git/log/?h=sdr

Regards,

	Hans
