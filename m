Return-path: <mchehab@localhost>
Received: from mail.kapsi.fi ([217.30.184.167]:53961 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab1GICsa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2011 22:48:30 -0400
Message-ID: <4E17C17A.1030205@iki.fi>
Date: Sat, 09 Jul 2011 05:48:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Peter Chen <cwz0522@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: where to find the old hg repo. ?
References: <CAMwFWNYZWLRS-T_xMcJf1-RX+E2hNZ4FmGSk5Q9zpkKxarYP9Q@mail.gmail.com>
In-Reply-To: <CAMwFWNYZWLRS-T_xMcJf1-RX+E2hNZ4FmGSk5Q9zpkKxarYP9Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On 07/09/2011 05:14 AM, Peter Chen wrote:
> Dear all,
> I need the old revision of the mxl500x-af9015 to driver the USB device
> 07ca:815c from AVerMedia.
> Original path is:  http://linuxtv.org/hg/~anttip/af9015-mxl500x
>
> the wanted revision is af9015-mxl500x-1487a7dcf22a or other
> newer/latest revision.
>
> One of my friend in his company has successfully use the driver to watch TV,
> but he cannot send the source to me according company policy.
>
> Is it not integrated into mainline kernel?

I removed it since it have been inside main Kernel ages.

Are you sure product ID is 815c? Current driver does not have this ID 
and I am almost 100% sure it was never supported. You should add new 
device entry for that device to af9015.c in order to get it working. 
Please send patch.


regards
Antti


-- 
http://palosaari.fi/
