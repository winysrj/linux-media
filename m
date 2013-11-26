Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-062.synserver.de ([212.40.185.62]:1053 "EHLO
	smtp-out-025.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758356Ab3KZWCE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 17:02:04 -0500
Message-ID: <52951A7B.3020900@metafoo.de>
Date: Tue, 26 Nov 2013 23:02:35 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Valentine <valentine.barshak@cogentembedded.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <528B347E.2060107@xs4all.nl> <528C8BA1.9070706@cogentembedded.com> <528C9ADB.3050803@xs4all.nl> <528CA9E1.2020401@cogentembedded.com> <528CD86D.70506@xs4all.nl> <528CDB0B.3000109@cogentembedded.com> <52951270.9040804@cogentembedded.com> <52951604.2050603@metafoo.de> <52951961.30903@cogentembedded.com>
In-Reply-To: <52951961.30903@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/26/2013 10:57 PM, Valentine wrote:
[...]
>>
>> [...]
> 
> I'd also appreciate your thoughts about the issues I've described,
> which have been replaced by [...] here.

Those seem to be mostly issues that also apply to the adv7604 and should be
fixed anyway. Hans knows the code much better than me and will hopefully be
able to give a better answer.

- Lars
