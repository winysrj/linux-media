Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:50998 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbZBDWlx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2009 17:41:53 -0500
Date: Wed, 4 Feb 2009 16:53:48 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Adam Baker <linux@baker-net.org.uk>
cc: Andy Walls <awalls@radix.net>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
In-Reply-To: <200902042234.37125.linux@baker-net.org.uk>
Message-ID: <alpine.LNX.2.00.0902041647470.3988@banach.math.auburn.edu>
References: <200901192322.33362.linux@baker-net.org.uk> <200902042138.05028.linux@baker-net.org.uk> <alpine.LNX.2.00.0902041610030.3988@banach.math.auburn.edu> <200902042234.37125.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 4 Feb 2009, Adam Baker wrote:

> On Wednesday 04 February 2009, kilgota@banach.math.auburn.edu wrote:
> <snip description of attempting to stream from 2 cameras at once>
>> 4. After removing the first camera which was plugged in, I tried to start
>> the stream from the second one. The stream will not start. A message says
>> that
>>
>> Cannot identify 'dev/video0': 2. No such file or directory.
>
> This line points to an error in your test method.
>
> You need to start the second stream with svv -d /dev/video1 to tell it to pick
> the second camera.
>
> Adam
>

Oops, right.

Well, in that case I have to report that two cameras work 
simultaneously just fine. No problem at all.

Theodore Kilgore
