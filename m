Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:47395 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab0FNWuQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 18:50:16 -0400
Message-ID: <4C16B236.7080506@gmail.com>
Date: Mon, 14 Jun 2010 15:50:30 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Edward Shishkin <edward.shishkin@gmail.com>
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
	debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
	linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8]reiserfs:stree.c Fix variable set but not used.
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-2-git-send-email-justinmattock@gmail.com> <4C1699AA.3000900@gmail.com> <4C169D71.90800@gmail.com> <4C16A372.6020604@gmail.com>
In-Reply-To: <4C16A372.6020604@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2010 02:47 PM, Edward Shishkin wrote:
> Justin P. Mattock wrote:
>> On 06/14/2010 02:05 PM, Edward Shishkin wrote:
>>> Justin P. Mattock wrote:
>>>> Not sure if this is correct or not.
>>>> the below patch gets rid of this warning message
>>>> produced by gcc 4.6.0
>>>>
>>>> fs/reiserfs/stree.c: In function 'search_by_key':
>>>> fs/reiserfs/stree.c:602:6: warning: variable
>>>> 'right_neighbor_of_leaf_node' set but not used
>>>>
>>>> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>>>
>>> Acked-by: Edward Shishkin <edward.shishkin@gmail.com>
>>>
>>
>> o.k.!!
>> what about the whitespace issue?
>
> Whitespaces should be removed.
> I recommend quilt package for managing patches:
> "quilt refresh --strip-trailing-whitespace" is your friend..
>
> Thanks,
> Edward.
>

o.k. I resent this.. fixed the whitespace(hopefully)
and add your Acked to it.
as for quilt I'll have to look into that..
(using a lfs system, so if the sourcecode is easy
to deal with(build), then it's a good but if it becomes
a nightmare maybe not!!).


Justin P. Mattock
