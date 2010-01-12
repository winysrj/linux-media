Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:40256 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab0ALL2y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2010 06:28:54 -0500
Message-ID: <4B4C5CEF.5060601@gmail.com>
Date: Tue, 12 Jan 2010 12:28:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: mchehab@redhat.com, hverkuil@xs4all.nl, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] media: video/cx18, fix potential null dereference
References: <1263113806-7532-1-git-send-email-jslaby@suse.cz> <1263253709.4116.1.camel@palomino.walls.org>
In-Reply-To: <1263253709.4116.1.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/12/2010 12:48 AM, Andy Walls wrote:
> On Sun, 2010-01-10 at 09:56 +0100, Jiri Slaby wrote:
>> Stanse found a potential null dereference in cx18_dvb_start_feed
>> and cx18_dvb_stop_feed. There is a check for stream being NULL,
>> but it is dereferenced earlier. Move the dereference after the
>> check.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> 
> Reviewed-by: Andy Walls <awalls@radix.net>
> Acked-by: Andy Walls <awalls@radix.net>

You definitely know the code better, have you checked that it can happen
at all? I mean may demux->priv be NULL?
