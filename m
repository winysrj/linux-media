Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:35975 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab0AMLn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 06:43:57 -0500
MIME-Version: 1.0
In-Reply-To: <4B4C5CEF.5060601@gmail.com>
References: <1263113806-7532-1-git-send-email-jslaby@suse.cz>
	 <1263253709.4116.1.camel@palomino.walls.org>
	 <4B4C5CEF.5060601@gmail.com>
Date: Wed, 13 Jan 2010 15:43:54 +0400
Message-ID: <1a297b361001130343r9071b3fv93ade93264109f96@mail.gmail.com>
Subject: Re: [PATCH 1/1] media: video/cx18, fix potential null dereference
From: Manu Abraham <abraham.manu@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andy Walls <awalls@radix.net>, mchehab@redhat.com,
	hverkuil@xs4all.nl, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 12, 2010 at 3:28 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 01/12/2010 12:48 AM, Andy Walls wrote:
>> On Sun, 2010-01-10 at 09:56 +0100, Jiri Slaby wrote:
>>> Stanse found a potential null dereference in cx18_dvb_start_feed
>>> and cx18_dvb_stop_feed. There is a check for stream being NULL,
>>> but it is dereferenced earlier. Move the dereference after the
>>> check.
>>>
>>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>>
>> Reviewed-by: Andy Walls <awalls@radix.net>
>> Acked-by: Andy Walls <awalls@radix.net>
>
> You definitely know the code better, have you checked that it can happen
> at all? I mean may demux->priv be NULL?

It is highly unlikely that demux->priv becoming NULL. The only time
that could happen would be when there is a dvb register failed. But in
which case, it wouldn't reach the stage where you want to start/stop a
stream.

Regards,
Manu
