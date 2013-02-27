Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:46993 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3B0WKx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 17:10:53 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so917980eek.15
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2013 14:10:52 -0800 (PST)
Message-ID: <512E8469.7000404@gmail.com>
Date: Wed, 27 Feb 2013 23:10:49 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 01/11] s2255: convert to the control framework.
References: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl> <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com> <512D355F.2010309@gmail.com> <201302271005.17713.hverkuil@xs4all.nl>
In-Reply-To: <201302271005.17713.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/27/2013 10:05 AM, Hans Verkuil wrote:
> On Tue 26 February 2013 23:21:19 Sylwester Nawrocki wrote:
>> On 02/26/2013 06:35 PM, Hans Verkuil wrote:
[...]
> Private controls always had overlapping IDs. During one of the mini-summits
> last year we decided to change that so they all had their own ID. The meye
> driver is one of the first to have a proper range defined, eventually all
> other drivers that have private controls will be added there. That includes
> those you found with grep.
>
> So give me time and it will all be fixed :-)

Ah, that's the whole plan then! It indeed makes sense. I just thought 
only new
drivers would use fixed not overlapping control IDs. But having the existing
ones fixed as well sounds a way better.

Regards,
Sylwester
