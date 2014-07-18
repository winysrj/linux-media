Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46576 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbaGRQ2R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 12:28:17 -0400
Message-ID: <53C94B1F.40106@iki.fi>
Date: Fri, 18 Jul 2014 19:28:15 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] airspy: print notice to point SDR API is not 100%
 stable yet
References: <1405645513-25616-1-git-send-email-crope@iki.fi> <1405645513-25616-3-git-send-email-crope@iki.fi> <53C8AD58.1000200@xs4all.nl>
In-Reply-To: <53C8AD58.1000200@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 07/18/2014 08:15 AM, Hans Verkuil wrote:
> On 07/18/2014 03:05 AM, Antti Palosaari wrote:
>> Print notice on driver load: "SDR API is still slightly
>> experimental and functionality changes may follow". It is just
>> remind possible used SDR API is very new and surprises may occur.

>
> On that topic: I would like to see a 'buffersize' or 'samples_per_buffer'
> field in struct v4l2_sdr_format. That gives applications the opportunity
> to 1) get the current buffer size and 2) be able to change it if the driver
> supports that. E.g. for high sampling rates they might want to use larger
> buffers, for low they might want to select smaller buffers.
>
> Right now it is fixed and you won't know the buffer size until you do
> QUERYBUF. Which is not in sync with what other formats do.

I understand what you mean. If you use mmap or userptr then you would 
like to really know how much data you will get per buffer, but if you 
use read then it has no meaning.

I prefer 'buffersize' over 'samples_per_buffer', just because some 
formats are very complex, packed and compressed, and calculating 
'buffersize' from 'samples_per_buffer' could be quite complex.

It is also possible report both, but then you should decide how handle 
situation on S_FMT. Another should be zero and driver uses the one which 
has value !zero.


regards
Antti

-- 
http://palosaari.fi/
