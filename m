Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:50783 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaIAPpg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 11:45:36 -0400
Message-ID: <5404949A.5060006@collabora.com>
Date: Mon, 01 Sep 2014 11:45:30 -0400
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org
Subject: Re: s5p-mfc should allow multiple call to REQBUFS before we start
 streaming
References: <5400844A.5030603@collabora.com> <06ac01cfc5c9$248443e0$6d8ccba0$%debski@samsung.com>
In-Reply-To: <06ac01cfc5c9$248443e0$6d8ccba0$%debski@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2014-09-01 05:43, Kamil Debski a écrit :
> Hi Nicolas,
>
>
>> From: Nicolas Dufresne [mailto:nicolas.dufresne@collabora.com]
>> Sent: Friday, August 29, 2014 3:47 PM
>>
>> Hi Kamil,
>>
>> after a discussion on IRC, we concluded that s5p-mfc have this bug that
>> disallow multiple reqbufs calls before streaming. This has the impact
>> that it forces to call REQBUFS(0) before setting the new number of
>> buffers during re-negotiation, and is against the spec too.
> I was out of office last week. Could you shed more light on this subject?
> Do you have the irc log?

Sorry I didn't record this one, but feel free to ping Hans V.
>> As an example, in reqbufs_output() REQBUFS is only allowed in
>> QUEUE_FREE state, and setting buffers exits this state. We think that
>> the call to
>> <http://lxr.free-
>> electrons.com/ident?i=reqbufs_output>s5p_mfc_open_mfc_inst()
>> should be post-poned until STREAMON is called.
>> <http://lxr.free-electrons.com/ident?i=reqbufs_output>
> How is this connected to the renegotiation scenario?
> Are you sure you wanted to mention s5p_mfc_open_mfc_inst?
This limitation in MFC causes an important conflict between old videobuf 
and new videobuf2 drivers. Old videobuf driver (before Hans G. proposed 
patch) refuse REQBUFS(0). As MFC code has this bug that refuse 
REBBUFS(N) if buffers are already allocated, it makes all this 
completely incompatible. This open_mfc call seems to be the only reason 
REQBUFS() cannot be called multiple time, though I must say you are 
better placed then me to figure this out.

cheers,
Nicolas
