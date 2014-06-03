Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1071 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaFCJtI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 05:49:08 -0400
Message-ID: <538D99DE.8040602@xs4all.nl>
Date: Tue, 03 Jun 2014 11:48:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 0/2] v4l-utils: Add missing v4l2-mediabus.h header
References: <1401756292-27676-1-git-send-email-laurent.pinchart@ideasonboard.com> <538D70AD.8090800@xs4all.nl> <7921712.MU9v3dyUpo@avalon>
In-Reply-To: <7921712.MU9v3dyUpo@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/14 11:46, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 03 June 2014 08:52:29 Hans Verkuil wrote:
>> On 06/03/2014 02:44 AM, Laurent Pinchart wrote:
>>> Hello,
>>>
>>> This patch set adds the missing v4l2-mediabus.h header, required by
>>> media-ctl. Please see individual patches for details, they're pretty
>>> straightforward.
>>
>> Nack.
>>
>> The kernel headers used in v4l-utils are installed via 'make
>> sync-with-kernel'. So these headers shouldn't be edited, instead
>> Makefile.am should be updated. In particular, that's where the missing
>> header should be added.
> 
> I had seen mentions of sync-with-kernel and for some reason thought it was a 
> script. As I couldn't find it in the repository I decided to sync the headers 
> manually :-/
> 
> Thanks for fixing the problem. By the way, what would you think about 
> modifying sync-with-kernel to use installed kernel headers ?

Patches are welcome!

:-)

Regards,

	Hans
