Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:47127 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755165AbbHYNoM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 09:44:12 -0400
Message-ID: <55DC7086.6040809@xs4all.nl>
Date: Tue, 25 Aug 2015 15:41:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v7 14/44] [media] media: add functions to allow creating
 interfaces
References: <cover.1440359643.git.mchehab@osg.samsung.com>	<cf82882b9cb0ab84189c6e5e4f5526165714fa2e.1440359643.git.mchehab@osg.samsung.com>	<55DC149E.2000202@xs4all.nl> <20150825062652.4a8919a3@recife.lan>
In-Reply-To: <20150825062652.4a8919a3@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/15 11:26, Mauro Carvalho Chehab wrote:
> Em Tue, 25 Aug 2015 09:09:18 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>> +	case MEDIA_INTF_T_ALSA_CONTROL:
>>> +		return "alsa_control";
>>
>> I prefer - over _, but that's a personal preference.
> 
> Well, not a good reason to use '_' instead of '-', just my personal
> preference ;)
> 
> I'm happy with either ways.

FYI: two practical reasons why I prefer '-' over '_':

1) to type '_' I need to use the Shift key, which I don't need to use for '-'.
   I'm lazy, so sue me :-)

2) '_' is sometimes hard to read if it gets close to the next line, e.g.:

	alsa_control
	try Testing

You don't have this problem with '-':

	alsa-control
	try Testing

Regards,

	Hans
